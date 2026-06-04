import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/model/order_model.dart';

class PesananViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  // ===========================================================================
  // 📄 DATA TIRUAN (MOCK DATA) YANG DIBUTUHKAN OLEH PESANAN_SCREEN
  // ===========================================================================
  List<Map<String, dynamic>> ongoingOrders = [
    {
      'title': 'Bumi Manusia',
      'author': 'Pramoedya Ananta Toer',
      'price': 'Rp 95.000',
      'status': 'Dikirim',
      'statusColor': const Color(0xFFC76E2E),
      'image': 'assets/images/bumi_manusia.png'
    }
  ];

  List<Map<String, dynamic>> completedOrders = [
    {
      'title': 'Laskar Pelangi',
      'author': 'Andrea Hirata',
      'price': 'Rp 89.000',
      'date': '20 Mei 2026',
      'image': 'assets/images/laskar_pelangi.png'
    }
  ];

  List<Map<String, dynamic>> cancelledOrders = [];

  // ===========================================================================
  // 🔥 FUNGSI UTAMA UNTUK DATABASE/FIRESTORE
  // ===========================================================================

  // 1. Fungsi untuk membuat pesanan baru
  Future<void> buatPesanan(OrderModel order) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _firestore.collection('pesanan').add(order.toMap());
      print("Pesanan berhasil dibuat di Firestore!");
    } catch (e) {
      print("Gagal membuat pesanan: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 2. TAMBAHAN: Fungsi kirim ulasan dari Bottom Sheet ke Firestore
  Future<void> kirimUlasanKeDatabase({
    required String judulBuku,
    required int rating,
    required String deskripsi,
    required bool denganFoto,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Menyimpan data ulasan ke dalam collection 'ulasan' di Firestore
      await _firestore.collection('ulasan').add({
        'judul_buku': judulBuku,
        'rating': rating,
        'deskripsi': deskripsi,
        'dengan_foto': denganFoto,
        'tanggal_ulasan': FieldValue.serverTimestamp(),
      });
      print("Ulasan buku $judulBuku berhasil disimpan di Firestore!");
    } catch (e) {
      print("Gagal menyimpan ulasan: $e");
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