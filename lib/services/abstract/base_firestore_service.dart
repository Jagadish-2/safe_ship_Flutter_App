abstract class BaseFirestoreServie {
  Future addDataToFireStore(
      Map<String, dynamic> data, String collectionName, String docName);

  Future updateDataToFireStore(
      Map<String, dynamic> data, String collectionName, String docName);

  Future getUserDataFromFirestore(String collectionName, String docName);
}
