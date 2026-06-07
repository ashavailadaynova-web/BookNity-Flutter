import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/model/order_model.dart';

class PesananViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  // ===========================================================================
  // 🔥 FUNGSI UTAMA UNTUK DATABASE/FIRESTORE
  // ===========================================================================

  // 1. Fungsi untuk membuat pesanan baru
  Future<void> buatPesanan(OrderModel order) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _firestore.collection('orders').add(order.toMap());
      print("Pesanan berhasil dibuat di Firestore!");
    } catch (e) {
      print("Gagal membuat pesanan: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 2. REVISI: Fungsi kirim ulasan Toko/Penjual ke Firestore
  Future<void> kirimUlasanKeDatabase({
    required String sellerId, // Menampung ID penjual/toko yang diulas
    required String judulBuku, // Tetap dicatat sebagai referensi transaksi buku apa
    required int rating,
    required String deskripsi,
    required bool denganFoto,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Menyimpan data ulasan ke dalam collection 'reviews'
      await _firestore.collection('reviews').add({
        'sellerId': sellerId,
        'judul_buku_referensi': judulBuku,
        'rating': rating,
        'deskripsi': deskripsi,
        'dengan_foto': denganFoto,
        'tanggal_ulasan': FieldValue.serverTimestamp(),
      });
      print("Ulasan untuk toko $sellerId berhasil disimpan di Firestore!");
    } catch (e) {
      print("Gagal menyimpan ulasan toko: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 3. Fungsi untuk mengupload bukti transfer
  Future<void> uploadBuktiTransfer(String orderId) async {
    // Logika image_picker dan firebase_storage ditaruh di sini nanti
  }
}