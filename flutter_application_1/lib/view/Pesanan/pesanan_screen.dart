import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart'; // 👈 TAMBAHAN: Diperlukan untuk membaca Provider
import '../../viewmodel/pesanan_view_model.dart';

class PesananScreen extends StatefulWidget {
  const PesananScreen({super.key}); // 👈 REVISI: Menggunakan format super.key modern

  @override
  State<PesananScreen> createState() => _PesananScreenState();
}

class _PesananScreenState extends State<PesananScreen> {
  // 👈 REVISI: Menggunakan Provider.of agar state management terbaca sempurna
  late PesananViewModel _pesananController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _pesananController = Provider.of<PesananViewModel>(context);
  }

  void _bukaUlasanBottomSheet(String title, String author, String image) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _LokalUlasanBottomSheet(
        bookTitle: title,
        bookAuthor: author,
        bookImage: image,
        controller: _pesananController,
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
      itemCount: _pesananController.ongoingOrders.length,
      itemBuilder: (context, index) {
        final item = _pesananController.ongoingOrders[index];
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
              _buildBookCover(item['image'] ?? ''),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['title'] ?? '',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      item['author'] ?? '',
                      style: GoogleFonts.montserrat(
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item['price'] ?? '',
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
                        color: ((item['statusColor'] ?? Colors.orange) as Color).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        item['status'] ?? '',
                        style: GoogleFonts.montserrat(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: (item['statusColor'] ?? Colors.orange) as Color,
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
      itemCount: _pesananController.completedOrders.length,
      itemBuilder: (context, index) {
        final item = _pesananController.completedOrders[index];
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
                  _buildBookCover(item['image'] ?? ''),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item['title'] ?? '',
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              item['date'] ?? '',
                              style: GoogleFonts.montserrat(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          item['author'] ?? '',
                          style: GoogleFonts.montserrat(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item['price'] ?? '',
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
                      item['title'] ?? '',
                      item['author'] ?? '',
                      item['image'] ?? '',
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
      itemCount: _pesananController.cancelledOrders.length,
      itemBuilder: (context, index) {
        final item = _pesananController.cancelledOrders[index];
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
              _buildBookCover(item['image'] ?? ''),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['title'] ?? '',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      item['author'] ?? '',
                      style: GoogleFonts.montserrat(
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item['price'] ?? '',
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
  final PesananViewModel controller;

  const _LokalUlasanBottomSheet({
    super.key, // 👈 REVISI: Menggunakan format super.key modern
    required this.bookTitle,
    required this.bookAuthor,
    required this.bookImage,
    required this.controller, 
  });

  @override
  State<_LokalUlasanBottomSheet> createState() =>
      _LokalUlasanBottomSheetState();
}

class _LokalUlasanBottomSheetState extends State<_LokalUlasanBottomSheet> {
  int _rating = 0;
  bool _isSubmitted = false;
  final TextEditingController _deskripsiController = TextEditingController();
  bool _fotoDitambahkan = false;

  @override
  void dispose() {
    _deskripsiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (_, controller) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFFFFFDF2),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: _isSubmitted
              ? _buildSuccessState()
              : _buildInputState(controller),
        );
      },
    );
  }

  Widget _buildInputState(ScrollController scrollController) {
    bool isButtonEnabled = _rating > 0;

    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
      children: [
        Center(
          child: Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: Text(
            'Beri Ulasan',
            style: GoogleFonts.montserrat(
              color: const Color(0xFF42210B),
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(height: 25),
        Center(
          child: Container(
            width: 130,
            height: 180,
            decoration: BoxDecoration(
              color: const Color(0xFFF5EFE6),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                widget.bookImage,
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) =>
                    const Icon(Icons.book, size: 50, color: Color(0xFF4A352F)),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Text(
            widget.bookTitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: const Color(0xFF42210B),
            ),
          ),
        ),
        Center(
          child: Text(
            widget.bookAuthor,
            style: GoogleFonts.montserrat(
              fontSize: 13,
              color: const Color(0xFF8C8C8C),
            ),
          ),
        ),
        const SizedBox(height: 25),
        Center(
          child: Text(
            'APA PENDAPATMU TENTANG PRODUK INI?',
            style: GoogleFonts.montserrat(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF8C8C8C),
              letterSpacing: 0.5,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _rating = index + 1;
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Icon(
                  index < _rating
                      ? Icons.star_rounded
                      : Icons.star_outline_rounded,
                  color: const Color(0xFFC76E2E),
                  size: 38,
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 25),
        Text(
          'TAMBAHKAN FOTO',
          style: GoogleFonts.montserrat(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF8C8C8C),
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            setState(() {
              _fotoDitambahkan = !_fotoDitambahkan;
            });
          },
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: const Color(0xFFEFECE1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFD3C2B5), width: 1),
              ),
              child: _fotoDitambahkan
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(widget.bookImage, fit: BoxFit.cover),
                    )
                  : const Icon(
                      Icons.add_photo_alternate_outlined,
                      color: Color(0xFF8C8C8C),
                    ),
            ),
          ),
        ),
        const SizedBox(height: 25),
        Text(
          'BERIKAN DESKRIPSI',
          style: GoogleFonts.montserrat(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF8C8C8C),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _deskripsiController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText:
                'Apa ulasanmu mengenai buku ini? Berikan pendapat yang jujur ya serta rasional',
            hintStyle: GoogleFonts.montserrat(
              fontSize: 12,
              color: const Color(0xFFA8A8A8),
            ),
            filled: true,
            fillColor: const Color(0xFFEFECE1),
            contentPadding: const EdgeInsets.all(12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
          style: GoogleFonts.montserrat(
            fontSize: 13,
            color: const Color(0xFF42210B),
          ),
        ),
        const SizedBox(height: 35),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: isButtonEnabled
                ? () {
                    // 👈 Panggil fungsi database dari viewmodel
                    widget.controller.kirimUlasanKeDatabase(
                      judulBuku: widget.bookTitle,
                      rating: _rating,
                      deskripsi: _deskripsiController.text,
                      denganFoto: _fotoDitambahkan,
                    );

                    setState(() {
                      _isSubmitted = true;
                    });
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF261206),
              disabledBackgroundColor: const Color(0xFF261206).withOpacity(0.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: Text(
              'Kirim Ulasan',
              style: GoogleFonts.montserrat(
                color: isButtonEnabled
                    ? Colors.white
                    : Colors.white.withOpacity(0.6),
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessState() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFF7A4B31),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, size: 50, color: Color(0xFFFFFDF2)),
          ),
          const SizedBox(height: 25),
          Text(
            'Ulasan Terkirim!',
            style: GoogleFonts.montserrat(
              color: const Color(0xFF42210B),
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Terima kasih telah membagikan\npendapatmu tentang produk ini.',
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              color: const Color(0xFF8C8C8C),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 35),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF261206),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: Text(
                'Kembali Ke Beranda',
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}