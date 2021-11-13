import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timetracker/services/auth.dart';
import 'package:timetracker/ui/home_screen/home_screen.dart';
import 'package:timetracker/ui/sign_in/sign_in_screen.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key, required this.auth}) : super(key: key);
  final Auth auth;

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {

  User? _user;

  @override
  void initState() {
        super.initState();
        _updateUser(FirebaseAuth.instance.currentUser);
  }
void _updateUser(User? user){
  setState(() {
    _user = user;
  });
}


  @override
  Widget build(BuildContext context) {
    if(_user == null) {
      return SignInScreen(onSignIn: (user)=> _updateUser(user), auth: widget.auth,);
    }else{
      return HomeScreen(onSignOut: ()=> _updateUser(null), auth: widget.auth,);
    }
  }
}

