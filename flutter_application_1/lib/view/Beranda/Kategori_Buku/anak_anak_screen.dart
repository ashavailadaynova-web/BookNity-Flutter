import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'anak_anak_filter.dart'; // Import bottom sheet filter khusus anak-anak

class AnakAnakScreen extends StatefulWidget {
  const AnakAnakScreen({Key? key}) : super(key: key);

  @override
  State<AnakAnakScreen> createState() => _AnakAnakScreenState();
}

class _AnakAnakScreenState extends State<AnakAnakScreen> {
  // Data Dummy Buku Anak-Anak sesuai dengan isi gambar figma anak-anak
  final List<Map<String, dynamic>> _anakAnakList = [
    {
      'title': 'Cerita Anak Pembe..',
      'author': 'oleh Kak Nurul',
      'price': 'Rp. 29.900',
      'seller': 'Buku Bekas Ayu',
      'rating': '4.8',
      'image': 'assets/cerita_anak_pemberani.png',
      'isLiked': false,
    },
    {
      'title': 'Coding Untuk Ibu..',
      'author': 'oleh Ariyo & Sani',
      'price': 'Rp. 29.900',
      'seller': 'Buku Bekas Ayu',
      'rating': '4.8',
      'image': 'assets/coding_ibu_anak.png',
      'isLiked': false,
    },
    {
      'title': 'Akhlak Sehari-Hari',
      'author': 'oleh Oh Cahyadi',
      'price': 'Rp. 30.000',
      'seller': 'Buku Bekas Ayu',
      'rating': '4.8',
      'image': 'assets/akhlak_sehari_hari.png',
      'isLiked': false,
    },
    {
      'title': 'Aku Bisa Berhitung',
      'author': 'oleh Thomas Stamford',
      'price': 'Rp. 45.000',
      'seller': 'Buku Bekas Ayu',
      'rating': '4.8',
      'image': 'assets/aku_bisa_berhitung.png',
      'isLiked': false,
    },
    {
      'title': 'Cape Deh!',
      'author': 'oleh Sani Kurniawan',
      'price': 'Rp. 40.000',
      'seller': 'Buku Bekas Ayu',
      'rating': '4.8',
      'image': 'assets/cape_deh.png',
      'isLiked': false,
    },
    {
      'title': 'Dongeng Nusantara',
      'author': 'oleh Rosmaida Sinaga',
      'price': 'Rp. 39.000',
      'seller': 'Buku Bekas Ayu',
      'rating': '4.8',
      'image': 'assets/dongeng_nusantara.png',
      'isLiked': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFDF2),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF42210B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Anak - Anak',
          style: GoogleFonts.montserrat(
            color: const Color(0xFF42210B),
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Color(0xFF42210B)),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.tune_rounded, color: Color(0xFF42210B)),
            onPressed: () {
              // Menampilkan sheet filter khusus anak-anak
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => const AnakAnakFilterBottomSheet(),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Text(
                'CURATED SELECTION',
                style: GoogleFonts.montserrat(
                  color: const Color(0xFFC76E2E),
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Petualangan Ajaib',
                style: GoogleFonts.montserrat(
                  color: const Color(0xFF2B1608),
                  fontWeight: FontWeight.w800,
                  fontSize: 28,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Bawa si kecil terbang bebas ke dunia penuh keajaiban. Pilihan dongeng dan cerita bergambar memikat untuk menemani waktu tidur mereka.',
                style: GoogleFonts.montserrat(
                  color: const Color(0xFF6E5D53),
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 25),

              // Grid Layout Buku Anak-Anak
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.54,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                ),
                itemCount: _anakAnakList.length,
                itemBuilder: (context, index) {
                  final item = _anakAnakList[index];
                  return _buildBookCard(item, index);
                },
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookCard(Map<String, dynamic> item, int index) {
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
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Icon(
                        Icons.menu_book_rounded,
                        color: Colors.brown.shade200,
                        size: 40,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
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
                    _anakAnakList[index]['isLiked'] = !item['isLiked'];
                  });
                },
                child: Icon(
                  item['isLiked'] ? Icons.favorite : Icons.favorite_border,
                  size: 18,
                  color: item['isLiked'] ? Colors.red : const Color(0xFF8C8C8C),
                ),
              ),
            ],
          ),
          Text(
            item['author'],
            style: GoogleFonts.montserrat(
              fontSize: 11,
              color: const Color(0xFF8C8C8C),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            item['price'],
            style: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF2B1608),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              CircleAvatar(
                radius: 9,
                backgroundColor: Colors.grey.shade300,
                child: const Icon(Icons.person, size: 10, color: Colors.white),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  item['seller'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.montserrat(
                    fontSize: 10,
                    color: const Color(0xFF6E5D53),
                    fontWeight: FontWeight.w500,
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
                  color: const Color(0xFF8C8C8C),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
