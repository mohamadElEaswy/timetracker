import 'package:timetracker/models/job_model.dart';
import 'package:timetracker/services/api_path.dart';
import 'package:timetracker/services/firestore_services.dart';

//the services layer after login or register
abstract class Database {
  Future<void> setJob(Job job);
  Future<void> deleteJob(Job job);
  Stream<List<Job?>> jobsStream();
}

String documentIDCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  FirestoreDatabase({required this.uid});
  final String uid;
  final _service = FireStoreService.instance;

//send data to Cloud FireStore DataBase
  @override
  Future<void> setJob(Job job) async =>
      _service.setData(path: ApiPath.job(uid, job.id), data: job.toMap());

  @override
  Future<void> deleteJob(Job job) =>
      _service.deleteData(path: ApiPath.job(uid, job.id));
//the coming data from Cloud FireStore DataBase
  @override
  Stream<List<Job?>> jobsStream() => _service.collectionStream(
        path: ApiPath.jobs(uid),
        builder: (data, documentId) => Job.fromMap(data, documentId),
      );
}
