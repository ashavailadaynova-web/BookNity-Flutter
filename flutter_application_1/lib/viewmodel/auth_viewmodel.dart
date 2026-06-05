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

      debugPrint(
        'Register Error: $e',
      );

      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // =========================
  // LOGIN
  // =========================

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      _currentUser = await _service.login(
        email: email,
        password: password,
      );

      return _currentUser != null;
    } catch (e) {
      print("LOGIN ERROR = $e");

      debugPrint(
        'Login Error: $e',
      );

      return false;
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