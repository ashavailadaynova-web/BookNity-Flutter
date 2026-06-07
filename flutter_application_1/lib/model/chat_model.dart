import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageType { text, offerPending, offerAccepted }

class MessageModel {
  final String?
  id; // 🟢 DIUBAH: Dibuat nullable & hapus 'required' agar tidak error saat kirim chat baru
  final String senderId;
  final String message;
  final DateTime timestamp;
  final MessageType type;
  final bool isMe;
  final String time;

  // Field opsional untuk fitur penawaran buku
  final String? bookTitle;
  final String? author;
  final String? price;
  final String? cover;

  MessageModel({
    this.id, // 🟢 Tidak required karena Firestore yang akan meng-generate ID ini otomatis
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

  // Fungsi untuk konversi data dari Firebase Firestore ke Object Dart (Dipakai di Stream/Get)
  factory MessageModel.fromFirestore(
    DocumentSnapshot doc,
    String currentUserId,
  ) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    MessageType msgType = MessageType.text;
    if (data['type'] == 'offerPending' ||
        data['type'] == 'MessageType.offerPending')
      msgType = MessageType.offerPending;
    if (data['type'] == 'offerAccepted' ||
        data['type'] == 'MessageType.offerAccepted')
      msgType = MessageType.offerAccepted;

    String sId = data['senderId'] ?? '';
    DateTime tStamp =
        (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now();

    // Otomatis generate teks waktu desainmu dari timestamp Firebase jika data 'time' di DB kosong
    String minute = tStamp.minute.toString().padLeft(2, '0');
    String period = tStamp.hour >= 12 ? "PM" : "AM";
    int displayHour = tStamp.hour > 12
        ? tStamp.hour - 12
        : (tStamp.hour == 0 ? 12 : tStamp.hour);
    String formattedTime =
        "${displayHour.toString().padLeft(2, '0')}:$minute $period";

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

  // Fungsi untuk konversi Object Dart ke Map JSON (Dipakai saat kirim chat ke Firestore)
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'message': message,
      'timestamp': Timestamp.fromDate(timestamp),
      'type': type
          .name, // Menyimpan dalam bentuk string nama ('text', 'offerPending', 'offerAccepted')
      'time': time,
      'bookTitle': bookTitle,
      'author': author,
      'price': price,
      'cover': cover,
    };
  }
}
