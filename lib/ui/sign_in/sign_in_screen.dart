import 'package:flutter/material.dart';
import 'package:timetracker/services/auth.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key, required this.auth}) : super(key: key);
  final Auth auth;
  Future<void> _signInAnonymously() async {
    try {
      await auth.signInAnonymously();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      await auth.signInWithGoogle();
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
              onPressed: _signInWithGoogle,
              text: 'Sing In with Google',
              color: Colors.white,
              textColor: Colors.black,
            ),const SizedBox(height: 20.0,),
            DefaultButton(
              onPressed: () {},
              text: 'Sing In with FaceBook',
              color: Colors.blue,
            ),const SizedBox(height: 20.0,),
            DefaultButton(
              onPressed: () {},
              text: 'Sing In with email',
              color: Colors.green,
            ),const SizedBox(height: 20.0,),
            const Text('OR'),const SizedBox(height: 20.0,),
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
      height: 50.0,
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
