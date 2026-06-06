import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../model/user_model.dart';

class AuthService {
  // Inisialisasi Firebase & Google Sign In
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  // =========================
  // REGISTER (EMAIL & PASSWORD)
  // =========================
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
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

    await _firestore.collection('users').doc(user.uid).set(userModel.toMap());

    return userModel;
  }

  // =========================
  // LOGIN (EMAIL & PASSWORD)
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
  // 🟢 GET CURRENT USER (UNTUK SPLASH SCREEN)
  // =========================
  Future<UserModel?> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user != null) {
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists && userDoc.data() != null) {
        return UserModel.fromMap(userDoc.data()!, userDoc.id);
      }
      return UserModel(
        uid: user.uid,
        name: user.displayName ?? '',
        email: user.email ?? '',
        bio: '',
        location: '',
        website: '',
      );
    }
    return null;
  }

  // =========================
  // 🟢 FORGOT / RESET PASSWORD
  // =========================
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print("RESET PASSWORD ERROR SERVICE = $e");
      rethrow;
    }
  }

  // =========================
  // LOGOUT
  // =========================
  Future<void> logout() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
