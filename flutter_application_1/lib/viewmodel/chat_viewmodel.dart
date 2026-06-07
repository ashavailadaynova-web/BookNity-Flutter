import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/chat_model.dart';

class ChatViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Mendapatkan ID Pengguna Aktif dari Firebase Auth
  String get currentUserId => _auth.currentUser?.uid ?? "USER_DUMMY_ID";

  // Helper untuk membuat Room ID unik antara Pembeli & Penjual
  String getRoomId(String userA, String userB) {
    List<String> ids = [userA, userB];
    ids.sort(); // Diurutkan agar ID Room bernilai sama bagi pembeli maupun penjual
    return ids.join("_");
  }

  // Alias helper jika halaman lain memanggil getChatRoomId
  String getChatRoomId(String userA, String userB) => getRoomId(userA, userB);

  // STREAM: Mengambil data chat secara Real-Time dari Firestore
  Stream<List<MessageModel>> streamMessages(String roomId) {
    return _firestore
        .collection('chat_rooms')
        .doc(roomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => MessageModel.fromFirestore(doc, currentUserId))
              .toList();
        });
  }

  // Fungsi Kirim Chat Biasa
  Future<void> sendMessage({
    required String roomId,
    required String text,
  }) async {
    if (text.trim().isEmpty) return;
    final now = DateTime.now();

    final newMessage = MessageModel(
      senderId: currentUserId,
      message: text.trim(),
      timestamp: now,
      type: MessageType.text,
    );

    await _firestore
        .collection('chat_rooms')
        .doc(roomId)
        .collection('messages')
        .add(newMessage.toMap());
  }

  Future<Map<String, dynamic>?> getSellerProfile(String sellerId) async {
    try {
      // Sesuaikan nama collection 'users' dengan nama collection user di Firebase milikmu
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(sellerId)
          .get();

      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      }
    } catch (e) {
      print("Error fetching seller profile: $e");
    }
    return null;
  }

  // 🟢 PERBAIKAN ERROR 2: Fungsi sendProductOffer dengan parameter lengkap
  Future<void> sendProductOffer({
    required String sellerId,
    required String bookId,
    required String title,
    required String author,
    required String image,
    required int originalPrice,
    required int offeredPrice,
  }) async {
    final now = DateTime.now();
    String roomId = getRoomId(currentUserId, sellerId);

    final newOffer = MessageModel(
      senderId: currentUserId,
      message: "Mengajukan penawaran harga",
      timestamp: now,
      type: MessageType.offerPending,
      bookTitle: title,
      author: author,
      cover: image,
      price: offeredPrice.toString(), // Disimpan sebagai string penawaran
    );

    await _firestore
        .collection('chat_rooms')
        .doc(roomId)
        .collection('messages')
        .add(newOffer.toMap());
  }

  // 🟢 PERBAIKAN ERROR 5: Fungsi sendProductPreview dengan parameter lengkap
  Future<void> sendProductPreview({
    required String sellerId,
    required String bookId,
    required String title,
    required String author,
    required String image,
    required int price,
  }) async {
    final now = DateTime.now();
    String roomId = getRoomId(currentUserId, sellerId);

    final previewMessage = MessageModel(
      senderId: currentUserId,
      message: "Halo, saya tertarik dengan buku ini!",
      timestamp: now,
      type: MessageType.text,
      bookTitle: title,
      author: author,
      cover: image,
      price: price.toString(),
    );

    await _firestore
        .collection('chat_rooms')
        .doc(roomId)
        .collection('messages')
        .add(previewMessage.toMap());
  }

  // Fungsi Update Status Tawaran (Diterima / Ditolak oleh Penjual) di Firestore
  Future<void> updateOfferStatus({
    required String roomId,
    required String messageId,
    required MessageType newStatus,
  }) async {
    String noticeText = newStatus == MessageType.offerAccepted
        ? "Penawaran Anda telah diterima oleh Penjual!"
        : "Penawaran Anda ditolak oleh Penjual.";

    await _firestore
        .collection('chat_rooms')
        .doc(roomId)
        .collection('messages')
        .doc(messageId)
        .update({'type': newStatus.name, 'message': noticeText});
  }
}
