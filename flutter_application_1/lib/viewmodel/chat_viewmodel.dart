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

    WriteBatch batch = _firestore.batch();

    // 1. Simpan pesan ke sub-koleksi messages
    DocumentReference messageRef = _firestore
        .collection('chat_rooms')
        .doc(roomId)
        .collection('messages')
        .doc();
    batch.set(messageRef, newMessage.toMap());

    // 2. Update data root chat_rooms untuk kebutuhan Inbox
    DocumentReference roomRef = _firestore.collection('chat_rooms').doc(roomId);
    List<String> userIds = roomId.split("_");
    
    batch.set(roomRef, {
      'participants': userIds,
      'lastMessage': text.trim(),
      'lastTime': FieldValue.serverTimestamp(),
      'unread': true,
    }, SetOptions(merge: true));

    await batch.commit();
    notifyListeners();
  }

  // Mengirim Card Invoice Konfirmasi Pembayaran ke Firestore & Otomatis ke My Order
  Future<void> sendInvoiceMessage({
    required String roomId,
    required String address,
    required String title,
    required String author,
    required String image,
    required String totalPrice,
    String? sellerId,
  }) async {
    try {
      final now = DateTime.now();

      DocumentReference messageRef = _firestore
          .collection('chat_rooms')
          .doc(roomId)
          .collection('messages')
          .doc();

      final invoiceMessage = MessageModel(
        id: messageRef.id,
        senderId: currentUserId,
        message: address.trim(),
        timestamp: now,
        type: MessageType.invoice,
        bookTitle: title,
        author: author,
        cover: image,
        price: totalPrice,
        statusPesanan: "menunggu_konfirmasi",
      );

      WriteBatch batch = _firestore.batch();

      batch.set(messageRef, invoiceMessage.toMap());

      DocumentReference roomRef = _firestore.collection('chat_rooms').doc(roomId);
      List<String> userIds = roomId.split("_");
      batch.set(roomRef, {
        'participants': userIds,
        'lastMessage': "Mengirimkan konfirmasi pembayaran (Invoice)",
        'lastTime': FieldValue.serverTimestamp(),
        'unread': true,
      }, SetOptions(merge: true));

      DocumentReference orderRef = _firestore.collection('orders').doc(messageRef.id);
      
      batch.set(orderRef, {
        'orderId': messageRef.id,
        'roomId': roomId,
        'messageId': messageRef.id,
        'buyerId': currentUserId, 
        'sellerId': sellerId ?? '', 
        'bookTitle': title,
        'author': author,
        'price': totalPrice,
        'cover': image,
        'statusPesanan': 'menunggu_konfirmasi',
        'address': address.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      await batch.commit();
      notifyListeners();
    } catch (e) {
      print("Gagal mengirim invoice ke chat & orders: $e");
    }
  }

  // Update Status Urutan Alur Pesanan di Invoice (Sinkronisasi Otomatis Dua Arah)
  Future<void> updateInvoiceStatus({
    required String roomId,
    required String messageId,
    required String newStatus,
  }) async {
    try {
      if (messageId.isEmpty) return;
      
      WriteBatch batch = _firestore.batch();

      DocumentReference messageRef = _firestore
          .collection('chat_rooms')
          .doc(roomId)
          .collection('messages')
          .doc(messageId);
      batch.update(messageRef, {'statusPesanan': newStatus});

      DocumentReference orderRef = _firestore.collection('orders').doc(messageId);
      batch.update(orderRef, {'statusPesanan': newStatus});

      await batch.commit();
      notifyListeners();
    } catch (e) {
      print("Gagal mengupdate status pesanan secara sinkron: $e");
    }
  }

  Future<Map<String, dynamic>?> getSellerProfile(String sellerId) async {
    try {
      DocumentSnapshot doc = await _firestore
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

  // Fungsi sendProductOffer dengan parameter lengkap
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
      price: offeredPrice.toString(),
    );

    WriteBatch batch = _firestore.batch();

    DocumentReference messageRef = _firestore
        .collection('chat_rooms')
        .doc(roomId)
        .collection('messages')
        .doc();
    batch.set(messageRef, newOffer.toMap());

    DocumentReference roomRef = _firestore.collection('chat_rooms').doc(roomId);
    List<String> userIds = roomId.split("_");
    batch.set(roomRef, {
      'participants': userIds,
      'lastMessage': "Mengajukan penawaran Rp $offeredPrice",
      'lastTime': FieldValue.serverTimestamp(),
      'unread': true,
    }, SetOptions(merge: true));

    await batch.commit();
    notifyListeners();
  }

  // Fungsi sendProductPreview dengan parameter lengkap
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

    WriteBatch batch = _firestore.batch();

    DocumentReference messageRef = _firestore
        .collection('chat_rooms')
        .doc(roomId)
        .collection('messages')
        .doc();
    batch.set(messageRef, previewMessage.toMap());

    DocumentReference roomRef = _firestore.collection('chat_rooms').doc(roomId);
    List<String> userIds = roomId.split("_");
    batch.set(roomRef, {
      'participants': userIds,
      'lastMessage': "Tertarik dengan buku: $title",
      'lastTime': FieldValue.serverTimestamp(),
      'unread': true,
    }, SetOptions(merge: true));

    await batch.commit();
    notifyListeners();
  }

  // FUNGSI UNTUK MENERIMA PENAWARAN & OTOMATIS MASUK KE MY ORDER
  Future<void> updateOfferStatus({
    required String roomId,
    required String messageId,
    required String newStatus, 
  }) async {
    try {
      DocumentSnapshot messageDoc = await _firestore
          .collection('chat_rooms')
          .doc(roomId)
          .collection('messages')
          .doc(messageId)
          .get();

      if (!messageDoc.exists) return;
      
      Map<String, dynamic> msgData = messageDoc.data() as Map<String, dynamic>;
      WriteBatch batch = _firestore.batch();

      DocumentReference messageRef = _firestore
          .collection('chat_rooms')
          .doc(roomId)
          .collection('messages')
          .doc(messageId);
          
      batch.update(messageRef, {
        'type': newStatus, 
        'statusPesanan': 'disetujui', 
      });

      DocumentReference orderRef = _firestore.collection('orders').doc(messageId);
      
      batch.set(orderRef, {
        'orderId': messageId,
        'roomId': roomId,
        'messageId': messageId,
        'buyerId': msgData['senderId'],       
        'sellerId': currentUserId,            
        'bookTitle': msgData['bookTitle'] ?? 'Buku Novel',
        'author': msgData['author'] ?? 'Penulis',
        'price': msgData['price'] ?? '0',
        'cover': msgData['cover'] ?? '',
        'statusPesanan': 'disetujui',         
        'address': '',                        
        'createdAt': FieldValue.serverTimestamp(), 
      });

      await batch.commit();
      notifyListeners();
    } catch (e) {
      print("Gagal menyetujui penawaran & membuat order: $e");
      rethrow;
    }
  }
}