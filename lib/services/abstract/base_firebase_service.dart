import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseFirebaseService {
  Future<UserCredential> loginUserWithFirebase(String email,String password);
  Future<UserCredential> signupUserWithFirebase(String email,String password,String name,String age);
  void signOutUser();
  bool isUserLoggedIn();
}