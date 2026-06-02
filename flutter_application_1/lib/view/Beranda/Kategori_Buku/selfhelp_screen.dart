import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'selfhelp_filter.dart'; // Import bottom sheet filter self help

class SelfHelpScreen extends StatefulWidget {
  const SelfHelpScreen({Key? key}) : super(key: key);

  @override
  State<SelfHelpScreen> createState() => _SelfHelpScreenState();
}

class _SelfHelpScreenState extends State<SelfHelpScreen> {
  // Data Dummy Buku Self Help sesuai isi Self Help.jpg
  final List<Map<String, dynamic>> _selfHelpList = [
    {
      'title': 'Tuntutan Shalat L..',
      'author': 'oleh Moh Rifa\'i',
      'price': 'Rp. 35.000',
      'seller': 'Buku Bekas Ayu',
      'rating': '4.8',
      'image': 'assets/tuntutan_shalat.png',
      'isLiked': false,
    },
    {
      'title': 'Berani Tidak Disukai',
      'author': 'oleh Ichiro Kishimi',
      'price': 'Rp. 50.000',
      'seller': 'Buku Bekas Ayu',
      'rating': '4.8',
      'image': 'assets/berani_tidak_disukai.png',
      'isLiked': false,
    },
    {
      'title': 'Bicara itu ada Seni..',
      'author': 'oleh Oh Su Hyang',
      'price': 'Rp. 40.000',
      'seller': 'Buku Bekas Ayu',
      'rating': '4.8',
      'image': 'assets/bicara_ada_seninya.png',
      'isLiked': false,
    },
    {
      'title': 'The Power Of Now',
      'author': 'oleh Thomas Stmaford',
      'price': 'Rp. 45.000',
      'seller': 'Buku Bekas Ayu',
      'rating': '4.8',
      'image': 'assets/the_power_of_now.png',
      'isLiked': false,
    },
    {
      'title': 'Mencari Makna Hi..',
      'author': 'Oleh Muhammad Amir',
      'price': 'Rp. 37.000',
      'seller': 'Buku Bekas Ayu',
      'rating': '4.8',
      'image': 'assets/mencari_makna_hidup.png',
      'isLiked': false,
    },
    {
      'title': 'Finding Meaning',
      'author': 'oleh Rosmaida Sinaga',
      'price': 'Rp. 38.000',
      'seller': 'Buku Bekas Ayu',
      'rating': '4.8',
      'image': 'assets/finding_meaning.png',
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
          'Self Help',
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
              // Menampilkan sheet filter khusus self help
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => const SelfHelpFilterBottomSheet(),
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
                'Renungan Diri',
                style: GoogleFonts.montserrat(
                  color: const Color(0xFF2B1608),
                  fontWeight: FontWeight.w800,
                  fontSize: 28,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Temukan kekuatan dari dalam diri dan raih potensi maksimal Anda. Kumpulan wawasan mendalam untuk hidup yang lebih damai dan bermakna.',
                style: GoogleFonts.montserrat(
                  color: const Color(0xFF6E5D53),
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 25),

              // Grid Layout Buku Self Help
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.54,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                ),
                itemCount: _selfHelpList.length,
                itemBuilder: (context, index) {
                  final item = _selfHelpList[index];
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
                    _selfHelpList[index]['isLiked'] = !item['isLiked'];
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
