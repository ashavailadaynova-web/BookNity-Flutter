import 'package:flutter/material.dart';

import '../model/user_model.dart';
import '../services/auth_service.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _service = AuthService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  // =========================
  // REGISTER
  // =========================

  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      _currentUser = await _service.register(
        name: name,
        email: email,
        password: password,
      );

      return true;
    } catch (e) {
      print("REGISTER ERROR = $e");

      debugPrint('Register Error: $e');

      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // =========================
  // LOGIN
  // =========================

  Future<bool> login({required String email, required String password}) async {
    _isLoading = true;
    notifyListeners();

    try {
      _currentUser = await _service.login(email: email, password: password);

      return _currentUser != null;
    } catch (e) {
      print("LOGIN ERROR = $e");

      debugPrint('Login Error: $e');

      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // =========================
  // 🟢 LOGIN WITH GOOGLE (VIEWMODEL)
  // =========================
  Future<bool> loginWithGoogle() async {
    _isLoading = true;
    notifyListeners();

    try {
      _currentUser = await _service.loginWithGoogle();
      return _currentUser != null;
    } catch (e) {
      debugPrint('Google Login Error: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> checkCurrentUser() async {
    try {
      // Memanggil fungsi baru yang ada di AuthService
      _currentUser = await _service.getCurrentUser();

      if (_currentUser != null) {
        notifyListeners();
        return true; // Ada user yang login
      }
      return false; // Tidak ada user (null)
    } catch (e) {
      debugPrint("Error checking user di ViewModel: $e");
      return false;
    }
  }

  // =========================
  // FORGOT PASSWORD (VIEWMODEL)
  // =========================
  Future<bool> forgotPassword({required String email}) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _service.sendPasswordResetEmail(email: email);
      return true; // Berhasil terkirim
    } catch (e) {
      debugPrint('Forgot Password Error: $e');
      return false; // Gagal terkirim (misal email salah/tidak terdaftar)
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // =========================
  // LOGOUT
  // =========================

  Future<void> logout() async {
    await _service.logout();

    _currentUser = null;

    notifyListeners();
  }
}
