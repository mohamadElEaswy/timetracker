import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetracker/models/job_model.dart';
import 'package:timetracker/services/database.dart';
import 'package:timetracker/ui/widgets/exceptions.dart';
import 'package:timetracker/ui/widgets/show_alert.dart';

class EditJobScreen extends StatefulWidget {
  const EditJobScreen({Key? key, required this.database, this.job})
      : super(key: key);
  final Database database;
  final Job? job;
  @override
  State<EditJobScreen> createState() => _EditJobScreenState();
  static Future<void> show(BuildContext context, {Job? job}) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => EditJobScreen(
        database: database,
        job: job,
      ),
      fullscreenDialog: true,
    ));
  }
}

class _EditJobScreenState extends State<EditJobScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  int? _ratePerHour;
  FocusNode jobNameFocusNode = FocusNode();
  FocusNode ratePerHourFocusNode = FocusNode();

  void jobEditingComplete() {
    FocusScope.of(context).requestFocus(ratePerHourFocusNode);
  }

  void ratePerHourEditingComplete() {
    !_validateAndSaveFormData()
        ? FocusScope.of(context).requestFocus(jobNameFocusNode)
        : _submit();
  }

  bool _validateAndSaveFormData() {
    final _form = _formKey.currentState!;
    if (_form.validate()) {
      _form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    if (_validateAndSaveFormData()) {
      try {
        final jobs = await widget.database.jobsStream().first;
        final allNames = jobs.map((job) => job!.name).toList();
        if (widget.job != null) {
          allNames.remove(widget.job!.name);
        }
        if (allNames.contains(_name)) {
          showAlertDialog(context,
              title: 'Duplicated job name',
              content: 'job name is duplicated',
              defaultActionString: 'OK');
        } else {
          final String id = widget.job?.id ?? documentIDCurrentDate();
          await widget.database.setJob(
            Job(
              id: id,
              name: _name!,
              ratePerHour: _ratePerHour!,
            ),
          );
          Navigator.of(context).pop();
        }
      } on FirebaseException catch (e) {
        showExceptionDialog(context, exception: e, title: 'Error');
      }
    } else {
      // print('nothing saved');
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.job != null) {
      _name = widget.job!.name;
      _ratePerHour = widget.job!.ratePerHour;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(widget.job == null ? 'New job' : 'Edit Job'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
                onPressed: _submit,
                child: const Text(
                  'save',
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                )),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          // color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _form(),
          ),
        ),
      ),
    );
  }

  Widget _form() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(height: 8.0),
          TextFormField(
            onEditingComplete: jobEditingComplete,
            initialValue: _name,
            validator: (name) => name!.isNotEmpty ? null : 'Job must be named',
            onSaved: (value) => _name = value,
            decoration: const InputDecoration(
              hintText: 'Job title',
            ),
            focusNode: jobNameFocusNode,
          ),
          const SizedBox(height: 8.0),
          TextFormField(
            onEditingComplete: ratePerHourEditingComplete,
            initialValue: _ratePerHour != null ? '$_ratePerHour' : null,
            onSaved: (value) {
              if (value!.isNotEmpty) {
                _ratePerHour = int.tryParse(value)!;
              } else {
                _ratePerHour = 0;
              }
            },
            keyboardType: const TextInputType.numberWithOptions(
                decimal: false, signed: false),
            validator: (ratePerHour) => ratePerHour!.isNotEmpty ? null : null,
            decoration: const InputDecoration(
              hintText: 'Rate per hour',
            ),
            focusNode: ratePerHourFocusNode,
          ),
          const SizedBox(height: 8.0),
        ],
      ),
    );
  }
}
