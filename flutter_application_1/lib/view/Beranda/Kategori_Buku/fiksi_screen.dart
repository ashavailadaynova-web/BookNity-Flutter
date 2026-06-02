import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'fiksi_filter.dart'; // Import file filter yang kita buat di bawah

class FiksiScreen extends StatelessWidget {
  const FiksiScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Data dummy berdasarkan gambar fiksi.jpg kamu
    final List<Map<String, dynamic>> books = [
      {
        'title': 'Laut Bercerita',
        'author': 'Leila S. Chudori',
        'price': 'Rp. 60.000',
        'shop': 'Toko Buku Aceng',
        'rating': '4.7',
        'isFavorite': true,
        'image': 'https://placeholder.com/book1' // Nanti bisa diganti asset/network image asli
      },
      {
        'title': 'Cantik Itu Luka',
        'author': 'Eka Kurniawan',
        'price': 'Rp. 58.000',
        'shop': 'Buku Bekas Ayu',
        'rating': '4.8',
        'isFavorite': false,
        'image': 'https://placeholder.com/book2'
      },
      {
        'title': 'Pergi',
        'author': 'Tere Liye',
        'price': 'Rp. 58.000',
        'shop': 'Raja Bekas',
        'rating': '4.9',
        'isFavorite': true,
        'image': 'https://placeholder.com/book3'
      },
      {
        'title': 'Bintang',
        'author': 'Tere Liye',
        'price': 'Rp. 33.000',
        'shop': 'Raja Bekas',
        'rating': '4.9',
        'isFavorite': false,
        'image': 'https://placeholder.com/book4'
      },
      {
        'title': 'The Midnight Libr...',
        'author': 'Oleh Matt Haig',
        'price': 'Rp. 76.000',
        'shop': 'Serba Ada',
        'rating': '4.7',
        'isFavorite': false,
        'image': 'https://placeholder.com/book5'
      },
      {
        'title': 'Project Hail Mary',
        'author': 'Oleh Andy Weir',
        'price': 'Rp. 58.000',
        'shop': 'Rumahnya Buku',
        'rating': '4.7',
        'isFavorite': false,
        'image': 'https://placeholder.com/book6'
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF2), // Latar krem lembut khas Booknity
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFDF2),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF42210B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Fiksi',
          style: GoogleFonts.montserrat(
            color: const Color(0xFF42210B),
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Color(0xFF42210B)),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.tune, color: Color(0xFF42210B)), // Icon filter kanan atas
            onPressed: () {
              // Menampilkan bottom sheet filter pas diklik
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => const FiksiFilter(),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'TEMUKAN YANG TERBAIK',
              style: GoogleFonts.montserrat(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: const Color(0xFFC67C4E), // Warna cokelat oranye tipis
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Jelajah Dunia Buku',
              style: GoogleFonts.montserrat(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF42210B),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Jelajahi ribuan kisah dari seluruh penjuru dunia, mulai dari klasik yang tak lekang oleh waktu hingga mahakarya modern yang memikat.',
              style: GoogleFonts.montserrat(
                fontSize: 14,
                color: const Color(0xFF705A49),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 25),

            // Grid Buku 2 Kolom
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: books.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.52, // Agar card memanjang ke bawah dengan pas
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemBuilder: (context, index) {
                final book = books[index];
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Gambar Buku & Tombol Favorite
                      Expanded(
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                color: Colors.grey[300], // Background sementara sebelum ditaruh gambar asli
                                // Image asli bisa diset di sini jika asset sudah ada:
                                // image: DecorationImage(image: AssetImage(...), fit: BoxFit.cover)
                              ),
                              child: Center(
                                child: Text(
                                  'Cover\n${book['title']}',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.montserrat(fontSize: 12, color: Colors.grey[700]),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Icon(
                                book['isFavorite'] ? Icons.favorite : Icons.favorite_border,
                                color: book['isFavorite'] ? Colors.red : Colors.grey,
                                size: 22,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Detail Informasi Buku
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              book['title'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: const Color(0xFF42210B),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'oleh ${book['author']}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.montserrat(
                                fontSize: 11,
                                color: const Color(0xFF9E8E83),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              book['price'],
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                                color: const Color(0xFF42210B),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 8,
                                  backgroundColor: Colors.grey[400],
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    book['shop'],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.montserrat(fontSize: 10, color: Colors.grey[600]),
                                  ),
                                ),
                                const Icon(Icons.star, color: Colors.amber, size: 12),
                                const SizedBox(width: 2),
                                Text(
                                  book['rating'],
                                  style: GoogleFonts.montserrat(fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}