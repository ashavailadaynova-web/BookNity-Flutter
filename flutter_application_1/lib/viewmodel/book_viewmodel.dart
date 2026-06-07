import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:firebase_auth/firebase_auth.dart'; // 🟢 Untuk deteksi sesi login pengguna
import 'package:cloud_firestore/cloud_firestore.dart'; // 🟢 Untuk mengambil nama pengguna dari database

import '../model/book_model.dart';
import '../services/book_service.dart';

class BookViewModel extends ChangeNotifier {
  final BookService _service = BookService();


  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Stream<List<BookModel>> get booksStream => _service.getBooks();

  List<BookModel> _books = [];

  List<BookModel> getAllBooks() {
    return _books;
  }

  List<BookModel> getMyBooks(
      String uid,
    ) {
      return _books.where((book) {
        return book.sellerId == uid;
      }).toList();
    }

  List<BookModel> searchBooks(String keyword) {
    return _books.where((book) {
      return book.title.toLowerCase().contains(keyword.toLowerCase()) ||
          book.author.toLowerCase().contains(keyword.toLowerCase());
    }).toList();
  }

  

  List<BookModel> getBooksByCategory(String category) {
    if (category == 'SEMUA') {
      return _books;
    }

    return _books.where((book) {
      return book.category.toLowerCase() == category.toLowerCase();
    }).toList();
  }

  List<BookModel> filterBooks({String? category, double? minRating}) {
    List<BookModel> result = _books;

    if (category != null && category.isNotEmpty && category != 'SEMUA') {
      result = result.where((book) {
        return book.category.toLowerCase() == category.toLowerCase();
      }).toList();
    }

    if (minRating != null) {
      result = result.where((book) {
        return book.rating >= minRating;
      }).toList();
    }

    return result;
  }

  // Fungsi uploadImage dialihkan dari Firebase Storage ke Cloudinary
  Future<String> uploadImage(File imageFile) async {
    try {
      // ⚠️ DATA DASHBOARD CLOUDINARY KAMU
      final cloudinary = CloudinaryPublic(
        'dgikejn83', // Cloud Name
        'UploadImage', // Upload Preset (Unsigned)
        cache: false,
      );

      // Mulai proses upload file gambar ke cloud
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          imageFile.path,
          resourceType: CloudinaryResourceType.Image,
        ),
      );

      // Mengembalikan URL publik aman (https://res.cloudinary.com/...)
      return response.secureUrl;
    } catch (e) {
      // Melempar pesan error jika koneksi/data bermasalah agar tertangkap di UI Snackbar
      throw Exception("Gagal mengunggah gambar ke Cloudinary: $e");
    }
  }

  // 🟢 KODE FULL SINKRONISASI NAMA TOKO OTOMATIS
  Future<void> addBook(BookModel book) async {
    _isLoading = true;
    notifyListeners();

    try {
      // 1. Dapatkan user aktif dari Firebase Auth
      final User? currentUser = FirebaseAuth.instance.currentUser;
      String namaTokoOtomatis = "Toko Buku"; // Nama cadangan standar (fallback)

      if (currentUser != null) {
        // 2. Ambil dokumen profil user dari Firestore koleksi 'users' berdasarkan UID
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();

        if (userDoc.exists && userDoc.data() != null) {
          final userData = userDoc.data() as Map<String, dynamic>;

          // 3. Ambil nilai field 'name' atau 'username' dari dokumen user di database
          namaTokoOtomatis =
              userData['name'] ?? userData['username'] ?? "Toko Buku";
        }
      }

      // 4. Modifikasi/Duplikat data BookModel menggunakan fungsi .copyWith() bawaan model
      final bookWithCorrectStore = book.copyWith(storeName: namaTokoOtomatis);

      // 5. Kirim data yang sudah membawa nama toko pengguna ke BookService untuk disimpan ke Firestore
      await _service.addBook(bookWithCorrectStore);
    } catch (e) {
      throw Exception("Gagal menambahkan produk buku: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateBook(BookModel book) async {
    await _service.updateBook(book);
  }

  Future<void> deleteBook(String id) async {
    await _service.deleteBook(id);
  }

  Future<BookModel?> getBookById(String id) async {
    return await _service.getBookById(id);
  }
}
