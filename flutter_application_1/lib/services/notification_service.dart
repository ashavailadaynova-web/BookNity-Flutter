import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/notification_model.dart';

class NotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Kirim notifikasi ke user tertentu
  Future<void> sendNotification({
    required String toUserId,
    required String type,
    required String title,
    required String text,
    String? roomId,
    String? sellerId,
  }) async {
    try {
      await _firestore
          .collection('notifications')
          .doc(toUserId)
          .collection('items')
          .add({
            'type': type,
            'title': title,
            'text': text,
            'roomId': roomId,
            'sellerId': sellerId,
            'isUnread': true,
            'createdAt': FieldValue.serverTimestamp(),
          });
    } catch (e) {
      print('Gagal kirim notifikasi: $e');
    }
  }

  // Stream notifikasi realtime
  Stream<List<NotificationModel>> streamNotifications(String userId) {
    return _firestore
        .collection('notifications')
        .doc(userId)
        .collection('items')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((doc) => NotificationModel.fromFirestore(doc))
              .toList(),
        );
  }

  // Tandai sudah dibaca
  Future<void> markAsRead(String userId, String notifId) async {
    await _firestore
        .collection('notifications')
        .doc(userId)
        .collection('items')
        .doc(notifId)
        .update({'isUnread': false});
  }

  // Tandai semua sudah dibaca
  Future<void> markAllAsRead(String userId) async {
    final batch = _firestore.batch();
    final snap = await _firestore
        .collection('notifications')
        .doc(userId)
        .collection('items')
        .where('isUnread', isEqualTo: true)
        .get();
    for (final doc in snap.docs) {
      batch.update(doc.reference, {'isUnread': false});
    }
    await batch.commit();
  }
}
