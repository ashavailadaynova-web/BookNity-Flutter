import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String id;
  final String type;
  final String title;
  final String text;
  final String? roomId;
  final String? sellerId;
  bool isUnread;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.text,
    this.roomId,
    this.sellerId,
    this.isUnread = true,
    required this.createdAt,
  });

  factory NotificationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NotificationModel(
      id: doc.id,
      type: data['type'] ?? 'info',
      title: data['title'] ?? '',
      text: data['text'] ?? '',
      roomId: data['roomId'],
      sellerId: data['sellerId'],
      isUnread: data['isUnread'] ?? true,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'title': title,
      'text': text,
      'roomId': roomId,
      'sellerId': sellerId,
      'isUnread': isUnread,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  // Helper untuk section header
  String get section {
    final now = DateTime.now();
    final diff = now.difference(createdAt);
    if (diff.inDays == 0) return 'Hari ini';
    if (diff.inDays == 1) return 'Kemarin';
    return '${diff.inDays} hari lalu';
  }

  // Helper untuk waktu singkat
  String get timeAgo {
    final now = DateTime.now();
    final diff = now.difference(createdAt);
    if (diff.inMinutes < 60) return '${diff.inMinutes} menit lalu';
    if (diff.inHours < 24) return '${diff.inHours} jam lalu';
    if (diff.inDays == 1) return 'Kemarin';
    return '${diff.inDays} hari lalu';
  }

  // Icon berdasarkan type
  IconData get icon {
    switch (type) {
      case 'message':
        return Icons.chat_bubble_outline;
      case 'offer_accepted':
        return Icons.check_circle_outline;
      case 'offer_rejected':
        return Icons.cancel_outlined;
      case 'order_status':
        return Icons.local_shipping_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }
}
