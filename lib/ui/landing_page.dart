import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timetracker/ui/home_screen/home_screen.dart';
import 'package:timetracker/ui/sign_in/sign_in_screen.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  User? _user;
void _updateUser(User? user){
  setState(() {
    _user = user;
  });
}
  @override
  Widget build(BuildContext context) {
    if(_user == null) {
      return SignInScreen(onSignIn: (user)=> _updateUser(user),);
    }else{
      return HomeScreen(onSignOut: ()=> _updateUser(null),);
    }
  }
}

