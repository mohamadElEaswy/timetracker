import 'package:flutter/material.dart';
import 'package:timetracker/services/auth.dart';
import 'package:timetracker/ui/widgets/global_button.dart';

class SignInWithEmail extends StatefulWidget {
  const SignInWithEmail({Key? key, required this.auth}) : super(key: key);
  final AuthBase auth;
  @override
  State<SignInWithEmail> createState() => _SignInWithEmailState();
}

enum EmailSignInFormType { signIn, register }

class _SignInWithEmailState extends State<SignInWithEmail> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
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

  List<Widget> _buildChildren() {
    final String primaryText = _formType == EmailSignInFormType.signIn
        ? 'Sign in'
        : 'Create an account';
    final String secondaryText = _formType == EmailSignInFormType.signIn
        ? 'Need an account? Register'
        : 'Have an account? Sign in';
    return [
      TextField(
        controller: _emailController,keyboardType: TextInputType.emailAddress,autocorrect: false,textInputAction: TextInputAction.next,
        decoration: const InputDecoration(
          hintText: 'test@test.com',
          label: Text('Email'),
        ),
      ),
      const SizedBox(height: 8),
      TextField(
        controller: _passwordController,textInputAction: TextInputAction.done,
        decoration: const InputDecoration(
          label: Text('Password'),
        ),
        obscureText: true,autocorrect: false,
      ),
      const SizedBox(height: 8),
      DefaultButton(
        text: primaryText,
        color: Colors.indigo,
        onPressed: _submit,
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
