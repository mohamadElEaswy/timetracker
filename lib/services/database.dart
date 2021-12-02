import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timetracker/models/job_model.dart';
import 'package:timetracker/services/api_path.dart';

abstract class Database {
  Future<void> createJob(Job job);
}

class FirestoreDatabase implements Database {
  FirestoreDatabase({required this.uid});
  final String uid;

  @override
  Future<void> createJob(Job job) async =>
      _setData(path: ApiPath.job(uid, 'jobID'), data: job.toMap());
  //   final String path = ApiPath.job(uid, 'jobID');
  //   final documentReference = FirebaseFirestore.instance.doc(path);
  //   await documentReference.set(job.toMap());

  Future<void> _setData(
      {required String path, required Map<String, dynamic> data}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    print('$path : $data');
    await reference.set(data);
  }
}
