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
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user;

    if (user == null) {
      return null;
    }

    // Mengambil data lengkap dari Firestore setelah login berhasil
    final userDoc = await _firestore.collection('users').doc(user.uid).get();
    if (userDoc.exists && userDoc.data() != null) {
      return UserModel.fromMap(userDoc.data()!, userDoc.id);
    }

    return UserModel(
      uid: user.uid,
      name: '',
      email: user.email ?? '',
      bio: '',
      location: '',
      website: '',
    );
  }

  // =========================
  // 🟢 LOGIN / REGISTER WITH GOOGLE
  // =========================
  Future<UserModel?> loginWithGoogle() async {
    try {
      // 1. Wajib inisialisasi dulu di versi 7 sebelum dipakai
      await GoogleSignIn.instance.initialize(
        serverClientId:
            '44811337434-ppo1t8gmnfdsgo3rr5u36mnpu7mecvk9.apps.googleusercontent.com',
      );

      // 2. Di versi 7, .signIn() DIGANTI menjadi .authenticate()
      final GoogleSignInAccount? googleUser = await _googleSignIn
          .authenticate();
      if (googleUser == null) return null; // Jika user batalin login

      // 3. Ambil detail autentikasi (idToken) dari akun Google
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // 4. Buat kredensial baru untuk dilempar ke Firebase
      // (Di versi 7, accessToken dipisah, tapi untuk Firebase kita cukup pakai idToken)
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      // 5. Masuk ke Firebase menggunakan kredensial Google
      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      final User? user = userCredential.user;

      if (user != null) {
        // 6. Cek apakah user ini sudah ada di Firestore atau belum
        final userDoc = await _firestore
            .collection('users')
            .doc(user.uid)
            .get();

        final userModel = UserModel(
          uid: user.uid,
          name: user.displayName ?? 'Google User',
          email: user.email ?? '',
          bio: '',
          location: '',
          website: '',
        );

        // Jika data user belum terdaftar di Firestore, simpan datanya sekarang
        if (!userDoc.exists) {
          await _firestore
              .collection('users')
              .doc(user.uid)
              .set(userModel.toMap());
        } else if (userDoc.data() != null) {
          return UserModel.fromMap(userDoc.data()!, userDoc.id);
        }

        return userModel;
      }
    } catch (e) {
      print("GOOGLE SIGN IN ERROR SERVICE = $e");
      rethrow;
    }
    return null;
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
