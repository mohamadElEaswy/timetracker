import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timetracker/services/auth.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key, required this.onSignOut, required this.auth}) : super(key: key);
  final VoidCallback onSignOut;
  final Auth auth;
  Future<void> _signOut() async {
    try {
      await auth.signOut();
      onSignOut();
    } catch (e) {
      print(e.toString());
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('home'),
        actions: [
          TextButton(
              onPressed: ()=> _signOut(),
              child: const Text(
                'Logout',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                ),
              )),
        ],
      ),
      body:  Center(
        child: TextButton(
            onPressed: ()=> _signOut(),
            child: const Text(
              'Logout',
              style: TextStyle(
                // color: Colors.white,
                fontSize: 18.0,
              ),
            )),
      ),
    );
  }
}
