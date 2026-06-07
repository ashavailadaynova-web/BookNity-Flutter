import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // 👈 Tambah import ini
import 'chat_room_screen.dart';

class OfferScreen extends StatefulWidget {
  // 👈 Ubah ke StatefulWidget agar bisa pakai Controller & State
  final String productId;
  final String title;
  final String author;
  final String imageUrl;
  final double originalPrice;
  final String sellerId;

  const OfferScreen({
    super.key,
    required this.productId,
    required this.title,
    required this.author,
    required this.imageUrl,
    required this.originalPrice,
    required this.sellerId,
  });

  @override
  State<OfferScreen> createState() => _OfferScreenState();
}

class _OfferScreenState extends State<OfferScreen> {
  final TextEditingController _priceController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isButtonEnabled = false;

  // Hitung batas minimal penawaran (Harga Asli - 10%)
  double get minAllowedPrice => widget.originalPrice * 0.9;

  @override
  void initState() {
    super.initState();
    // Berikan hint otomatis berupa harga asli di dalam input (opsional)
    _priceController.addListener(_validateInput);
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  // Validasi real-time saat user mengetik
  void _validateInput() {
    final enteredPrice = double.tryParse(_priceController.text) ?? 0;

    // Tombol Kirim aktif JIKA input tidak kosong DAN harga memenuhi batas minimal
    if (enteredPrice >= minAllowedPrice &&
        enteredPrice <= widget.originalPrice) {
      if (!_isButtonEnabled) setState(() => _isButtonEnabled = true);
    } else {
      if (_isButtonEnabled) setState(() => _isButtonEnabled = false);
    }
  }

  // Fungsi menyimpan data tawar ke Firebase
  Future<void> _submitOfferToFirebase(double offeredPrice) async {
    try {
      await _firestore.collection('offers').add({
        'productId': widget.productId,
        'productTitle': widget.title,
        'sellerId': widget.sellerId,
        'buyerId':
            "ID_USER_SEKARANG", // 👈 Ganti dengan ID user/pembeli yang login (bisa dari FirebaseAuth)
        'originalPrice': widget.originalPrice,
        'offeredPrice': offeredPrice,
        'status': 'pending', // pending, accepted, rejected
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint("Gagal menyimpan penawaran: $e");
    }
  }

  void _showOfferDialog(BuildContext context, double offeredPrice) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          child: Container(
            width: 340,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    color: const Color(0xffF5D5CA),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.payments_outlined,
                    color: Color(0xffB14D28),
                    size: 42,
                  ),
                ),
                const SizedBox(height: 28),
                Text(
                  "Buat Penawaran?",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xff222222),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  "Setelah penjual menerima\npenawaran, Anda dapat saling\nmemberikan ulasan.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    height: 1.8,
                    color: const Color(0xff6B5A55),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 34),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 58,
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: Color(0xffB14D28),
                              width: 1.2,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Text(
                            "Tidak",
                            style: GoogleFonts.plusJakartaSans(
                              color: const Color(0xffB14D28),
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: SizedBox(
                        height: 58,
                        child: ElevatedButton(
                          onPressed: () async {
                            Navigator.pop(context); // Tutup dialog

                            // 1. Simpan ke Firebase Firestore
                            await _submitOfferToFirebase(offeredPrice);

                            // 2. Pindah ke halaman Chat Room
                            if (mounted) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      ChatRoomScreen(sellerId: widget.sellerId),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffB14D28),
                            elevation: 4,
                            shadowColor: Colors.black26,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Text(
                            "Ya",
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F3E8),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              children: [
                const SizedBox(height: 16),
                // HEADER
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Color(0xff4A241B),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          "Penawaran",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xff2D211E),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
                const SizedBox(height: 30),

                // COVER BUKU (Dinamis)
                Container(
                  width: 235,
                  height: 345,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.12),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    image: DecorationImage(
                      image: NetworkImage(widget.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 36),

                // JUDUL BUKU (Dinamis)
                Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xff2D211E),
                  ),
                ),
                const SizedBox(height: 6),

                // PENULIS (Dinamis)
                Text(
                  "oleh ${widget.author}",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    color: const Color(0xff4D3A35),
                  ),
                ),
                const SizedBox(height: 26),

                Text(
                  "Harga",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    color: const Color(0xffD5A07D),
                  ),
                ),
                const SizedBox(height: 4),

                // HARGA ASLI (Dinamis)
                Text(
                  "Rp ${widget.originalPrice.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xff2D211E),
                  ),
                ),
                const SizedBox(height: 36),

                // LABEL INPUT
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Harga Penawaran",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // INPUT PENAWARAN
                Container(
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.08),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 18),
                      Text(
                        "Rp",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xff2D211E),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: _priceController, // 👈 Pasang controller
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: widget.originalPrice.toStringAsFixed(0),
                            border: InputBorder.none,
                            hintStyle: GoogleFonts.plusJakartaSans(
                              fontSize: 22,
                              color: const Color(0xffB88B69),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 26),

                // INFO BOX (Dinamis mengikuti hitungan 10%)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xffF1E7D8),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: Color(0xffC24A28),
                        size: 18,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 15,
                              color: const Color(0xff5E4B44),
                              height: 1.8,
                            ),
                            children: [
                              const TextSpan(
                                text:
                                    "Minimum penawaran yang diizinkan adalah ",
                              ),
                              TextSpan(
                                text:
                                    "Rp ${minAllowedPrice.toStringAsFixed(0)}.",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const TextSpan(
                                text:
                                    "\nPenawaran di bawah jumlah ini tidak dapat diproses atau dikirim.",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 42),

                // BUTTON (Akan terkunci jika input tidak valid)
                SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: ElevatedButton(
                    onPressed: _isButtonEnabled
                        ? () {
                            final double offeredPrice = double.parse(
                              _priceController.text,
                            );
                            _showOfferDialog(context, offeredPrice);
                          }
                        : null, // 👈 Jika null, tombol otomatis ke-disable (berwarna abu-abu & gak bisa diklik)
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffB54429),
                      disabledBackgroundColor:
                          Colors.grey[400], // Warna saat tombol mati
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      "Kirim Penawaran",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
