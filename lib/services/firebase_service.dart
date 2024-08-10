import 'package:cloud_firestore/cloud_firestore.dart';

import 'abstract/base_firestore_service.dart';

class FirestoreService extends BaseFirestoreServie{
  final _firestoreInstance = FirebaseFirestore.instance;

  @override
  Future addDataToFireStore(Map<String, dynamic> data, String collectionName, String docName) async {
    try{
      await _firestoreInstance.collection(collectionName).doc(docName).set(data);
    }catch(e){
      throw Exception(e.toString());
    }
  }

  @override
  Future updateDataToFireStore(Map<String, dynamic> data, String collectionName, String docName) async {
    try{
      await _firestoreInstance.collection(collectionName).doc(docName).update(data);
    } catch(e){
      throw Exception(e.toString());
    }

  }


  @override
  Future<Map<String, dynamic>?> getUserDataFromFirestore(String collectionName, String docName) async {
    try {
      final userData = await _firestoreInstance.collection(collectionName).doc(docName).get();
      return userData.data();
    } catch (e) {
      print(e);
      throw Exception(e.toString());
    }
  }

}