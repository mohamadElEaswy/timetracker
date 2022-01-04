import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetracker/services/auth.dart';
import 'package:timetracker/ui/home/account/avatar.dart';
import 'package:timetracker/ui/widgets/show_alert.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);
  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      // print(e.toString());
    }
  }

  Future<void> _confirmSignOut({required BuildContext context}) async {
    final didRequestSignOut = await showAlertDialog(context,
        title: 'Logout',
        content: 'Are you sure that you want to logout?',
        defaultActionString: 'ok',
        cancelActionText: 'cancel');
    if (didRequestSignOut == true) {
      _signOut(context);
      // print('ok');
    } else {
      // print('cancel');
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        actions: [
          TextButton(
            onPressed: () => _confirmSignOut(context: context),
            child: const Text(
              'Logout',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(130.0),
          child: _buildUserInfo(auth.currentUser!),
        ),
      ),
    );
  }

  Widget _buildUserInfo(User user) {
    return Column(
      children: [
        Avatar(
          radius: 50.0,
          photoUrl: user.photoURL,
        ),
        const SizedBox(height: 8.0),
        if (user.displayName != null)
          Text(
            user.displayName!,
            style: const TextStyle(color: Colors.white, fontSize: 16.0),
          ),
        const SizedBox(height: 8.0),
      ],
    );
  }
}
