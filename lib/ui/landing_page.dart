import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetracker/services/auth.dart';
import 'package:timetracker/services/database.dart';
// import 'package:timetracker/services/auth_provider.dart';
import 'package:timetracker/ui/home/home_screen.dart';
import 'package:timetracker/ui/sign_in/sign_in_screen.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return StreamBuilder<User?>(
      stream: auth.authUserState(),
      builder: (context, snapshot) {
        final User? user = snapshot.data;
        if (snapshot.connectionState == ConnectionState.active) {
          if (user == null) {
            return SignInScreen.create(context);
          } else {
            return Provider<Database>(
              create: (_) => FirestoreDatabase(uid: user.uid),
              child: const HomeScreen(),
            );
          }
        } else {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
