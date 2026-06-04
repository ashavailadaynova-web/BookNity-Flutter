import 'package:cloud_firestore/cloud_firestore.dart';

// Gunakan nama enum agar sesuai logika tipe data buatanmu
enum MessageType { text, offerPending, offerAccepted }

class MessageModel {
  final String id;
  final String senderId;
  final String message;
  final DateTime timestamp;
  final MessageType type;
  final bool isMe;
  final String time; // Untuk fallback format jam desaimu

  // Field opsional penunjang kartu penawaran (Custom Offer Card) bawaan desaimu
  final String? bookTitle;
  final String? author;
  final String? price;
  final String? cover;

  MessageModel({
    required this.id,
    required this.senderId,
    required this.message,
    required this.timestamp,
    this.type = MessageType.text,
    this.isMe = true,
    this.time = "",
    this.bookTitle,
    this.author,
    this.price,
    this.cover,
  });

  // Membaca data real-time dari Firebase Firestore
  factory MessageModel.fromFirestore(DocumentSnapshot doc, String currentUserId) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    // Logika penentuan MessageType berdasarkan string di Firebase
    MessageType msgType = MessageType.text;
    if (data['type'] == 'offerPending') msgType = MessageType.offerPending;
    if (data['type'] == 'offerAccepted') msgType = MessageType.offerAccepted;

    String sId = data['senderId'] ?? '';

    return MessageModel(
      id: doc.id,
      senderId: sId,
      message: data['message'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      type: msgType,
      isMe: sId == currentUserId, // Otomatis menentukan bubble kanan/kiri
      bookTitle: data['bookTitle'],
      author: data['author'],
      price: data['price'],
      cover: data['cover'],
    );
  }

  // Mengubah objek menjadi Map untuk dikirim ke Firebase
  Map<String, dynamic> toFirestore() {
    return {
      'senderId': senderId,
      'message': message,
      'timestamp': Timestamp.fromDate(timestamp),
      'type': type.name, // Menyimpan dalam bentuk string ('text', 'offerPending', 'offerAccepted')
      'bookTitle': bookTitle,
      'author': author,
      'price': price,
      'cover': cover,
    };
  }
}