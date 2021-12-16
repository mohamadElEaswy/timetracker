import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetracker/models/job_model.dart';
import 'package:timetracker/services/database.dart';
import 'package:timetracker/ui/home/job_entries/job_entries_page.dart';
import 'package:timetracker/ui/home/job_item_tile.dart';
import 'package:timetracker/ui/home/list_items_builder.dart';
import 'package:timetracker/ui/home/new_job/edit_job_screen.dart';
import 'package:timetracker/ui/widgets/exceptions.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  Future<void> _delete(BuildContext context, {required Job job}) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.deleteJob(job);
    } on FirebaseException catch (e) {
      showExceptionDialog(context, exception: e, title: 'Operation failed');
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
          IconButton(
            onPressed: () => EditJobScreen.show(
              context,
              database: Provider.of<Database>(context, listen: false),
            ),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: _buildContents(context),
    );
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Job?>>(
      stream: database.jobsStream(),
      builder: (context, snapshot) {
        return ListItemBuilder<Job?>(
          snapshot: snapshot,
          itemBuilder: (context, job) => Dismissible(
            key: Key('job-${job!.id}'),
            background: Container(
              color: Colors.red,
            ),
            onDismissed: (direction) => _delete(context, job: job),
            direction: DismissDirection.endToStart,
            child: JobItem(
              job: job,
              onTab: () => JobEntriesPage.show(context, job, database),
            ),
          ),
        );
        // if (snapshot.hasData) {
        //   final jobs = snapshot.data;
        //   final children = jobs!
        //       .map((job) => JobItem(
        //             job: job,
        //             onTab: () => EditJobScreen.show(context, job: job),
        //           ))
        //       .toList();
        //   if (jobs.isNotEmpty) {
        //     return ListView(
        //       children: children,
        //     );
        //   }
        //   return const EmptyContent();
        // }
        // if (snapshot.hasError) {
        //   const Center(
        //     child: Text('Some Error occurred'),
        //   );
        // }
        // return const Center(
        //   child: CircularProgressIndicator(),
        // );
      },
    );
  }

  navigateTo(BuildContext context, Widget newRoute) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => newRoute,
          fullscreenDialog: true,
        ),
      );
}
