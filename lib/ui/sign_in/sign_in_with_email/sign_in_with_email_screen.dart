import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetracker/services/auth.dart';
import 'package:timetracker/ui/sign_in/sign_in_with_email/email_sign_in_bloc.dart';
import 'package:timetracker/ui/sign_in/sign_in_with_email/sign_in_model.dart';
// import 'package:timetracker/services/auth_provider.dart';
import 'package:timetracker/ui/widgets/exceptions.dart';
import 'package:timetracker/ui/widgets/global_button.dart';
import 'package:timetracker/ui/widgets/text_form_field.dart';

class SignInWithEmail extends StatefulWidget {
  const SignInWithEmail({Key? key, required this.bloc}) : super(key: key);
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
    final newFocus = model.emailValidator.isValid(model.email)
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

  void _toggleFormType() {
    widget.bloc.toggleFormType();
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChildren(EmailSignInModel? model) {
    // final String primaryText = model!.formType == EmailSignInFormType.signIn
    //     ? 'Sign in'
    //     : 'Create an account';
    // final String secondaryText = model.formType == EmailSignInFormType.signIn
    //     ? 'Need an account? Register'
    //     : 'Have an account? Sign in';
    // bool submitEnabled = model.emailValidator.isValid(model.email) &&
    //     model.emailValidator.isValid(model.password) &&
    //     !model.isLoading;

    return [
      // TextField(
      //   controller: _emailController,
      //   keyboardType: TextInputType.emailAddress,
      //   autocorrect: false,
      //   textInputAction: TextInputAction.next,
      //   decoration: InputDecoration(
      //     hintText: 'test@test.com',
      //     label: const Text('Email'),
      //     errorText: model!.emailErrorText,
      //     enabled: model.isLoading == false,
      //   ),
      //   focusNode: _emailFocusNode,
      //   onEditingComplete: () => _emailEditingComplete(model),
      //   onChanged: widget.bloc.updateEmail,
      // ),
      const SizedBox(height: 8),
      GlobalTextFormField(textInputType: TextInputType.emailAddress,textInputAction: TextInputAction.next, hintText: 'test@test.com',
        controller: _emailController,
        text: 'Email',
        errorText: model!.emailErrorText,
        enabled: model.isLoading == false,
        obscureText: false,
        focusNode: _emailFocusNode,
        onEditingComplete: () => _emailEditingComplete(model),
        onChanged: widget.bloc.updateEmail,
      ),
      const SizedBox(height: 8),
      GlobalTextFormField(textInputType: TextInputType.number,textInputAction: TextInputAction.done,
        controller: _passwordController,
        text: 'Password',
        errorText: model.passwordErrorText,
        enabled: model.isLoading == false,
        obscureText: true,
        focusNode: _passwordFocusNode,
        onEditingComplete: model.submitEnabled ? _submit : null,
        onChanged: widget.bloc.updatePassword,
      ),
      // TextField(
      //   controller: _passwordController,
      //   textInputAction: TextInputAction.done,
      //   decoration: InputDecoration(
      //     label: const Text('Password'),
      //     errorText: model.passwordErrorText,
      //     enabled: model.isLoading == false,
      //   ),
      //   obscureText: true,
      //   autocorrect: false,
      //   focusNode: _passwordFocusNode,
      //   onEditingComplete: model.submitEnabled ? _submit : null,
      //   onChanged: widget.bloc.updatePassword,
      // ),
      const SizedBox(height: 8),
      DefaultButton(
        text: model.primaryText,
        color: Colors.indigo,
        onPressed: model.submitEnabled ? _submit : null,
      ),
      // ElevatedButton(onPressed: () {}, child: const Text('Sign in')),
      const SizedBox(height: 8),
      TextButton(
          onPressed: !model.isLoading ? _toggleFormType : null,
          child: Text(model.secondaryText)),
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
