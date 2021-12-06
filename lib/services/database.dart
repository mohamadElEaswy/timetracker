import 'package:timetracker/models/job_model.dart';
import 'package:timetracker/services/api_path.dart';
import 'package:timetracker/services/firestore_services.dart';

//the services layer after login or register
abstract class Database {
  Future<void> createJob(Job job);
  Stream<List<Job?>> jobsStream();
}

class FirestoreDatabase implements Database {
  FirestoreDatabase({required this.uid});
  final String uid;
  final _service = FireStoreService.instance;

  String documentIDCurrentDate () => DateTime.now().toIso8601String();
//send data to Cloud FireStore DataBase
  @override
  Future<void> createJob(Job job) async =>
      _service.setData(path: ApiPath.job(uid, documentIDCurrentDate()), data: job.toMap());

//the coming data from Cloud FireStore DataBase
  @override
  Stream<List<Job?>> jobsStream() => _service.collectionStream(
        path: ApiPath.jobs(uid),
        builder: (data) => Job.fromMap(data),
      );


}
