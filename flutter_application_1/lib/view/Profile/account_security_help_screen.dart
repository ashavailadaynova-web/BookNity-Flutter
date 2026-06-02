import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AccountSecurityHelpScreen extends StatelessWidget {
  const AccountSecurityHelpScreen({super.key});

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
          "Keamanan Akun",
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: primaryTextColor),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildHelpHeader(
            Icons.gpp_good_rounded,
            "Proteksi & Kredensial",
            "Solusi penanganan akun saat terindikasi diakses tanpa izin, pemulihan verifikasi dua langkah, atau reset nomor hp.",
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
                  "Saya merasa ada aktivitas login asing di akun saya?",
                  "Segera masuk ke menu 'Ubah Kata Sandi' untuk memperbarui password Anda. Laporkan juga ke CS Booknity melalui e-mail bantuan jika Anda mendapati saldo/informasi berubah.",
                ),
                const Divider(color: Color(0xFFE0E0E0), height: 1, indent: 20, endIndent: 20),
                _buildFaqItem(
                  "Mengapa akun saya dibekukan secara sepihak?",
                  "Sistem kami mendeteksi indikasi pelanggaran aturan komunitas, seperti melakukan manipulasi ulasan palsu, transaksi fiktif, atau kata-kata kasar berulang di ruang obrolan.",
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