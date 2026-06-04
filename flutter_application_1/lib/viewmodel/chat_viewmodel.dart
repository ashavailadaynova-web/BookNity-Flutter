import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/chat_model.dart';

class ChatViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Mengambil aliran data chat masuk secara real-time
  Stream<List<MessageModel>> streamMessages(String roomId, String currentUserId) {
    return _firestore
        .collection('rooms')
        .doc(roomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => MessageModel.fromFirestore(doc, currentUserId))
              .toList();
        });
  }

  // Mengirim pesan baru
  Future<void> sendMessage({
    required String roomId,
    required String senderId,
    required String messageText,
  }) async {
    if (messageText.trim().isEmpty) return;

    MessageModel newMessage = MessageModel(
      id: '',
      senderId: senderId,
      message: messageText,
      timestamp: DateTime.now(),
      type: MessageType.text,
    );

    try {
      await _firestore
          .collection('rooms')
          .doc(roomId)
          .collection('messages')
          .add(newMessage.toFirestore());
    } catch (e) {
      print("Gagal mengirim pesan: $e");
    }
  }
}