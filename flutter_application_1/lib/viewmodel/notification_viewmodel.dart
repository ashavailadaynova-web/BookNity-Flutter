import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/notification_model.dart';
import '../services/notification_service.dart';

class NotificationViewModel extends ChangeNotifier {
  final NotificationService _service = NotificationService();

  List<NotificationModel> _notifications = [];
  bool isLoading = true;

  List<NotificationModel> get notifications => _notifications;

  int get unreadCount => _notifications.where((n) => n.isUnread).length;

  NotificationViewModel() {
    _init();
  }

  void _init() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    _service.streamNotifications(user.uid).listen((list) {
      _notifications = list;
      isLoading = false;
      notifyListeners();
    });
  }

  List<NotificationModel> getNotifications(String filter) {
    if (filter == 'unread')
      return _notifications.where((n) => n.isUnread).toList();
    if (filter == 'read')
      return _notifications.where((n) => !n.isUnread).toList();
    return _notifications;
  }

  Future<void> markAsRead(String id) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    await _service.markAsRead(user.uid, id);
  }

  Future<void> markAllAsRead() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    await _service.markAllAsRead(user.uid);
  }
}
