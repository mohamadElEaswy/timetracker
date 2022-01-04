// ignore_for_file: use_key_in_widget_constructors, annotate_overrides

import 'package:flutter/material.dart';
import 'package:timetracker/models/entry.dart';
import 'package:timetracker/models/job_model.dart';
import 'package:timetracker/ui/home/job_entries/format.dart';

class EntryListItem extends StatelessWidget {
  const EntryListItem({
    required this.entry,
    required this.job,
    required this.onTap,
  });

  final Entry entry;
  final Job job;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: _buildContents(context),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildContents(BuildContext context) {
    final dayOfWeek = Format.dayOfWeek(entry.start!);
    final startDate = Format.date(entry.start!);
    final startTime = TimeOfDay.fromDateTime(entry.start!).format(context);
    final endTime = TimeOfDay.fromDateTime(entry.end!).format(context);
    final durationFormatted = Format.hours(entry.durationInHours);

    final pay = job.ratePerHour * entry.durationInHours;
    final payFormatted = Format.currency(pay);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(children: <Widget>[
          Text(dayOfWeek,
              style: const TextStyle(fontSize: 18.0, color: Colors.grey)),
          const SizedBox(width: 15.0),
          Text(startDate, style: const TextStyle(fontSize: 18.0)),
          if (job.ratePerHour > 0.0) ...<Widget>[
            Expanded(child: Container()),
            Text(
              payFormatted,
              style: TextStyle(fontSize: 16.0, color: Colors.green[700]),
            ),
          ],
        ]),
        Row(children: <Widget>[
          Text('$startTime - $endTime', style: const TextStyle(fontSize: 16.0)),
          Expanded(child: Container()),
          Text(durationFormatted, style: const TextStyle(fontSize: 16.0)),
        ]),
        if (entry.comment!.isNotEmpty)
          Text(
            entry.comment!,
            style: const TextStyle(fontSize: 12.0),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
      ],
    );
  }
}

class DismissibleEntryListItem extends StatelessWidget {
  const DismissibleEntryListItem({
    required this.key,
    this.entry,
    this.job,
    this.onDismissed,
    this.onTap,
  });

  // ignore: overridden_fields
  final Key key;
  final Entry? entry;
  final Job? job;
  final VoidCallback? onDismissed;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      background: Container(color: Colors.red),
      key: key,
      direction: DismissDirection.endToStart,
      onDismissed: (direction) => onDismissed!(),
      child: EntryListItem(
        entry: entry!,
        job: job!,
        onTap: onTap!,
      ),
    );
  }
}
