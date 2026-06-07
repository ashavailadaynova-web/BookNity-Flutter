import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'filter_bottom_sheet.dart';
import '../../model/book_model.dart'; // Memastikan import model buku kelompokmu aktif
import '../product_detail_screen.dart';
import '../../widgets/buyer_product_card.dart';

class CategoryScreen extends StatefulWidget {
  final String category;

  const CategoryScreen({super.key, required this.category});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  double _selectedRating = 0.0;

  // Helper formatting mata uang Rupiah
  String formatRupiah(String hargaRaw) {
    if (hargaRaw.isEmpty) return 'Rp 0';
    String cleanHarga = hargaRaw.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanHarga.isEmpty) return 'Rp 0';

    final value = int.tryParse(cleanHarga) ?? 0;
    String str = value.toString();
    String result = '';
    int count = 0;

    for (int i = str.length - 1; i >= 0; i--) {
      result = str[i] + result;
      count++;
      if (count == 3 && i != 0) {
        result = '.$result';
        count = 0;
      }
    }
    return 'Rp $result';
  }

  // Fungsionalitas Toggle Wishlist di Halaman Kategori
  Future<void> toggleWishlist(String docId, bool currentStatus) async {
    try {
      await FirebaseFirestore.instance.collection('books').doc(docId).update({
        'isFavorite': !currentStatus,
      });
    } catch (e) {
      debugPrint('Gagal update wishlist: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // 🟢 Ambil seluruh data dari Firestore terlebih dahulu untuk difilter secara fleksibel di lokal
    Query query = FirebaseFirestore.instance.collection('books');

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF2),
      appBar: AppBar(
        title: Text(widget.category),
        backgroundColor: const Color(0xFF4A2E2B),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () async {
              final result = await showModalBottomSheet(
                context: context,
                builder: (_) => const FilterBottomSheet(),
              );

              if (result != null) {
                setState(() {
                  _selectedRating = (result as num).toDouble();
                });
              }
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: query.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada buku di dalam database',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            );
          }

          // 🟢 PROSES FILTERING LOKAL (Kebal dari Bug Huruf Besar/Kecil Firestore)
          final docs = snapshot.data!.docs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;

            // Mengubah kategori dari database dan target tombol menjadi huruf kecil semua + hapus spasi hantu
            String dbCategory = (data['category'] ?? '')
                .toString()
                .trim()
                .toLowerCase();
            String targetCategory = widget.category.trim().toLowerCase();

            // Cek kondisi filter rating
            final rating =
                double.tryParse(data['rating']?.toString() ?? '0.0') ?? 0.0;
            bool matchesRating = rating >= _selectedRating;

            // Jika memilih kategori 'SEMUA', tampilkan semua buku yang lolos rating
            if (targetCategory == 'semua') {
              return matchesRating;
            } else {
              // Jika kategori spesifik, harus cocok teksnya secara case-insensitive
              return dbCategory == targetCategory && matchesRating;
            }
          }).toList();

          // Jika setelah difilter hasilnya kosong atau tidak kecocokan teks
          if (docs.isEmpty) {
            return Center(
              child: Text(
                'Belum ada buku untuk kategori ${widget.category}',
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.55,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemBuilder: (context, index) {
              final docId = docs[index].id;
              final bookMap = docs[index].data() as Map<String, dynamic>;
              final bool favStatus = bookMap['isFavorite'] ?? false;

              return BuyerProductCard(
                imageUrl: bookMap['image'] ?? bookMap['imageUrl'] ?? '',
                title: bookMap['title'] ?? '',
                author: bookMap['author'] ?? '',
                price: formatRupiah(bookMap['price']?.toString() ?? ''),
                rating: bookMap['rating']?.toString() ?? '0.0',
                storeName: bookMap['storeName'] ?? 'Toko Buku',
                isFavorite: favStatus,
                onTap: () {
                  // Konversi map Firestore menjadi bentuk objek BookModel sebelum dilempar ke detail screen
                  BookModel selectedBook = BookModel.fromMap(bookMap, docId);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductDetailScreen(book: selectedBook),
                    ),
                  );
                },
                onFavoriteTap: () {
                  toggleWishlist(docId, favStatus);
                },
              );
            },
          );
        },
      ),
    );
  }
}
