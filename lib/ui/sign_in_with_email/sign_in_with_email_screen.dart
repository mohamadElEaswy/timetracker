import 'package:flutter/material.dart';
import 'package:timetracker/services/auth.dart';
import 'package:timetracker/ui/sign_in/validators.dart';
import 'package:timetracker/ui/widgets/global_button.dart';

class SignInWithEmail extends StatefulWidget with EmailAndPasswordValidation{
   SignInWithEmail({Key? key, required this.auth}) : super(key: key);
  final AuthBase auth;
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
    FocusScope.of(context).requestFocus(_passwordFocusNode);
  }

  String get _email => _emailController.text;
  String get _password => _passwordController.text;

  EmailSignInFormType _formType = EmailSignInFormType.signIn;
  void _submit() async {
    try {
      if (_formType == EmailSignInFormType.signIn) {
        await widget.auth.signInWithEmailAndPassword(_email, _password);
      } else {
        await widget.auth.createUserWithEmailAndPassword(_email, _password);
      }
      Navigator.of(context).pop();
    } catch (e) {
      print(e.toString());
    }
  }

  void _toggleFormType() {
    setState(() {
      _formType = _formType == EmailSignInFormType.signIn
          ? EmailSignInFormType.register
          : EmailSignInFormType.signIn;
    });
    _emailController.clear();
    _passwordController.clear();
  }

  void _updateState() {setState((){});}

  List<Widget> _buildChildren() {
    final String primaryText = _formType == EmailSignInFormType.signIn
        ? 'Sign in'
        : 'Create an account';
    final String secondaryText = _formType == EmailSignInFormType.signIn
        ? 'Need an account? Register'
        : 'Have an account? Sign in';
    bool submitEnabled = widget.emailValidator.isValid(_email) && widget.emailValidator.isValid(_password);
        // _email.isNotEmpty && _password.isNotEmpty;
    bool emailValid = widget.emailValidator.isValid(_email);
    bool passwordValid = widget.passwordValidator.isValid(_password);
    return [

      TextField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        autocorrect: false,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          hintText: 'test@test.com',
          label: const Text('Email'),
          errorText: emailValid ? null :  'email is required ',
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
          errorText: passwordValid ? null :  'password is required ',
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
      TextButton(onPressed: _toggleFormType, child: Text(secondaryText)),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign in With Email')),
      body: Padding(
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
    );
  }
}
