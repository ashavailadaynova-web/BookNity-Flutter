import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({Key? key}) : super(key: key);

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  // Master Data Buku Terfavorit sesuai Mockup Wishlist
  final List<Map<String, dynamic>> _wishlistBooks = [
    {
      'title': 'Laut Bercerita',
      'author': 'oleh Leila S. Chudori',
      'price': 'Rp. 60.000',
      'seller': 'Toko Buku Aceng',
      'rating': '4.7',
      'image': 'assets/laut_bercerita.png',
      'isLiked': true,
    },
    {
      'title': 'Pergi',
      'author': 'oleh Tere Liye',
      'price': 'Rp. 58.000',
      'seller': 'Raja Bekas',
      'rating': '4.9',
      'image': 'assets/pergi.png',
      'isLiked': true,
    },
    {
      'title': 'Terjadinya Alam S..',
      'author': 'oleh Karimatul Amali',
      'price': 'Rp. 40.000',
      'seller': 'Buku Bekas Ayu',
      'rating': '4.8',
      'image': 'assets/asal_usul_semesta.png',
      'isLiked': true,
    },
    {
      'title': 'Menu Palembang',
      'author': 'oleh Tara Budiman',
      'price': 'Rp. 34.000',
      'seller': 'Raja Bekas',
      'rating': '4.9',
      'image': 'assets/palembang.png',
      'isLiked': true,
    },
    {
      'title': 'Ibu Carikan...',
      'author': 'oleh Afifah Rahma',
      'price': 'Rp. 35.000',
      'seller': 'Buku Bekas Ayu',
      'rating': '4.8',
      'image': 'assets/ibu_carikan.png',
      'isLiked': true,
    },
    {
      'title': 'Cape Deh!',
      'author': 'oleh Sani Kurniawan',
      'price': 'Rp. 40.000',
      'seller': 'Buku Bekas Ayu',
      'rating': '4.8',
      'image': 'assets/cape_deh.png',
      'isLiked': true,
    },
  ];

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
      body: _wishlistBooks.isEmpty
          ? _buildEmptyState()
          : SingleChildScrollView(
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

                    // Grid Daftar Buku Favorit
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
                      itemCount: _wishlistBooks.length,
                      itemBuilder: (context, index) {
                        final item = _wishlistBooks[index];
                        return _buildWishlistCard(item, index);
                      },
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
    );
  }

  // Widget untuk Kartu Buku
  Widget _buildWishlistCard(Map<String, dynamic> item, int index) {
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
          // Gambar Buku / Sampul
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFF5EFE6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  item['image'],
                  fit: BoxFit.cover,
                  // Fallback jika asset gambar belum didaftarkan di pubspec.yaml
                  errorBuilder: (c, e, s) => const Center(
                    child: Icon(Icons.book, color: Color(0xFF4A352F), size: 40),
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
                  item['title'],
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
                  setState(() {
                    // Jika di-unliked, item langsung hilang dari daftar wishlist
                    _wishlistBooks.removeAt(index);
                  });
                },
                child: const Icon(
                  Icons.favorite,
                  size: 18,
                  color: Colors
                      .red, // Selalu merah karena berada di halaman Wishlist
                ),
              ),
            ],
          ),

          // Penulis Buku
          Text(
            item['author'],
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.montserrat(
              fontSize: 11,
              color: const Color(0xFF8C8C8C),
            ),
          ),
          const SizedBox(height: 4),

          // Harga Produk
          Text(
            item['price'],
            style: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 6),

          // Informasi Toko Penjual dan Rating Bintang
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
                  item['seller'],
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
                item['rating'],
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

  // State tampilan jika seluruh item wishlist dihapus oleh user
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
