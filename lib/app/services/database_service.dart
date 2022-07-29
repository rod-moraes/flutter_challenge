import 'package:cloud_firestore/cloud_firestore.dart';

abstract class DatabaseService {
  Future<List<Map<String, dynamic>?>> getAllFromCollection(String collection,
      {String? orderBy, bool descending = false});
  Future<void> deleteWithIdFromCollection(String collection, String id);
  Future<void> editWithIdFromCollection(
      String collection, Map<String, dynamic> map);
}

class FirebaseDatabaseService implements DatabaseService {
  final FirebaseFirestore firestore;

  const FirebaseDatabaseService({required this.firestore});

  @override
  Future<List<Map<String, dynamic>?>> getAllFromCollection(String collection,
      {String? orderBy, bool descending = false}) async {
    CollectionReference collectionRef = firestore.collection(collection);
    QuerySnapshot querySnapshot;
    if (orderBy != null) {
      querySnapshot =
          await collectionRef.orderBy(orderBy, descending: descending).get();
    } else {
      querySnapshot = await collectionRef.get();
    }
    List<Map<String, dynamic>?> list = querySnapshot.docs.map((doc) {
      Object? data = doc.data();
      if (data != null && data is Map<String, dynamic>) {
        data['id'] = doc.id;
        return Map<String, dynamic>.from(data);
      }
    }).toList();
    return list;
  }

  @override
  Future<void> deleteWithIdFromCollection(String collection, String id) async {
    CollectionReference collectionRef = firestore.collection(collection);
    try {
      await collectionRef.doc(id).delete();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> editWithIdFromCollection(
      String collection, Map<String, dynamic> map) async {
    CollectionReference collectionRef = firestore.collection(collection);
    try {
      String id = map['id'];
      map.remove('id');
      await collectionRef.doc(id).update(map);
    } catch (e) {
      rethrow;
    }
  }
}
