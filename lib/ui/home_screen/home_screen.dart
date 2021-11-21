import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetracker/services/auth.dart';
// import 'package:timetracker/services/auth_provider.dart';
import 'package:timetracker/ui/widgets/show_alert.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context,  listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
  Future<void> _confirmSignOut({required BuildContext context})async{
    final didRequestSignOut = await showAlertDialog(
        context, title: 'Logout',
        content: 'Are you sure that you want to logout?',
        defaultActionString: 'ok', cancelActionText: 'cancel');
    if( didRequestSignOut == true){_signOut(context);}
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('home'),
        actions: [
          TextButton(
              onPressed: ()=> _signOut(context),
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
            onPressed: ()=> _confirmSignOut(context: context),
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
