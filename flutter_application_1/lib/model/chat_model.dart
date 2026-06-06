import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageType { text, offerPending, offerAccepted }

class MessageModel {
  final String id;
  final String senderId;
  final String message; // Tetap menggunakan nama 'message' sesuai keinginanmu
  final DateTime timestamp;
  final MessageType type;
  final bool isMe;
  final String time; 

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

  factory MessageModel.fromFirestore(DocumentSnapshot doc, String currentUserId) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    MessageType msgType = MessageType.text;
    if (data['type'] == 'offerPending') msgType = MessageType.offerPending;
    if (data['type'] == 'offerAccepted') msgType = MessageType.offerAccepted;

    String sId = data['senderId'] ?? '';
    DateTime tStamp = (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now();

    // Otomatis generate teks waktu desaimu dari timestamp Firebase
    String minute = tStamp.minute.toString().padLeft(2, '0');
    String period = tStamp.hour >= 12 ? "PM" : "AM";
    int displayHour = tStamp.hour > 12 ? tStamp.hour - 12 : (tStamp.hour == 0 ? 12 : tStamp.hour);
    String formattedTime = "${displayHour.toString().padLeft(2, '0')}:$minute $period";

    return MessageModel(
      id: doc.id,
      senderId: sId,
      message: data['message'] ?? '',
      timestamp: tStamp,
      type: msgType,
      isMe: sId == currentUserId, 
      time: data['time'] ?? formattedTime,
      bookTitle: data['bookTitle'],
      author: data['author'],
      price: data['price'],
      cover: data['cover'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'senderId': senderId,
      'message': message,
      'timestamp': Timestamp.fromDate(timestamp),
      'type': type.name, 
      'time': time,
      'bookTitle': bookTitle,
      'author': author,
      'price': price,
      'cover': cover,
    };
  }
}