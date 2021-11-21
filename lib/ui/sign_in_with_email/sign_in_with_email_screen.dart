import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetracker/services/auth.dart';
// import 'package:timetracker/services/auth_provider.dart';
import 'package:timetracker/ui/sign_in/validators.dart';
import 'package:timetracker/ui/widgets/global_button.dart';
import 'package:timetracker/ui/widgets/show_alert.dart';

class SignInWithEmail extends StatefulWidget with EmailAndPasswordValidation {
  SignInWithEmail({Key? key}) : super(key: key);
  @override
  State<SignInWithEmail> createState() => _SignInWithEmailState();
}

enum EmailSignInFormType { signIn, register }

class _SignInWithEmailState extends State<SignInWithEmail> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  void _emailEditingComplete() {
    final newFocus = widget.emailValidator.isValid(_email) ? _passwordFocusNode: _emailFocusNode ;
    FocusScope.of(context).requestFocus(newFocus);
  }

  String get _email => _emailController.text;
  String get _password => _passwordController.text;

  EmailSignInFormType _formType = EmailSignInFormType.signIn;

  bool _submitted = false;
  bool _isLoading = false;
  void _submit() async {
    setState(() {
      _submitted = true;
      _isLoading = true;
    });
    try {
      final auth = Provider.of<AuthBase>(context,  listen: false);
      if (_formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(_email, _password);
      } else {
        await auth.createUserWithEmailAndPassword(_email, _password);
      }
      Navigator.of(context).pop();
    } catch (e) {
      showAlertDialog(context, title: 'sign in failed', content: e.toString(), defaultActionString: 'OK');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _toggleFormType() {
    setState(() {
      _formType = _formType == EmailSignInFormType.signIn
          ? EmailSignInFormType.register
          : EmailSignInFormType.signIn;
      _submitted = false;
    });
    _emailController.clear();
    _passwordController.clear();
  }

  void _updateState() {
    setState(() {});
  }

  List<Widget> _buildChildren() {
    final String primaryText = _formType == EmailSignInFormType.signIn
        ? 'Sign in'
        : 'Create an account';
    final String secondaryText = _formType == EmailSignInFormType.signIn
        ? 'Need an account? Register'
        : 'Have an account? Sign in';
    bool submitEnabled = widget.emailValidator.isValid(_email) &&
        widget.emailValidator.isValid(_password) && !_isLoading;
    // _email.isNotEmpty && _password.isNotEmpty;
    bool emailValid = _submitted && !widget.emailValidator.isValid(_email);
    bool passwordValid =
        _submitted && !widget.passwordValidator.isValid(_password);
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
          enabled: _isLoading == false,
        ),
        focusNode: _emailFocusNode,
        onEditingComplete: _emailEditingComplete,
        onChanged: (email) => _updateState(),
      ),
      const SizedBox(height: 8),
      TextField(
        controller: _passwordController,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          label: const Text('Password'),
          errorText: passwordValid ? widget.invalidPasswordErrorText : null,
          enabled: _isLoading == false,
        ),
        obscureText: true,
        autocorrect: false,
        focusNode: _passwordFocusNode,
        onEditingComplete: submitEnabled ? _submit : null,
        onChanged: (password) => _updateState(),
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
          onPressed: !_isLoading ? _toggleFormType : null,
          child: Text(secondaryText)),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign in With Email')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: _buildChildren(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
