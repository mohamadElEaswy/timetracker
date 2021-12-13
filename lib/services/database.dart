import 'package:timetracker/models/entry.dart';
import 'package:timetracker/models/job_model.dart';
import 'package:timetracker/services/api_path.dart';
import 'package:timetracker/services/firestore_services.dart';

//the services layer after login or register
abstract class Database {
  Future<void> setJob(Job job);
  Future<void> deleteJob(Job job);
  Stream<List<Job?>> jobsStream();

  Future<void> setEntry(Entry entry);
  Future<void> deleteEntry(Entry entry);
  Stream<List<Entry>> entriesStream({Job job});
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
        sort: (lhs, rhs) {},
      );
  @override
  Future<void> setEntry(Entry entry) => _service.setData(
        path: ApiPath.entry(uid, entry.id),
        data: entry.toMap(),
      );

  @override
  Future<void> deleteEntry(Entry entry) => _service.deleteData(
        path: ApiPath.entry(uid, entry.id),
      );

  @override
  Stream<List<Entry>> entriesStream({Job? job}) =>
      _service.collectionStream<Entry>(
        path: ApiPath.entries(uid),
        queryBuilder: job != null
            ? (query) => query.where('jobId', isEqualTo: job.id)
            : null,
        builder: (data, documentID) => Entry.fromMap(data, documentID),
        sort: (lhs, rhs) => rhs.start.compareTo(lhs.start),
      );
}
