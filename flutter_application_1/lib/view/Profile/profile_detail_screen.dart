import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/user_viewmodel.dart';

class ProfileDetailScreen extends StatelessWidget {
  const ProfileDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryTextColor = Color(0xFF3E2723);
    const accentColor = Color(0xFFFF7043);
    final softGrey = Colors.grey[50]!;
    final dividerColor = Colors.grey[200]!;
    final user =
           context.watch<UserViewModel>().currentUser;
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
          "Detail Data Diri",
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: primaryTextColor),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // KELOMPOK 1: INFORMASI IDENTITAS UTAMA
            _buildGroupTitle("INFORMASI IDENTITAS"),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: softGrey,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: dividerColor, width: 1),
              ),
              child: Column(
                children: [
                  _buildImportantDataTile(
                    label: "Nama Lengkap sesuai KTP",
                    value: user?.name ?? "-",
                    icon: Icons.badge_outlined,
                  ),
                  Divider(color: dividerColor, height: 1, indent: 64),
                  _buildImportantDataTile(
                    label: "Username",
                   value: user?.username.isNotEmpty == true
                    ? "@${user!.username}"
                    : "-",
                    icon: Icons.alternate_email_rounded,
                  ),
                  Divider(color: dividerColor, height: 1, indent: 64),
                  _buildImportantDataTile(
                    label: "Status Akun",
                    value: "Terverifikasi (Penjual & Pembeli)",
                    icon: Icons.verified_user_outlined,
                    valueColor: Colors.green[700],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // KELOMPOK 2: KONTAK & KEAMANAN
            _buildGroupTitle("KONTAK & KEAMANAN"),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: softGrey,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: dividerColor, width: 1),
              ),
              child: Column(
                children: [
                  _buildImportantDataTile(
                    label: "Alamat Email",
                    value: user?.email ?? "-",
                    icon: Icons.email_outlined,
                    trailing: const Icon(Icons.check_circle, color: Colors.green, size: 18),
                  ),
                  Divider(color: dividerColor, height: 1, indent: 64),
                  _buildImportantDataTile(
                    label: "Nomor Telepon / WhatsApp",
                    value: "Belum ditambahkan",
                    icon: Icons.phone_android_rounded,
                    trailing: const Icon(Icons.check_circle, color: Colors.green, size: 18),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // PEMBERITAHUAN KEAMANAN DATA
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.gpp_good_rounded, color: accentColor, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Data diri penting Anda dilindungi dengan enkripsi ketat demi keamanan transaksi di Booknity.",
                      style: GoogleFonts.poppins(fontSize: 12, color: primaryTextColor, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF8D6E63),
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildImportantDataTile({
    required String label,
    required String value,
    required IconData icon,
    Color? valueColor,
    Widget? trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF3E2723).withOpacity(0.06),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF3E2723), size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[500], fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: valueColor ?? const Color(0xFF3E2723),
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }
}