import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetracker/services/auth.dart';
import 'package:timetracker/ui/sign_in/sign_in_bloc.dart';
import 'package:timetracker/ui/sign_in/sign_in_with_email/sign_in_with_email_screen.dart';
import 'package:timetracker/ui/widgets/exceptions.dart';
import 'package:timetracker/ui/widgets/global_button.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key, required this.bloc, required this.isLoading}) : super(key: key);
  final SignInBloc bloc;
  final bool isLoading;
  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      create: (_) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        builder: (_, isLoading, __) => Provider<SignInBloc>(
          create: (_) => SignInBloc(auth: auth, isLoading: isLoading),
          child: Consumer<SignInBloc>(
            builder: (_, bloc, __) => SignInScreen(bloc: bloc, isLoading: isLoading.value,),
          ),
        ),
      ),
    );
  }

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
      await bloc.signInAnonymously();
    } on Exception catch (e) {
      _signInExceptions(context, e);
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      await bloc.signInWithGoogle();
    } on Exception catch (e) {
      _signInExceptions(context, e);
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
                const SizedBox(height: 20.0),
                SizedBox(
                  height: 50.0,
                  child: DefaultButton(
                    onPressed:
                        isLoading ? null : () => _signInWithGoogle(context),
                    text: 'Sign In with Google',
                    color: Colors.white,
                    textColor: Colors.black,
                  ),
                ),
                const SizedBox(height: 20.0),
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
                const SizedBox(height: 20.0),
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
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => SignInWithEmail.create(context)));
  }
}
