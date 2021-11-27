import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetracker/services/auth.dart';
import 'package:timetracker/ui/sign_in/sign_in_with_email/email_sign_in_bloc.dart';
import 'package:timetracker/ui/sign_in/sign_in_with_email/sign_in_model.dart';
// import 'package:timetracker/services/auth_provider.dart';
import 'package:timetracker/ui/sign_in/validators.dart';
import 'package:timetracker/ui/widgets/exceptions.dart';
import 'package:timetracker/ui/widgets/global_button.dart';

class SignInWithEmail extends StatefulWidget with EmailAndPasswordValidation {
  SignInWithEmail({Key? key, required this.bloc}) : super(key: key);
  final EmailSignInBloc bloc;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return Provider<EmailSignInBloc>(
      create: (_) => EmailSignInBloc(auth: auth),
      child: Consumer<EmailSignInBloc>(
        builder: (_, bloc, __) => SignInWithEmail(bloc: bloc),
      ),
      dispose: (_, bloc) => bloc.dispose(),
    );
  }

  @override
  State<SignInWithEmail> createState() => _SignInWithEmailState();
}

class _SignInWithEmailState extends State<SignInWithEmail> {
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  void _emailEditingComplete(EmailSignInModel model) {
    final newFocus = widget.emailValidator.isValid(model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  Future<void> _submit() async {
    try {
      await widget.bloc.submit();
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      // showAlertDialog(context, title: 'sign in failed', content: e.message!, defaultActionString: 'OK');

      showExceptionDialog(
        context,
        title: 'sign in failed',
        exception: e,
      );
    }
  }

  void _toggleFormType(EmailSignInModel model) {
    widget.bloc.updateWith(
      email: '',
      password: '',
      formType: model.formType == EmailSignInFormType.signIn
          ? EmailSignInFormType.register
          : EmailSignInFormType.signIn,
      submitted: false,
      isLoading: false,
    );
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChildren(EmailSignInModel? model) {
    final String primaryText = model!.formType == EmailSignInFormType.signIn
        ? 'Sign in'
        : 'Create an account';
    final String secondaryText = model.formType == EmailSignInFormType.signIn
        ? 'Need an account? Register'
        : 'Have an account? Sign in';
    bool submitEnabled = widget.emailValidator.isValid(model.email) &&
        widget.emailValidator.isValid(model.password) &&
        !model.isLoading;
    // _email.isNotEmpty && _password.isNotEmpty;
    bool emailValid =
        model.submitted && widget.emailValidator.isValid(model.email);
    bool passwordValid =
        model.submitted && widget.passwordValidator.isValid(model.password);
    return [
      TextField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        autocorrect: false,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          hintText: 'test@test.com',
          label: const Text('Email'),
          errorText: emailValid ? widget.invalidEmailErrorText : null,
          enabled: model.isLoading == false,
        ),
        focusNode: _emailFocusNode,
        onEditingComplete: () => _emailEditingComplete(model),
        onChanged: (email) => widget.bloc.updateWith(email: email),
      ),
      const SizedBox(height: 8),
      TextField(
        controller: _passwordController,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          label: const Text('Password'),
          errorText: passwordValid ? widget.invalidPasswordErrorText : null,
          enabled: model.isLoading == false,
        ),
        obscureText: true,
        autocorrect: false,
        focusNode: _passwordFocusNode,
        onEditingComplete: submitEnabled ? _submit : null,
        onChanged: (password) => widget.bloc.updateWith(password: password),
      ),
      const SizedBox(height: 8),
      DefaultButton(
        text: primaryText,
        color: Colors.indigo,
        onPressed: submitEnabled ? _submit : null,
      ),
      // ElevatedButton(onPressed: () {}, child: const Text('Sign in')),
      const SizedBox(height: 8),
      TextButton(
          onPressed: !model.isLoading ? () => _toggleFormType(model) : null,
          child: Text(secondaryText)),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign in With Email')),
      body: SingleChildScrollView(
        child: StreamBuilder<EmailSignInModel>(
            stream: widget.bloc.modelStream,
            initialData: EmailSignInModel(),
            builder: (context, snapshot) {
              EmailSignInModel? model = snapshot.data;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: _buildChildren(model!),
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
