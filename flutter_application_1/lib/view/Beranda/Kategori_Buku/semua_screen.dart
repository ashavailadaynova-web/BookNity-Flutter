import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'semua_filter.dart'; // Import bottom sheet filter campuran

class SemuaScreen extends StatefulWidget {
  const SemuaScreen({Key? key}) : super(key: key);

  @override
  State<SemuaScreen> createState() => _SemuaScreenState();
}

class _SemuaScreenState extends State<SemuaScreen> {
  // Data Dummy Gabungan Seluruh Katalog Buku sesuai mockup figma 'Semua'
  final List<Map<String, dynamic>> _semuaBukuList = [
    {
      'title': 'Laut Bercerita',
      'author': 'oleh Leila S. Chudori',
      'price': 'Rp. 60.000',
      'seller': 'Toko Buku Agung',
      'rating': '4.9',
      'image': 'assets/laut_bercerita.png',
      'isLiked': true, // Terlihat merah/liked di gambar figma
    },
    {
      'title': 'Budidaya Tanaman..',
      'author': 'oleh Mario Malado',
      'price': 'Rp. 55.000',
      'seller': 'Rumahnya Buku',
      'rating': '4.7',
      'image': 'assets/budidaya_tanaman.png',
      'isLiked': false,
    },
    {
      'title': 'Statistik',
      'author': 'oleh Anisa Uswatun',
      'price': 'Rp. 50.000',
      'seller': 'Buku Bekas Ayu',
      'rating': '4.8',
      'image': 'assets/statistik.png',
      'isLiked': false,
    },
    {
      'title': 'Penjelajah Antariksa',
      'author': 'oleh Kak Nurul',
      'price': 'Rp. 37.000',
      'seller': 'Buku Bekas Ayu',
      'rating': '4.8',
      'image': 'assets/penjelajah_antariksa.png',
      'isLiked': false,
    },
    {
      'title': 'The Midnight Libr..',
      'author': 'oleh Matt Haig',
      'price': 'Rp. 76.000',
      'seller': 'Serba Ada',
      'rating': '4.7',
      'image': 'assets/the_midnight_library.png',
      'isLiked': false,
    },
    {
      'title': 'Menu Palembang',
      'author': 'oleh Tara Budiman',
      'price': 'Rp. 34.000',
      'seller': 'Second Book',
      'rating': '4.9',
      'image': 'assets/menu_palembang.png',
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
          'Semua',
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
              // Menampilkan sheet filter khusus Semua Buku
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => const SemuaFilterBottomSheet(),
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
                'Jelajah Dunia Buku',
                style: GoogleFonts.montserrat(
                  color: const Color(0xFF2B1608),
                  fontWeight: FontWeight.w800,
                  fontSize: 28,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Jelajahi ribuan kisah dari seluruh penjuru dunia, mulai dari klasik yang tak lekang oleh waktu hingga mahakarya modern yang memikat.',
                style: GoogleFonts.montserrat(
                  color: const Color(0xFF6E5D53),
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 25),

              // Grid Layout Katalog Semua Buku
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.54,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                ),
                itemCount: _semuaBukuList.length,
                itemBuilder: (context, index) {
                  final item = _semuaBukuList[index];
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
                    _semuaBukuList[index]['isLiked'] = !item['isLiked'];
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
