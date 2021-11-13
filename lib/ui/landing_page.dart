import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timetracker/services/auth.dart';
import 'package:timetracker/ui/home_screen/home_screen.dart';
import 'package:timetracker/ui/sign_in/sign_in_screen.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key, required this.auth}) : super(key: key);
  final Auth auth;



  @override
  // void initState() {
  //   super.initState();
    // widget.auth.authUserState().listen((user) {
    //   print(user);
    // });
  //   _updateUser(FirebaseAuth.instance.currentUser);
  // }

  // void _updateUser(User? user) {
    // setState(() {
    // _user = user;
    // });
  // }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: auth.authUserState(),
      builder: (context, snapshot) {
        final User? user = snapshot.data;
        if (snapshot.connectionState == ConnectionState.active) {
          if (user == null) {
            return SignInScreen(
              auth: auth,
            );
          } else {
            return HomeScreen(
              auth: auth,
            );
          }
        } else {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }
}
