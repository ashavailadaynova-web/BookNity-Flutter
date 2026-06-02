import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryTextColor = Color(0xFF3E2723);
    const accentColor = Color(0xFFFF7043);
    final softGrey = Colors.grey[100]!;

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
          "Ubah Kata Sandi",
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: primaryTextColor),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildPasswordField("Kata Sandi Sekarang", softGrey),
            _buildPasswordField("Kata Sandi Baru", softGrey),
            _buildPasswordField("Konfirmasi Kata Sandi Baru", softGrey),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  elevation: 0,
                ),
                child: Text(
                  "Perbarui Kata Sandi",
                  style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // REVISI BERHASIL: Menggunakan EdgeInsets.only(bottom: 20)
  Widget _buildPasswordField(String label, Color fillColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFF8D6E63)),
          ),
          const SizedBox(height: 8),
          TextFormField(
            obscureText: true,
            decoration: InputDecoration(
              filled: true,
              fillColor: fillColor,
              suffixIcon: Icon(Icons.visibility_off_outlined, color: Colors.grey[400]),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            ),
          ),
        ],
      ),
    );
  }
}