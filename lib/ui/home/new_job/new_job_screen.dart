import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetracker/models/job_model.dart';
import 'package:timetracker/services/database.dart';
import 'package:timetracker/ui/widgets/exceptions.dart';

class NewJobScreen extends StatefulWidget {
  const NewJobScreen({Key? key, required this.database}) : super(key: key);
  final Database database;
  @override
  State<NewJobScreen> createState() => _NewJobScreenState();
  static Future<void> show(BuildContext context) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => NewJobScreen(
        database: database,
      ),
      fullscreenDialog: true,
    ));
  }
}

class _NewJobScreenState extends State<NewJobScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  late int _ratePerHour;
  FocusNode jobNameFocusNode = FocusNode();
  FocusNode ratePerHourFocusNode = FocusNode();

  void jobEditingComplete() {
    FocusScope.of(context).requestFocus(ratePerHourFocusNode);
  }

  void ratePerHourEditingComplete() {
    _name == null
        ? FocusScope.of(context).requestFocus(jobNameFocusNode)
        :_submit() ;
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
        await widget.database.createJob(
          Job(
            name: _name!,
            ratePerHour: _ratePerHour,
          ),
        );
        Navigator.of(context).pop();
      } on FirebaseException catch (e) {
        showExceptionDialog(context, exception: e, title: 'Error');
      }
    } else {
      print('nothing saved');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('New job'),
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
            onEditingComplete: jobEditingComplete,validator: (value) => value!.isNotEmpty ? null : 'Job must be named',
            onSaved: (value) => _name = value,
            decoration: const InputDecoration(
              hintText: 'Job title',
            ),
            focusNode: jobNameFocusNode,
            // onEditingComplete: ()=> ratePerHourFocusNode.,
          ),
          const SizedBox(height: 8.0),
          TextFormField(
            onEditingComplete: ratePerHourEditingComplete,
            onSaved: (value) {
              if (value!.isNotEmpty) {
                _ratePerHour = int.parse(value);
              } else {
                _ratePerHour = 0;
              }
            },
            keyboardType: const TextInputType.numberWithOptions(
                decimal: false, signed: false),
            validator: (value) => value!.isNotEmpty ? null : null,
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
