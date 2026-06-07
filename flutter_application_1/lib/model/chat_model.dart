import 'package:cloud_firestore/cloud_firestore.dart';

// Tipe pesan dalam obrolan Booknity
enum MessageType { text, offerPending, offerAccepted, invoice }

class MessageModel {
  final String? id; 
  final String senderId;
  final String message;
  final DateTime timestamp;
  final MessageType type;
  final bool isMe;
  final String time;

  // Field opsional untuk fitur penawaran buku dan invoice konfirmasi pembayaran
  final String? bookTitle;
  final String? author;
  final String? price;
  final String? cover;
  
  // 🟢 REVISI: Menambahkan field pendukung status pelacakan pesanan secara urut
  final String? statusPesanan; 

  MessageModel({
    this.id, 
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
    this.statusPesanan = "menunggu_konfirmasi", // 🟢 Default awal saat invoice dibuat
  });

  // Fungsi untuk konversi data dari Firebase Firestore ke Object Dart (Dipakai di Stream/Get)
  factory MessageModel.fromFirestore(
    DocumentSnapshot doc,
    String currentUserId,
  ) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    MessageType msgType = MessageType.text;
    String rawType = data['type'] ?? '';

    if (rawType == 'offerPending' || rawType == 'MessageType.offerPending') {
      msgType = MessageType.offerPending;
    } else if (rawType == 'offerAccepted' || rawType == 'MessageType.offerAccepted') {
      msgType = MessageType.offerAccepted;
    } else if (rawType == 'invoice' || rawType == 'MessageType.invoice') {
      msgType = MessageType.invoice; 
    }

    String sId = data['senderId'] ?? '';
    DateTime tStamp = (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now();

    // Otomatis generate teks waktu dari timestamp Firebase jika data 'time' di DB kosong
    String minute = tStamp.minute.toString().padLeft(2, '0');
    String period = tStamp.hour >= 12 ? "PM" : "AM";
    int displayHour = tStamp.hour > 12
        ? tStamp.hour - 12
        : (tStamp.hour == 0 ? 12 : tStamp.hour);
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
      statusPesanan: data['statusPesanan'] ?? 'menunggu_konfirmasi', // 🟢 Ambil data status dari Firestore
    );
  }

  // Fungsi untuk konversi Object Dart ke Map JSON (Dipakai saat kirim chat ke Firestore)
  Map<String, dynamic> toMap() {
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
      'statusPesanan': statusPesanan, // 🟢 Ikut di-upload saat membuat invoice baru
    };
  }
}