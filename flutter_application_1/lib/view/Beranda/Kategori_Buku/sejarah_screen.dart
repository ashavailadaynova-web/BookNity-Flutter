import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'sejarah_filter.dart'; // Import filter sejarah ke sini

class SejarahScreen extends StatefulWidget {
  const SejarahScreen({Key? key}) : super(key: key);

  @override
  State<SejarahScreen> createState() => _SejarahScreenState();
}

class _SejarahScreenState extends State<SejarahScreen> {
  // Data Dummy Buku Sejarah sesuai gambar SEJARAH.jpg
  final List<Map<String, dynamic>> _sejarahList = [
    {
      'title': 'Danau Toba',
      'author': 'oleh Yusnitia Angelia',
      'price': 'Rp. 30.000',
      'seller': 'Buku Bekas Ayu',
      'rating': '4.8',
      'image': 'assets/danau_toba.png',
      'isLiked': false,
    },
    {
      'title': 'Terjadinya Alam S..',
      'author': 'oleh Karimatul Amali',
      'price': 'Rp. 40.000',
      'seller': 'Buku Bekas Ayu',
      'rating': '4.8',
      'image': 'assets/alam_semesta.png',
      'isLiked': true,
    },
    {
      'title': 'Nenek Moyang In..',
      'author': 'oleh Joko Anwar',
      'price': 'Rp. 35.000',
      'seller': 'Buku Bekas Ayu',
      'rating': '4.8',
      'image': 'assets/nenek_moyang.png',
      'isLiked': false,
    },
    {
      'title': 'The History Of Java',
      'author': 'oleh Thomas Stamford',
      'price': 'Rp. 45.000',
      'seller': 'Buku Bekas Ayu',
      'rating': '4.8',
      'image': 'assets/history_java.png',
      'isLiked': false,
    },
    {
      'title': 'Penataan Mandar',
      'author': 'oleh Muhammad Amir',
      'price': 'Rp. 37.000',
      'seller': 'Buku Bekas Ayu',
      'rating': '4.8',
      'image': 'assets/penataan_mandar.png',
      'isLiked': false,
    },
    {
      'title': 'Masa Kuasa Belan..',
      'author': 'oleh Rosmaida Sinaga',
      'price': 'Rp. 38.000',
      'seller': 'Buku Bekas Ayu',
      'rating': '4.8',
      'image': 'assets/kuasa_belanda.png',
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
          'Sejarah',
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
              // Menampilkan sheet filter sejarah
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => const SejarahFilterBottomSheet(),
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
                'TEMUKAN YANG TERBAIK',
                style: GoogleFonts.montserrat(
                  color: const Color(0xFFC76E2E),
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Kisah Nyata',
                style: GoogleFonts.montserrat(
                  color: const Color(0xFF2B1608),
                  fontWeight: FontWeight.w800,
                  fontSize: 28,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Susuri kembali jejak peristiwa yang membentuk dunia kita. Kisah nyata epik dari tokoh-tokoh besar dan peradaban masa lalu.',
                style: GoogleFonts.montserrat(
                  color: const Color(0xFF6E5D53),
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 25),
              
              // Grid Daftar Buku Sejarah
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.54, 
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                ),
                itemCount: _sejarahList.length,
                itemBuilder: (context, index) {
                  final item = _sejarahList[index];
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
                      child: Icon(Icons.menu_book_rounded, color: Colors.brown.shade200, size: 40),
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
                    _sejarahList[index]['isLiked'] = !item['isLiked'];
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