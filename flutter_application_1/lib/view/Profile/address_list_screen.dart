import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddressListScreen extends StatelessWidget {
  const AddressListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryTextColor = Color(0xFF3E2723);
    const accentColor = Color(0xFFFF7043);
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
          "Alamat Pengiriman",
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: primaryTextColor),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildAddressCard(
            label: "Rumah Utama",
            recipient: "Daynova Shava (081234567890)",
            detail: "Jl. Kalimantan No. 37, Kecamatan Sumbersari, Jember, Jawa Timur, 68121",
            isMain: true,
            cardBg: softGrey,
          ),
          const SizedBox(height: 16),
          _buildAddressCard(
            label: "Kost / Kampus",
            recipient: "Daynova Shava (081234567890)",
            detail: "Fakultas Ilmu Komputer, Universitas Jember, Jawa Timur, 68121",
            isMain: false,
            cardBg: softGrey,
          ),
          const SizedBox(height: 32),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add_rounded, color: accentColor),
            label: Text("Tambah Alamat Baru", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: accentColor)),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: const BorderSide(color: accentColor, width: 1.5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard({
    required String label,
    required String recipient,
    required String detail,
    required bool isMain,
    required Color cardBg,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isMain ? const Color(0xFFFF7043) : Colors.grey[200]!, width: isMain ? 1.5 : 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: const Color(0xFF3E2723))),
              if (isMain)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: const Color(0xFFFF7043).withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                  child: Text("Utama", style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: const Color(0xFFFF7043))),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(recipient, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey[800])),
          const SizedBox(height: 4),
          Text(detail, style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[600], height: 1.4)),
        ],
      ),
    );
  }
}