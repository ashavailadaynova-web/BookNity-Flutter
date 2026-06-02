import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryTextColor = Color(0xFF3E2723);

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
          "Kebijakan Privasi",
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: primaryTextColor),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Kebijakan Privasi Booknity", style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: primaryTextColor)),
            const SizedBox(height: 4),
            Text("Terakhir diperbarui: Juni 2026", style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[500])),
            const SizedBox(height: 24),
            _buildPrivacySection(
              "1. Informasi yang Kami Kumpulkan",
              "Kami mengumpulkan data pribadi yang Anda berikan secara langsung saat mendaftar akun Booknity, termasuk nama lengkap, alamat email, nomor telepon, foto profil, dan rincian alamat pengiriman untuk keperluan transaksi buku bekas.",
            ),
            _buildPrivacySection(
              "2. Penggunaan Informasi",
              "Informasi yang dikumpulkan digunakan untuk memproses transaksi jual-beli, memverifikasi identitas pengguna, mengoptimalkan pengiriman paket oleh kurir, serta memberikan notifikasi berkala mengenai aktivitas akun Anda.",
            ),
            _buildPrivacySection(
              "3. Keamanan Data Anda",
              "Booknity berkomitmen penuh untuk melindungi informasi kredensial Anda. Kami menerapkan enkripsi data berlapis untuk mencegah akses tidak sah, pengubahan, atau kebocoran data pribadi Anda di server kami.",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacySection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: const Color(0xFF3E2723))),
          const SizedBox(height: 8),
          Text(content, style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[600], height: 1.6)),
        ],
      ),
    );
  }
}