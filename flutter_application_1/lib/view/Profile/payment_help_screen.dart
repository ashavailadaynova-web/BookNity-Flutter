import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentHelpScreen extends StatelessWidget {
  const PaymentHelpScreen({super.key});

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
          "Bantuan Pembayaran",
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: primaryTextColor),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildHelpHeader(
            Icons.account_balance_wallet_rounded,
            "Masalah Pembayaran",
            "Panduan lengkap mengenai verifikasi otomatis, metode transfer, e-wallet, dan mekanisme jaminan uang kembali.",
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
                  "Saya sudah transfer tetapi status pesanan belum berubah?",
                  "Verifikasi otomatis via Virtual Account biasanya instan. Namun, jika Anda menggunakan transfer manual, proses pengecekan tim admin memerlukan waktu maksimal 15-30 menit.",
                ),
                const Divider(color: Color(0xFFE0E0E0), height: 1, indent: 20, endIndent: 20),
                _buildFaqItem(
                  "Berapa lama proses pencairan dana refund?",
                  "Untuk pembatalan transaksi, saldo akan langsung dikembalikan ke dompet digital akun Booknity Anda dalam waktu 1x24 jam dan dapat ditarik ke rekening bank pribadi.",
                ),
                const Divider(color: Color(0xFFE0E0E0), height: 1, indent: 20, endIndent: 20),
                _buildFaqItem(
                  "Apakah bisa membayar dengan sistem COD?",
                  "Saat ini Booknity hanya mendukung pembayaran cashless (Transfer Bank, VA, dan E-Wallet) untuk menjamin keamanan transaksi kedua belah pihak.",
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