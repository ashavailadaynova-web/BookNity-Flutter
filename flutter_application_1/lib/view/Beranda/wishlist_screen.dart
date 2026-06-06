import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({Key? key}) : super(key: key);

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  // 🟢 HELPER UTK FORMAT RUPIAH OTOMATIS
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

  // 🟢 FUNGSIONALITAS UNTUK MENGHAPUS DARI WISHLIST (UPDATE FIRESTORE)
  Future<void> removeFromWishlist(String docId) async {
    try {
      await FirebaseFirestore.instance.collection('books').doc(docId).update({
        'isFavorite': false,
      });
    } catch (e) {
      debugPrint('Gagal menghapus dari wishlist: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF2), // Latar cream hangat khas Figma
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFDF2),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF42210B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Wishlist',
          style: GoogleFonts.montserrat(
            color: const Color(0xFF42210B),
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),
      // 🟢 MENGGUNAKAN STREAMBUILDER UNTUK MENGAMBIL DATA REAL-TIME DARI FIRESTORE
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('books')
            .where('isFavorite', isEqualTo: true) // Hanya ambil yang di-love
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return _buildEmptyState();
          }

          final wishlistDocs = snapshot.data!.docs;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  // Tagline Atas
                  Text(
                    'PILIHAN FAVORITMU',
                    style: GoogleFonts.montserrat(
                      color: const Color(0xFFC76E2E),
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Judul Utama Halaman
                  Text(
                    'Produk Terbaik',
                    style: GoogleFonts.montserrat(
                      color: const Color(0xFF2B1608),
                      fontWeight: FontWeight.w800,
                      fontSize: 28,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Deskripsi
                  Text(
                    'Buku-buku ini membuatmu jatuh cinta berkali-kali, bahkan sampai kamu lupa bagaimana cara untuk membenci.',
                    style: GoogleFonts.montserrat(
                      color: const Color(0xFF6E5D53),
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 25),

                  // Grid Daftar Buku Favorit dari Firestore
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio:
                              0.54, // Proporsi pas untuk mockup card vertikal
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                        ),
                    itemCount: wishlistDocs.length,
                    itemBuilder: (context, index) {
                      final docId = wishlistDocs[index].id;
                      final item =
                          wishlistDocs[index].data() as Map<String, dynamic>;
                      return _buildWishlistCard(docId, item);
                    },
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // 🟢 WIDGET KARTU BUKU DIADAPTASI UNTUK FIRESTORE
  Widget _buildWishlistCard(String docId, Map<String, dynamic> item) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar Buku / Sampul (Network Image dari Cloudinary/Firestore URL)
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFF5EFE6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child:
                    item['image'] != null && item['image'].toString().isNotEmpty
                    ? Image.network(
                        item['image'],
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) => const Center(
                          child: Icon(
                            Icons.book,
                            color: Color(0xFF4A352F),
                            size: 40,
                          ),
                        ),
                      )
                    : const Center(
                        child: Icon(
                          Icons.book,
                          color: Color(0xFF4A352F),
                          size: 40,
                        ),
                      ),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Judul dan Tombol Like/Favorite
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  item['title'] ?? 'Tanpa Judul',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: const Color(0xFF2B1608),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  // 🟢 Langsung update field di Firestore, item otomatis hilang karena Stream
                  removeFromWishlist(docId);
                },
                child: const Icon(Icons.favorite, size: 18, color: Colors.red),
              ),
            ],
          ),

          // Penulis Buku
          Text(
            item['author'] ?? 'Anonim',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.montserrat(
              fontSize: 11,
              color: const Color(0xFF8C8C8C),
            ),
          ),
          const SizedBox(height: 4),

          // Harga Produk (Menggunakan Helper Format Rupiah)
          Text(
            formatRupiah(item['price'] ?? '0'),
            style: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 6),

          // Informasi Toko Penjual Dinamis dan Rating Bintang
          Row(
            children: [
              const CircleAvatar(
                radius: 9,
                backgroundColor: Color(0xFF8C8C8C),
                child: Icon(Icons.person, size: 10, color: Colors.white),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  item['storeName'] ??
                      'Toko Buku', // Menggunakan storeName dinamis
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.montserrat(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
              const Icon(Icons.star, color: Colors.amber, size: 12),
              const SizedBox(width: 2),
              Text(
                item['rating']?.toString() ?? '0.0',
                style: GoogleFonts.montserrat(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF6E5D53),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Tampilan jika seluruh item wishlist kosong
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'Wishlist kamu kosong',
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF2B1608),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Belum ada produk pilihan yang ditambahkan.',
            style: GoogleFonts.montserrat(
              fontSize: 12,
              color: const Color(0xFF6E5D53),
            ),
          ),
        ],
      ),
    );
  }
}
