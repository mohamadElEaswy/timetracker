import 'package:flutter/material.dart';
import 'package:timetracker/models/job_model.dart';

class JobItem extends StatelessWidget {
  const JobItem({Key? key, required this.job, required this.onTab})
      : super(key: key);
  final Job? job;
  final VoidCallback onTab;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(job!.name),
      onTap: onTab,
      trailing: const Icon(Icons.chevron_right),
    );
  }
}
