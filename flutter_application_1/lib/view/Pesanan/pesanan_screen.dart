import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PesananScreen extends StatefulWidget {
  const PesananScreen({Key? key}) : super(key: key);

  @override
  State<PesananScreen> createState() => _PesananScreenState();
}

class _PesananScreenState extends State<PesananScreen> {
  // DATA MASTER PESANAN
  final List<Map<String, dynamic>> _ongoingOrders = [
    {
      'title': 'Animal Farm',
      'author': 'oleh George Orwell',
      'price': 'Rp 47.000',
      'status': 'Sedang Diproses',
      'statusColor': const Color(0xFFC76E2E),
      'image': 'assets/animal_farm.png',
    },
    {
      'title': 'The Midnight Library',
      'author': 'oleh Matt Haig',
      'price': 'Rp 76.000',
      'status': 'Sedang Dikirim',
      'statusColor': const Color(0xFFC76E2E),
      'image': 'assets/midnight_library.png',
    },
  ];

  final List<Map<String, dynamic>> _completedOrders = [
    {
      'title': 'Laut Bercerita',
      'author': 'oleh Leila S. Chudori',
      'price': 'Rp 58.000',
      'date': '25 Sep 2025',
      'image': 'assets/laut_bercerita.png',
    },
  ];

  final List<Map<String, dynamic>> _cancelledOrders = [
    {
      'title': 'Hukum Perdata Internasional',
      'author': 'oleh Dr. Ronald Saija',
      'price': 'Rp 58.000',
      'date': '15 Jan 2025',
      'image': 'assets/hukum_perdata.png',
    },
  ];

  void _bukaUlasanBottomSheet(String title, String author, String image) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _LokalUlasanBottomSheet(
        bookTitle: title,
        bookAuthor: author,
        bookImage: image,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        backgroundColor: const Color(0xFFFFFDF2),
        appBar: AppBar(
          backgroundColor: const Color(0xFFFFFDF2),
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Center(
            child: Text(
              'Pesanan Saya',
              style: GoogleFonts.montserrat(
                color: const Color(0xFF42210B),
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ),
          bottom: TabBar(
            indicatorColor: const Color(0xFFC76E2E),
            labelColor: const Color(0xFF42210B),
            unselectedLabelColor: const Color(0xFF8C8C8C),
            labelStyle: GoogleFonts.montserrat(
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
            unselectedLabelStyle: GoogleFonts.montserrat(
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
            tabs: const [
              Tab(text: 'Berlangsung'),
              Tab(text: 'Selesai'),
              Tab(text: 'Dibatalkan'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildBerlangsungTab(),
            _buildSelesaiTab(),
            _buildDibatalkanTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildBerlangsungTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(20.0),
      itemCount: _ongoingOrders.length,
      itemBuilder: (context, index) {
        final item = _ongoingOrders[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 15),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 6),
            ],
          ),
          child: Row(
            children: [
              _buildBookCover(item['image']),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['title'],
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      item['author'],
                      style: GoogleFonts.montserrat(
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item['price'],
                      style: GoogleFonts.montserrat(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: (item['statusColor'] as Color).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        item['status'],
                        style: GoogleFonts.montserrat(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: item['statusColor'],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSelesaiTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(20.0),
      itemCount: _completedOrders.length,
      itemBuilder: (context, index) {
        final item = _completedOrders[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 15),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 6),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  _buildBookCover(item['image']),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item['title'],
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              item['date'],
                              style: GoogleFonts.montserrat(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          item['author'],
                          style: GoogleFonts.montserrat(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item['price'],
                          style: GoogleFonts.montserrat(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(color: Color(0xFFEFEFEF)),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFD3C2B5)),
                    ),
                    child: const Text(
                      'Beli Lagi',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => _bukaUlasanBottomSheet(
                      item['title'],
                      item['author'],
                      item['image'],
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A352F),
                    ),
                    child: const Text(
                      'Beri Ulasan',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDibatalkanTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(20.0),
      itemCount: _cancelledOrders.length,
      itemBuilder: (context, index) {
        final item = _cancelledOrders[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 15),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 6),
            ],
          ),
          child: Row(
            children: [
              _buildBookCover(item['image']),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['title'],
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      item['author'],
                      style: GoogleFonts.montserrat(
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item['price'],
                      style: GoogleFonts.montserrat(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBookCover(String imagePath) {
    return Container(
      width: 65,
      height: 90,
      decoration: BoxDecoration(
        color: const Color(0xFFF5EFE6),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder: (c, e, s) =>
              const Icon(Icons.book, color: Color(0xFF4A352F)),
        ),
      ),
    );
  }
}

class _LokalUlasanBottomSheet extends StatefulWidget {
  final String bookTitle;
  final String bookAuthor;
  final String bookImage;
  const _LokalUlasanBottomSheet({
    Key? key,
    required this.bookTitle,
    required this.bookAuthor,
    required this.bookImage,
  }) : super(key: key);

  @override
  State<_LokalUlasanBottomSheet> createState() =>
      _LokalUlasanBottomSheetState();
}

class _LokalUlasanBottomSheetState extends State<_LokalUlasanBottomSheet> {
  int _rating = 0;
  bool _isSubmitted = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: _isSubmitted ? _buildSuccessState() : _buildInputState(),
    );
  }

  Widget _buildInputState() {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Beri Ulasan',
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            widget.bookTitle,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return IconButton(
                onPressed: () => setState(() => _rating = index + 1),
                icon: Icon(
                  index < _rating
                      ? Icons.star_rounded
                      : Icons.star_outline_rounded,
                  color: const Color(0xFFC76E2E),
                  size: 35,
                ),
              );
            }),
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _rating == 0
                  ? null
                  : () => setState(() => _isSubmitted = true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A352F),
              ),
              child: const Text(
                'Kirim Ulasan',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessState() {
    return Padding(
      padding: const EdgeInsets.all(35.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle, size: 70, color: Color(0xFF4A352F)),
          const SizedBox(height: 15),
          Text(
            'Ulasan Terkirim!',
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A352F),
              ),
              child: const Text(
                'Kembali',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
