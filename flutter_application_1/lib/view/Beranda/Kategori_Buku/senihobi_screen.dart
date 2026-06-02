import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'senihobi_filter.dart'; // Import filter seni/hobi

class SeniHobiScreen extends StatefulWidget {
  const SeniHobiScreen({Key? key}) : super(key: key);

  @override
  State<SeniHobiScreen> createState() => _SeniHobiScreenState();
}

class _SeniHobiScreenState extends State<SeniHobiScreen> {
  // Data Dummy Buku Seni & Hobi sesuai gambar yang kamu kirim
  final List<Map<String, dynamic>> _seniHobiList = [
    {
      'title': 'Memasak Sayur',
      'author': 'oleh Chef Haneliza',
      'price': 'Rp. 58.000',
      'seller': 'Buku Bekas Ayu',
      'rating': '4.8',
      'image': 'assets/sayur.png',
      'isLiked': true,
    },
    {
      'title': 'Menu Palembang',
      'author': 'oleh Tara Budiman',
      'price': 'Rp. 34.000',
      'seller': 'Raja Bekas',
      'rating': '4.9',
      'image': 'assets/palembang1.png',
      'isLiked': false,
    },
    {
      'title': 'Budidaya Tanaman',
      'author': 'oleh Karimatul Amali',
      'price': 'Rp. 45.000',
      'seller': 'Rumahnya Buku',
      'rating': '4.8',
      'image': 'assets/tanaman.png',
      'isLiked': false,
    },
    {
      'title': 'Belajar Gitar',
      'author': 'oleh Matt Haig',
      'price': 'Rp. 50.000',
      'seller': 'Serba Ada',
      'rating': '4.7',
      'image': 'assets/gitar1.png',
      'isLiked': false,
    },
    {
      'title': 'Master Chord Gitar',
      'author': 'oleh Kiki Laisa',
      'price': 'Rp. 35.000',
      'seller': 'Raja Bekas',
      'rating': '4.9',
      'image': 'assets/gitar2.png',
      'isLiked': false,
    },
    {
      'title': 'Menu Palembang',
      'author': 'oleh Tara Budiman',
      'price': 'Rp. 30.000',
      'seller': 'Second Book',
      'rating': '4.8',
      'image': 'assets/palembang2.png',
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
          'Seni/Hobi',
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
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => const SeniHobiFilterBottomSheet(),
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
                'Ruang Berkarya',
                style: GoogleFonts.montserrat(
                  color: const Color(0xFF2B1608),
                  fontWeight: FontWeight.w800,
                  fontSize: 28,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Waktu luang adalah waktu untuk berkarya. Temukan inspirasi tak terbatas untuk hobi dan proyek kreatif favorit Anda.',
                style: GoogleFonts.montserrat(
                  color: const Color(0xFF6E5D53),
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 25),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.54,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                ),
                itemCount: _seniHobiList.length,
                itemBuilder: (context, index) {
                  final item = _seniHobiList[index];
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
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10),
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
                  errorBuilder: (c, e, s) => const Center(
                    child: Icon(
                      Icons.palette_rounded,
                      color: Colors.brown,
                      size: 40,
                    ),
                  ),
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
              Icon(
                item['isLiked'] ? Icons.favorite : Icons.favorite_border,
                size: 18,
                color: item['isLiked'] ? Colors.red : Colors.grey,
              ),
            ],
          ),
          Text(
            item['author'],
            style: GoogleFonts.montserrat(fontSize: 11, color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Text(
            item['price'],
            style: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const CircleAvatar(
                radius: 9,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, size: 10, color: Colors.white),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  item['seller'],
                  style: GoogleFonts.montserrat(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Icon(Icons.star, color: Colors.amber, size: 12),
              Text(
                item['rating'],
                style: GoogleFonts.montserrat(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}