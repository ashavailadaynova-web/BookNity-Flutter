import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String? id;
  final String buyerId;
  final String sellerId; // Sudah dipastikan bersih tanpa spasi di variabel
  final String bookTitle;
  final String author;
  final String cover;
  final String price;
  final String statusPesanan;
  final String alamat;
  final String? roomId;
  final Timestamp? createdAt;

  const OrderModel({
    this.id,
    required this.buyerId,
    required this.sellerId,
    required this.bookTitle,
    required this.author,
    required this.cover,
    required this.price,
    required this.statusPesanan,
    required this.alamat,
    this.roomId,
    this.createdAt,
  });

  OrderModel copyWith({
    String? id,
    String? buyerId,
    String? sellerId,
    String? bookTitle,
    String? author,
    String? cover,
    String? price,
    String? statusPesanan,
    String? alamat,
    String? roomId,
    Timestamp? createdAt,
  }) {
    return OrderModel(
      id: id ?? this.id,
      buyerId: buyerId ?? this.buyerId,
      sellerId: sellerId ?? this.sellerId,
      bookTitle: bookTitle ?? this.bookTitle,
      author: author ?? this.author,
      cover: cover ?? this.cover,
      price: price ?? this.price,
      statusPesanan: statusPesanan ?? this.statusPesanan,
      alamat: alamat ?? this.alamat,
      roomId: roomId ?? this.roomId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory OrderModel.fromMap(Map<String, dynamic> map, String documentId) {
    return OrderModel(
      id: documentId,
      buyerId: map['buyerId'] ?? '',
      // Toleransi jika data di Firestore telanjur disimpan menggunakan spasi 'sellerId '
      sellerId: map['sellerId'] ?? map['sellerId '] ?? '',
      bookTitle: map['bookTitle'] ?? '',
      author: map['author'] ?? '',
      cover: map['cover'] ?? '',
      price: map['price']?.toString() ?? '',
      statusPesanan: map['statusPesanan'] ?? 'menunggu_konfirmasi',
      alamat: map['alamat'] ?? map['address'] ?? 'Alamat tidak tertera',
      roomId: map['roomId'],
      createdAt: map['createdAt'] as Timestamp?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'buyerId': buyerId,
      'sellerId': sellerId, // 🔥 REVISI: Spasi gaib setelah huruf 'd' sudah dihapus total!
      'bookTitle': bookTitle,
      'author': author,
      'cover': cover,
      'price': price,
      'statusPesanan': statusPesanan,
      'alamat': alamat,
      'roomId': roomId,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }
}