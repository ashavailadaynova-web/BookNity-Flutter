import 'package:flutter/material.dart';
import '../model/chat_model.dart';
import '../model/book_model.dart';

class ChatViewModel extends ChangeNotifier {
  // Simulasi database chat room lokal / Firebase stream
  final List<MessageModel> _messages = [];

  List<MessageModel> get messages => _messages;

  // 1. Fungsi Kirim Chat Biasa / Bawa Informasi Produk (Klik Icon Chat Shopee)
  void sendMessage({
    required String text,
    BookModel? attachedBook,
    bool isProductInfo = false,
  }) {
    final now = DateTime.now();
    final timeString =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

    if (isProductInfo && attachedBook != null) {
      // Mengirimkan pesan bentuk info produk bawaan di awal chat
      _messages.add(
        MessageModel(
          isMe: true,
          time: timeString,
          type: MessageType.text,
          bookTitle: attachedBook.title,
          author: attachedBook.author,
          cover: attachedBook.image,
          price: attachedBook.price,
          text: "Halo, saya tertarik dengan buku ini!",
        ),
      );
    } else {
      _messages.add(
        MessageModel(
          text: text,
          isMe: true,
          time: timeString,
          type: MessageType.text,
        ),
      );
    }
    notifyListeners();
  }

  // 2. Fungsi Kirim Pesan Tawar Produk
  void sendOfferMessage({
    required BookModel book,
    required String offeredPrice,
  }) {
    final now = DateTime.now();
    final timeString =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

    _messages.add(
      MessageModel(
        isMe: true, // Dikirim oleh pembeli
        time: timeString,
        type: MessageType.offerPending, // Status awal: Menunggu Tanggapan
        bookTitle: book.title,
        author: book.author,
        cover: book.image,
        price: offeredPrice, // Harga yang diajukan
      ),
    );

    notifyListeners();

    // SIMULASI OTOMATIS: Anggap dalam 3 detik Penjual membalas secara acak (Untuk testing UI)
    _simulateSellerResponse();
  }

  // 3. Fungsi Update Status Tawaran (Diterima / Ditolak oleh Penjual)
  void updateOfferStatus(int index, MessageType newStatus) {
    if (index >= 0 && index < _messages.length) {
      final oldMsg = _messages[index];

      // Ganti tipe data offer-nya
      _messages[index] = MessageModel(
        isMe: oldMsg.isMe,
        time: oldMsg.time,
        type: newStatus,
        bookTitle: oldMsg.bookTitle,
        author: oldMsg.author,
        cover: oldMsg.cover,
        price: oldMsg.price,
        text: newStatus == MessageType.offerAccepted
            ? "Penawaran Anda telah diterima oleh Penjual!"
            : "Penawaran Anda ditolak oleh Penjual.",
      );
      notifyListeners();
    }
  }

  void _simulateSellerResponse() {
    Future.delayed(const Duration(seconds: 3), () {
      if (_messages.isNotEmpty) {
        // Cari index tawar terakhir, ubah seolah diterima penjual
        for (int i = _messages.length - 1; i >= 0; i--) {
          if (_messages[i].type == MessageType.offerPending) {
            updateOfferStatus(i, MessageType.offerAccepted);
            break;
          }
        }
      }
    });
  }
}
