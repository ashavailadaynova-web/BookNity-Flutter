import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ShippingHelpScreen extends StatelessWidget {
  const ShippingHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryTextColor = Color(0xFF3E2723);
    final softGrey = Colors.grey[50]!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: primaryTextColor, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Bantuan Pengiriman",
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: primaryTextColor),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildHelpHeader(
            Icons.local_shipping_rounded,
            "Masalah Pengiriman",
            "Temukan solusi terkait pelacakan resi, durasi pengantaran, atau kendala ekspedisi mitra Booknity.",
          ),
          const SizedBox(height: 24),
          Container(
            decoration: BoxDecoration(
              color: softGrey,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              children: [
                _buildFaqItem(
                  "Mengapa nomor resi saya tidak bisa melacak posisi paket?",
                  "Sistem kurir membutuhkan waktu hingga 1x24 jam untuk memperbarui status data di database mereka setelah paket diserahkan oleh penjual. Silakan cek kembali secara berkala.",
                ),
                const Divider(color: Color(0xFFE0E0E0), height: 1, indent: 20, endIndent: 20),
                _buildFaqItem(
                  "Apa yang harus dilakukan jika paket buku rusak saat sampai?",
                  "Jangan selesaikan pesanan terlebih dahulu. Ambil foto dan video unboxing secara detail, lalu ajukan komplain melalui tombol 'Ajukan Pengembalian' di halaman detail transaksi.",
                ),
                const Divider(color: Color(0xFFE0E0E0), height: 1, indent: 20, endIndent: 20),
                _buildFaqItem(
                  "Dapatkah saya mengubah alamat pengiriman setelah membayar?",
                  "Mohon maaf, alamat pengiriman yang sudah masuk ke sistem transaksi tidak dapat diubah demi mencegah kesalahan cetak label oleh penjual.",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpHeader(IconData icon, String title, String desc) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: const Color(0xFFFF7043).withOpacity(0.1), shape: BoxShape.circle),
          child: Icon(icon, color: const Color(0xFFFF7043), size: 36),
        ),
        const SizedBox(height: 16),
        Text(
          title,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF3E2723)),
        ),
        const SizedBox(height: 8),
        Text(
          desc,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[600], height: 1.5),
        ),
      ],
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return ExpansionTile(
      shape: const Border(),
      iconColor: const Color(0xFFFF7043),
      collapsedIconColor: Colors.grey[400],
      title: Text(
        question,
        style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF3E2723)),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          child: Text(
            answer,
            style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[700], height: 1.5),
          ),
        )
      ],
    );
  }
}