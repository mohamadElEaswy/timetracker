import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetracker/models/job_model.dart';
import 'package:timetracker/services/auth.dart';
import 'package:timetracker/services/database.dart';
import 'package:timetracker/ui/widgets/show_alert.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
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
      print('ok');
    } else {
      print('cancel');
    }
  }

  Future<void> _createJob(BuildContext context,
      {required String name, required int ratePerHour}) async {
    final database = Provider.of<Database>(context, listen: false);
    await database.createJob(
      Job(
        name: name,
        ratePerHour: ratePerHour,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('home'),
        actions: [
          TextButton(
              onPressed: () => _confirmSignOut(context: context),
              child: const Text(
                'Logout',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                ),
              )),
        ],
      ),
      body: const Center(child: Text('data')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createJob(
          context,
          name: 'name',
          ratePerHour: 11,
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
