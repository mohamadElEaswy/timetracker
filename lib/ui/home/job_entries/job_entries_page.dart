// ignore_for_file: use_key_in_widget_constructors

import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:timetracker/models/entry.dart';
import 'package:timetracker/models/job_model.dart';
import 'package:timetracker/services/database.dart';
import 'package:timetracker/ui/home/job_entries/entry_list_item.dart';
import 'package:timetracker/ui/home/job_entries/entry_page.dart';
import 'package:timetracker/ui/home/list_items_builder.dart';
import 'package:timetracker/ui/home/new_job/edit_job_screen.dart';
import 'package:timetracker/ui/widgets/exceptions.dart';

class JobEntriesPage extends StatelessWidget {
  const JobEntriesPage({required this.database, required this.job});
  final Database database;
  final Job job;

  static Future<void> show(
      BuildContext context, Job job, Database database) async {
    // final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: false,
        builder: (context) => JobEntriesPage(job: job, database: database),
      ),
    );
  }

  Future<void> _deleteEntry(BuildContext context, Entry entry) async {
    try {
      await database.deleteEntry(entry);
    } on FirebaseException catch (e) {
      showExceptionDialog(
        context,
        title: 'Operation failed',
        exception: e,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Job>(
        stream: database.jobStream(job),
        builder: (context, snapshot) {
          final Job? _job = snapshot.data;
          final String jobName = _job?.name ?? '';
          return Scaffold(
            appBar: AppBar(
              elevation: 2.0,
              title: Text(jobName),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () =>
                      EditJobScreen.show(context, job: job, database: database),
                ),
                IconButton(
                    onPressed: () => EntryPage.show(
                        context: context, database: database, job: _job),
                    icon: const Icon(Icons.add))
              ],
            ),
            body: _buildContent(context, job),
            // floatingActionButton: FloatingActionButton(
            //   child: const Icon(Icons.add),
            //   onPressed: () => EntryPage.show(
            //       context: context, database: database, job: _job),
            // ),
          );
        });
  }

  Widget _buildContent(BuildContext context, Job job) {
    return StreamBuilder<List<Entry>>(
      stream: database.entriesStream(job: job),
      builder: (context, snapshot) {
        return ListItemBuilder<Entry>(
          snapshot: snapshot,
          itemBuilder: (context, entry) {
            return DismissibleEntryListItem(
              key: Key('entry-${entry.id}'),
              entry: entry,
              job: job,
              onDismissed: () => _deleteEntry(context, entry),
              onTap: () => EntryPage.show(
                context: context,
                database: database,
                job: job,
                entry: entry,
              ),
            );
          },
        );
      },
    );
  }
}
