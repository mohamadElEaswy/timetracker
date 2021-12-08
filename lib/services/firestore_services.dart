import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreService {
  FireStoreService._();
  static final instance = FireStoreService._();
  //global method to send data to Cloud FireStore DataBases
  Future<void> setData(
      {required String path, required Map<String, dynamic> data}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    // print('$path : $data');
    await reference.set(data);
  }

  Future<void> deleteData({required String path}) async {
    final referance = FirebaseFirestore.instance.doc(path);
    // print('delete $path');
    await referance.delete();
  }

//Global method to get data from Cloud FireStore databases as a live stream
  Stream<List<T>> collectionStream<T>({
    required String path,
    required T Function(Map<String, dynamic> data, String documentId) builder,
  }) {
    final reference = FirebaseFirestore.instance.collection(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => snapshot.docs
        .map((snapshot) => builder(snapshot.data(), snapshot.id))
        .toList());
  }
}
