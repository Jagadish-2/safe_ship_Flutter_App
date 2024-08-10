import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/userModel.dart';
import '../services/firebase_auth.dart';
import '../services/firebase_service.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  UserCredential? _userCredential;
  User1? _user;
  FirebaseAuthClass fauth = FirebaseAuthClass();
  FirestoreService fstore = FirestoreService();

  bool get isLoading => _isLoading;
  User1? get user => _user;
  UserCredential? get userCredentials => _userCredential;

  AuthProvider() {
    _loadUserDataFromPrefs();
  }

  Future<void> _saveUserDataToPrefs(User1 user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', user.uid);
    await prefs.setString('userName', user.name);
    await prefs.setString('userEmail', user.email);
    await prefs.setString('userAge', user.age);
  }

  Future<void> _loadUserDataFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    final userName = prefs.getString('userName');
    final userEmail = prefs.getString('userEmail');
    final userAge = prefs.getString('userAge');

    if (userId != null && userName != null && userEmail != null && userAge != null) {
      _user = User1(
        uid: userId,
        name: userName,
        email: userEmail,
        age: userAge,
      );
      notifyListeners();
    }
  }

  Future<UserCredential> loginUserWithFirebase(String email, String password) async {
    setLoader(true);
    try {
      _userCredential = await fauth.loginUserWithFirebase(email, password);
      if (_userCredential != null) {
        await _loadUserData(_userCredential!.user!.uid);
        if (_user != null) {
          await _saveUserDataToPrefs(_user!);
        }
      }
      setLoader(false);
      return _userCredential!;
    } catch (e) {
      setLoader(false);
      return Future.error(e);
    }
  }

  Future<void> sendEmailVerificationLink()async{
    try{
      await fauth.auth.currentUser?.sendEmailVerification();
    }catch(e){
      print(e.toString());
    }
  }


  Future<void> sendPasswordResetLink(String email)async{
    try{
      await fauth.sendPasswordResetLink(email);
    }catch(e){
      return Future.error(e);
    }
  }

  Future<void> signupUserWithFirebase(String email, String password, String name, String age) async {
    setLoader(true);
    try {
      final userCredential = await fauth.signupUserWithFirebase(email, password, name, age);
      final data = {
        'email': email,
        'password': password,
        'uid': userCredential.user!.uid,
        'createdAt': DateTime.now().microsecondsSinceEpoch.toString(),
        'name': name,
        'age': age,
        'bio': '',
        'profilePic': '',
        'batch': [],
      };
      await addUserDataToDatabase(data, 'users', userCredential.user!.uid);
      _user = User1.fromMap(data);
      if (_user != null) {
        await _saveUserDataToPrefs(_user!);
      }

      // Send email verification link
      await sendEmailVerificationLink();

      setLoader(false);
      notifyListeners();
    } catch (e) {
      setLoader(false);
      throw Exception(e.toString());
    }
  }


  // Future<void> signupUserWithFirebase(String email, String password, String name,String age) async {
  //   setLoader(true);
  //   try {
  //     final userCredential = await fauth.signupUserWithFirebase(email, password, name,age);
  //     final data = {
  //       'email': email,
  //       'password': password,
  //       'uid': userCredential.user!.uid,
  //       'createdAt': DateTime.now().microsecondsSinceEpoch.toString(),
  //       'name': name,
  //       'age' : age,
  //       'bio': '',
  //       'profilePic': '',
  //       'batch': [],
  //     };
  //     await addUserDataToDatabase(data, 'users', userCredential.user!.uid);
  //     _user = User1.fromMap(data);
  //     if (_user != null) {
  //       await _saveUserDataToPrefs(_user!);
  //     }
  //     setLoader(false);
  //     notifyListeners();
  //   } catch (e) {
  //     setLoader(false);
  //     throw Exception(e.toString());
  //   }
  // }


  Future<void> _loadUserData(String uid) async {
    try {
      final userData = await fstore.getUserDataFromFirestore('users', uid);
      if (userData != null) {
        _user = User1.fromMap(userData);
        notifyListeners();
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<bool> addUserDataToDatabase(Map<String, dynamic> data, String collectionName, String docName) async {
    try {
      await fstore.addDataToFireStore(data, collectionName, docName);
      return true;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  logoutUser() {
    fauth.signOutUser();
    _clearUserDataFromPrefs();
  }

  Future<void> _clearUserDataFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    await prefs.remove('userName');
    await prefs.remove('userEmail');
    await prefs.remove('userAge');
  }

  void setLoader(bool loader) {
    _isLoading = loader;
    notifyListeners();
  }
}

final authProvider = ChangeNotifierProvider<AuthProvider>((ref) => AuthProvider());
