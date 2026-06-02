import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// 1. IMPORT SEMUA HALAMAN SUB-PENGATURAN
import 'profile_detail_screen.dart';
import 'change_password_screen.dart';
import 'address_list_screen.dart';
import 'privacy_policy_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isNotificationEnabled = true;
  bool _isDarkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Colors.white;
    const primaryTextColor = Color(0xFF3E2723);
    const accentColor = Color(0xFFFF7043);
    final softGrey = Colors.grey[50]!; 

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
          "Pengaturan Akun",
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
            // Kategori 1: Akun Saya
            _buildSectionTitle("AKUN SAYA"),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: softGrey, 
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: Colors.grey[200]!, width: 1),
              ),
              child: Column(
                children: [
                  _buildSettingTile(
                    icon: Icons.person_outline_rounded,
                    title: "Detail Data Diri",
                    onTap: () {
                      // NAVIGASI KE DETAIL DATA DIRI
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ProfileDetailScreen()),
                      );
                    },
                  ),
                  const Divider(color: Color(0xFFE0E0E0), height: 1, indent: 64),
                  _buildSettingTile(
                    icon: Icons.shield_outlined,
                    title: "Ubah Kata Sandi",
                    onTap: () {
                      // NAVIGASI KE UBAH KATA SANDI
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),
                      );
                    },
                  ),
                  const Divider(color: Color(0xFFE0E0E0), height: 1, indent: 64),
                  _buildSettingTile(
                    icon: Icons.location_on_outlined,
                    title: "Daftar Alamat Pengiriman",
                    onTap: () {
                      // NAVIGASI KE DAFTAR ALAMAT
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AddressListScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Kategori 2: Preferensi Sistem
            _buildSectionTitle("PREFERENSI APLIKASI"),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: softGrey, 
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: Colors.grey[200]!, width: 1),
              ),
              child: Column(
                children: [
                  _buildSettingSwitchTile(
                    icon: Icons.notifications_none_rounded,
                    title: "Notifikasi Aplikasi",
                    value: _isNotificationEnabled,
                    onChanged: (val) {
                      setState(() {
                        _isNotificationEnabled = val;
                      });
                    },
                  ),
                  const Divider(color: Color(0xFFE0E0E0), height: 1, indent: 64),
                  _buildSettingSwitchTile(
                    icon: Icons.dark_mode_outlined,
                    title: "Mode Gelap (Beta)",
                    value: _isDarkModeEnabled,
                    onChanged: (val) {
                      setState(() {
                        _isDarkModeEnabled = val;
                      });
                    },
                  ),
                  const Divider(color: Color(0xFFE0E0E0), height: 1, indent: 64),
                  _buildSettingTile(
                    icon: Icons.privacy_tip_outlined,
                    title: "Kebijakan Privasi",
                    onTap: () {
                      // NAVIGASI KE KEBIJAKAN PRIVASI
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()),
                      );
                    },
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

  Widget _buildSectionTitle(String title) {
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

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap, // Memastikan onTap diteruskan ke ListTile bawaan Flutter agar bisa ditekan
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: const Color(0xFF3E2723).withOpacity(0.06), shape: BoxShape.circle),
        child: Icon(icon, color: const Color(0xFF3E2723), size: 24),
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600, color: const Color(0xFF3E2723)),
      ),
      trailing: Icon(Icons.chevron_right_rounded, color: Colors.grey[400], size: 24),
    );
  }

  Widget _buildSettingSwitchTile({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: const Color(0xFF3E2723).withOpacity(0.06), shape: BoxShape.circle),
          child: Icon(icon, color: const Color(0xFF3E2723), size: 24),
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600, color: const Color(0xFF3E2723)),
        ),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFFFF7043),
          activeTrackColor: const Color(0xFFFF7043).withOpacity(0.2),
          inactiveThumbColor: Colors.grey[300],
          inactiveTrackColor: Colors.grey[100],
        ),
      ),
    );
  }
}