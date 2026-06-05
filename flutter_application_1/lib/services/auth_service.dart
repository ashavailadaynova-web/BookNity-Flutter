import 'package:firebase_auth/firebase_auth.dart';

import '../model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth =
      FirebaseAuth.instance;
  final FirebaseFirestore _firestore =
    FirebaseFirestore.instance;

  // =========================
  // REGISTER
  // =========================

  Future<UserModel> register({
  required String name,
  required String email,
  required String password,
}) async {

  final credential =
      await _auth.createUserWithEmailAndPassword(
    email: email,
    password: password,
  );

  final user = credential.user!;

  final userModel = UserModel(
    uid: user.uid,
    name: name,
    email: email,
    bio: '',
    location: '',
    website: '',
  );

  await _firestore
      .collection('users')
      .doc(user.uid)
      .set(userModel.toMap());

  return userModel;
}

  // =========================
  // LOGIN
  // =========================

  Future<UserModel?> login({
    required String email,
    required String password,
  }) async {
    final credential =
        await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user;

    if (user == null) {
      return null;
    }

    return UserModel(
      uid: user.uid,
      name: '',
      email: user.email ?? '',
    );
  }

  

  // =========================
  // CURRENT USER
  // =========================

  User? get currentUser =>
      _auth.currentUser;

  // =========================
  // LOGOUT
  // =========================

  Future<void> logout() async {
    await _auth.signOut();
  }

  

  
}