import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timetracker/services/auth.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key, required this.onSignIn, required this.auth}) : super(key: key);
  final void Function(User) onSignIn;
  final Auth auth;
  Future<void> _signInAnonymously() async {
    try {

      final user = await auth.signInAnonymously();
      onSignIn(user!);
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Time Trucker'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DefaultButton(
              onPressed: () {},
              text: 'Sing In with Google',
              color: Colors.white,
              textColor: Colors.black,
            ),
            DefaultButton(
              onPressed: () {},
              text: 'Sing In with FaceBook',
              color: Colors.blue,
            ),
            DefaultButton(
              onPressed: () {},
              text: 'Sing In with email',
              color: Colors.green,
            ),
            const Text('OR'),
            DefaultButton(
              onPressed: _signInAnonymously,
              text: 'Sing In Anonymously',
              color: Colors.amber,
            ),
          ],
        ),
      ),
    );
  }
}

class DefaultButton extends StatelessWidget {
  const DefaultButton(
      {Key? key,
      required this.text,
      required this.onPressed,
      required this.color,
      this.textColor = Colors.white})
      : super(key: key);

  final String text;
  final VoidCallback onPressed;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(color: textColor),
        ),
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(0.0),
          backgroundColor: MaterialStateProperty.all<Color>(color),
        ),
      ),
    );
  }
}
