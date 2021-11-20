import 'package:flutter/material.dart';
import 'package:timetracker/services/auth.dart';
import 'package:timetracker/ui/sign_in_with_email/sign_in_with_email_screen.dart';
import 'package:timetracker/ui/widgets/global_button.dart';

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

  // Future<void> _signInWithFacebook() async {
  //   try {
  //     await auth.signInWithFacebook();
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Time Trucker'),
      ),
      body: SingleChildScrollView(
        child: Padding(
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
              ),
              const SizedBox(
                height: 20.0,
              ),
              // DefaultButton(
              //   onPressed: _signInWithFacebook,
              //   text: 'Sing In with FaceBook',
              //   color: Colors.blue,
              // ),const SizedBox(height: 20.0,),
              DefaultButton(
                onPressed: () {
                  _signInWithEmail(context);
                },
                text: 'Sign in with email',
                color: Colors.green,
              ),
              const SizedBox(
                height: 20.0,
              ),
              const Text('OR'),
              const SizedBox(
                height: 20.0,
              ),
              DefaultButton(
                onPressed: _signInAnonymously,
                text: 'Sing In Anonymously',
                color: Colors.amber,
              ),
            ],
          ),
        ),
      ),
    );
  }
  void _signInWithEmail(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => SignInWithEmail(auth: auth,)));
  }
}




