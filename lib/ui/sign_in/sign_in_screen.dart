import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetracker/services/auth.dart';
// import 'package:timetracker/services/auth_provider.dart';
import 'package:timetracker/ui/sign_in_with_email/sign_in_with_email_screen.dart';
import 'package:timetracker/ui/widgets/exceptions.dart';
import 'package:timetracker/ui/widgets/global_button.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool isLoading = false;

  Future<void> _signInExceptions(BuildContext context, Exception exception) {
    if (exception is FirebaseAuthException &&
        exception.code == 'ERROR_ABORTED_BY_USER') {}
    return showExceptionDialog(
      context,
      exception: exception,
      title: 'Sign in failed',
    );
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      setState(() => isLoading = true);
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signInAnonymously();
    } on Exception catch (e) {
      _signInExceptions(context, e);
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      setState(() => isLoading = true);
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signInWithGoogle();
    } on Exception catch (e) {
      _signInExceptions(context, e);
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Time Trucker'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildHeader(),
                const SizedBox(
                  height: 20.0,
                ),
                SizedBox( height: 50.0,
                  child: DefaultButton(
                    onPressed:
                        isLoading ? null : () => _signInWithGoogle(context),
                    text: 'Sign In with Google',
                    color: Colors.white,
                    textColor: Colors.black,
                  ),
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
                  onPressed: isLoading ? null : () => _signInWithEmail(context),
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
                  onPressed:
                      isLoading ? null : () => _signInAnonymously(context),
                  text: 'Sign In Anonymously',
                  color: Colors.amber,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return const Text(
        'Sign in',
        style: TextStyle(
          fontSize: 50.0,
          fontWeight: FontWeight.bold,
        ),
      );
    }
  }

  void _signInWithEmail(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => SignInWithEmail()));
  }
}
