import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'shipping_help_screen.dart';
import 'payment_help_screen.dart';
import 'book_condition_help_screen.dart';
import 'account_security_help_screen.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Colors.white;
    const primaryTextColor = Color(0xFF3E2723);
    const accentColor = Color(0xFFFF7043);
    final softGrey = Colors.grey[100]!; 

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: primaryTextColor, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Pusat Bantuan",
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: primaryTextColor),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Ada yang bisa kami bantu?",
              style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: primaryTextColor),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                hintText: "Cari masalah atau pertanyaan...",
                hintStyle: GoogleFonts.poppins(color: Colors.grey[400], fontSize: 14),
                prefixIcon: const Icon(Icons.search_rounded, color: accentColor),
                filled: true,
                fillColor: softGrey, 
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 28),
            Text(
              "Kategori Masalah",
              style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: primaryTextColor),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.3,
              children: [
                _buildCategoryCard(Icons.local_shipping_rounded, "Pengiriman", const Color(0xFFFF7043), softGrey, () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ShippingHelpScreen()));
                }),
                _buildCategoryCard(Icons.account_balance_wallet_rounded, "Pembayaran", const Color(0xFF8D6E63), softGrey, () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const PaymentHelpScreen()));
                }),
                _buildCategoryCard(Icons.menu_book_rounded, "Kondisi Buku", const Color(0xFFF57F17), softGrey, () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const BookConditionHelpScreen()));
                }),
                _buildCategoryCard(Icons.gpp_good_rounded, "Keamanan Akun", const Color(0xFFD81B60), softGrey, () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AccountSecurityHelpScreen()));
                }),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              "Pertanyaan Populer (FAQ)",
              style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: primaryTextColor),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: softGrey, 
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  _buildFaqTile(
                    "Bagaimana cara menjual buku bekas di Booknity?",
                    "Anda hanya perlu menekan tombol tambah produk di halaman utama atau halaman profil, lalu masukkan detail buku, foto kondisi asli, serta harga yang Anda inginkan.",
                  ),
                  const Divider(color: Color(0xFFE0E0E0), height: 1, indent: 20, endIndent: 20),
                  _buildFaqTile(
                    "Apakah uang saya aman jika transaksi dibatalkan?",
                    "Tentu saja. Booknity menjamin keamanan dana Anda. Jika penjual membatalkan pesanan atau tidak mengirimkan buku, dana akan otomatis dikembalikan 100% ke saldo akun Anda.",
                  ),
                  const Divider(color: Color(0xFFE0E0E0), height: 1, indent: 20, endIndent: 20),
                  _buildFaqTile(
                    "Berapa lama batas waktu pengiriman oleh penjual?",
                    "Penjual diberikan waktu maksimal 2x24 jam (tidak termasuk hari libur nasional) untuk menyerahkan paket buku ke jasa ekspedisi setelah pembayaran Anda terverifikasi.",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text(
              "Masih butuh bantuan lain?",
              style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: primaryTextColor),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: accentColor.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(color: accentColor, shape: BoxShape.circle),
                    child: const Icon(Icons.support_agent_rounded, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hubungi Customer Service",
                          style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: primaryTextColor),
                        ),
                        Text(
                          "Kami siap melayani Anda 24/7",
                          style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                    child: Text(
                      "Chat",
                      style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: Column(
                children: [
                  Text(
                    "Apakah halaman ini membantu?",
                    style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.grey[500]),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    // REVISI DI SINI: Sudah diperbaiki menjadi sintaks yang benar
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.thumb_up_outlined, size: 16, color: primaryTextColor),
                        label: Text("Ya", style: GoogleFonts.poppins(color: primaryTextColor, fontSize: 13)),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.grey[300]!),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.thumb_down_alt_outlined, size: 16, color: primaryTextColor),
                        label: Text("Tidak", style: GoogleFonts.poppins(color: primaryTextColor, fontSize: 13)),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.grey[300]!),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ],
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

  Widget _buildCategoryCard(IconData icon, String title, Color color, Color cardBg, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        color: cardBg, 
        borderRadius: BorderRadius.circular(24),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onTap, 
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF3E2723)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFaqTile(String question, String answer) {
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
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          child: Text(
            answer,
            style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[700], height: 1.5),
          ),
        )
      ],
    );
  }
}