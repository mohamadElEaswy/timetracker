import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetracker/models/job_model.dart';
import 'package:timetracker/services/auth.dart';
import 'package:timetracker/services/database.dart';
import 'package:timetracker/ui/widgets/exceptions.dart';
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
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.createJob(
        Job(
          name: name,
          ratePerHour: ratePerHour,
        ),
      );
    } on FirebaseException catch (e) {
      showExceptionDialog(context, exception: e, title: 'Operation Field');
    }
  }

  @override
  Widget build(BuildContext context) {
    // final database = Provider.of<Database>(context, listen: false);
    // database.jobsStream;

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
      body: _buildContents(context),
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

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Job?>>(
      stream: database.jobsStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final jobs = snapshot.data;
          final children =
              jobs!.map((job) => Text(job!.name.toString())).toList(); return ListView(children:children,);
        } if(snapshot.hasError) {const Center(child: Text('Some Error occurred'),);}
        return const Center( child:  CircularProgressIndicator(),);
      },
    );
  }
}
