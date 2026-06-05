import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/user_model.dart';

class UserService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  static const String collectionName =
      'users';

  // =========================
  // GET USER
  // =========================

  Future<UserModel?> getUser(
    String uid,
  ) async {
    final doc =
        await _firestore
            .collection(collectionName)
            .doc(uid)
            .get();

    if (!doc.exists) {
      return null;
    }

    return UserModel.fromMap(
      doc.data()!,
      doc.id,
    );
  }

  // =========================
  // CREATE USER
  // =========================

  Future<void> createUser(
    UserModel user,
  ) async {
    await _firestore
        .collection(collectionName)
        .doc(user.uid)
        .set(user.toMap());
  }

  // =========================
  // UPDATE PROFILE
  // =========================

  Future<void> updateUser(
    UserModel user,
  ) async {
    await _firestore
        .collection(collectionName)
        .doc(user.uid)
        .update(user.toMap());
  }

  // =========================
  // DELETE USER
  // =========================

  Future<void> deleteUser(
    String uid,
  ) async {
    await _firestore
        .collection(collectionName)
        .doc(uid)
        .delete();
  }
}