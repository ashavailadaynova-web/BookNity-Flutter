import 'package:flutter/material.dart';

import '../model/user_model.dart';
import '../services/user_service.dart';

class UserViewModel extends ChangeNotifier {
  final UserService _service =
      UserService();

  bool _isLoading = false;

  bool get isLoading => _isLoading;
  
  UserModel? _currentUser;

  UserModel? get currentUser =>
      _currentUser;

  // =========================
  // GET USER
  // =========================

  Future<void> getUser(
    String uid,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      _currentUser =
          await _service.getUser(uid);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // =========================
  // CREATE USER
  // =========================

  Future<void> createUser(
    UserModel user,
  ) async {
    await _service.createUser(user);

    _currentUser = user;

    notifyListeners();
  }

  // =========================
  // UPDATE USER
  // =========================

  Future<void> updateUser(
    UserModel user,
  ) async {
    await _service.updateUser(user);

    _currentUser = user;

    notifyListeners();
  }

  // =========================
  // DELETE USER
  // =========================

  Future<void> deleteUser(
    String uid,
  ) async {
    await _service.deleteUser(uid);

    _currentUser = null;

    notifyListeners();
  }
}