import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'edit_profile_screen.dart'; 
import '../../widgets/product_card.dart'; // Import template kartu produk baru

// IMPORT HALAMAN BARU YANG SUDAH DIBUAT
import 'help_center_screen.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFFFFFAF2);
    const primaryTextColor = Color(0xFF3E2723); 
    const accentColor = Color(0xFFFF7043); 
    const badgeCream = Color(0xFFF5EBE0);
    const badgePink = Color(0xFFFDE2E4);
    const badgeYellow = Color(0xFFFFF1C5);

    final List<String> myGenres = ["Horror", "Mystery"];

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 20),
              
              Text(
                "Profil Saya",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryTextColor,
                ),
              ),
              
              const SizedBox(height: 24),
              
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                        image: const DecorationImage(
                          image: NetworkImage('https://i.imgur.com/8QjU0rU.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              
              Text(
                "Daynova Shava",
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: primaryTextColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Bergabung sejak 2023",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),

              const SizedBox(height: 20),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildFollowStat("1.2k", "PENGIKUT"),
                  const SizedBox(width: 40),
                  _buildFollowStat("842", "MENGIKUTI"),
                ],
              ),

              const SizedBox(height: 24),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(
                      "Edit Profile",
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(child: _buildInfoCapsule(badgeCream, const Color(0xFF8D6E63), Icons.menu_book_rounded, "10", "TERJUAL")),
                    const SizedBox(width: 12),
                    Expanded(child: _buildInfoCapsule(badgePink, const Color(0xFFD81B60), Icons.local_fire_department_rounded, "10", "MEMBELI")),
                    const SizedBox(width: 12),
                    Expanded(child: _buildInfoCapsule(badgeYellow, const Color(0xFFF57F17), Icons.stars_rounded, "4.8", "PENILAIAN")),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              
              // BIO CARD
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "BIO",
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF8D6E63),
                              letterSpacing: 1.5,
                            ),
                          ),
                          Icon(Icons.format_quote_rounded, color: Colors.grey[200], size: 36),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Lover of gothic horror and vintage hardcovers. Usually found in a sun-drenched corner with a cup of oolong and a thick novel.",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          height: 1.5,
                          color: Colors.grey[700],
                        ),
                      ),
                      
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Divider(color: Color(0xFFF5EBE0), thickness: 1),
                      ),
                      Text(
                        "FAVORITE GENRES",
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF8D6E63),
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 4.0,
                        children: myGenres.map((genre) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF1C5),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              genre,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: primaryTextColor,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // SECTION PRODUK AKTIF
              const ProductSection(
                title: "Produk Saya",
                isSoldOutSection: false,
              ),

              const SizedBox(height: 28),

              // SECTION PRODUK TERJUAL
              const ProductSection(
                title: "Produk Terjual",
                isSoldOutSection: true,
              ),
              
              const SizedBox(height: 32),

              // MENU NAVIGASI TAMBAHAN (REVISI: JARAK RENGGANG & SUDAH TERHUBUNG)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Column(
                    children: [
                      _buildMenuItem(
                        icon: Icons.favorite_rounded,
                        iconColor: const Color(0xFFFF7043),
                        title: "Wishlist Saya",
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Membuka Wishlist Saya...')),
                          );
                        },
                      ),
                      const Divider(color: Color(0xFFF5EBE0), height: 8, indent: 64),
                      _buildMenuItem(
                        icon: Icons.help_center_rounded,
                        iconColor: const Color(0xFF8D6E63),
                        title: "Pusat Bantuan",
                        onTap: () {
                          // NAVIGASI KE PUSAT BANTUAN
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const HelpCenterScreen()),
                          );
                        },
                      ),
                      const Divider(color: Color(0xFFF5EBE0), height: 8, indent: 64),
                      _buildMenuItem(
                        icon: Icons.settings_rounded,
                        iconColor: Colors.grey[600]!,
                        title: "Pengaturan Akun",
                        onTap: () {
                          // NAVIGASI KE PENGATURAN AKUN
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SettingsScreen()),
                          );
                        },
                      ),
                      const Divider(color: Color(0xFFF5EBE0), height: 8, indent: 64),
                      _buildMenuItem(
                        icon: Icons.logout_rounded,
                        iconColor: const Color(0xFFB13D14),
                        title: "Keluar Akun",
                        textColor: const Color(0xFFB13D14),
                        onTap: () {
                          // Alur logout langsung tanpa konfirmasi pop-up
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Berhasil keluar akun')),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 120), 
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFollowStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF3E2723)),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: const Color(0xFFC77A62), letterSpacing: 0.5),
        ),
      ],
    );
  }

  Widget _buildInfoCapsule(Color bgColor, Color iconColor, IconData icon, String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF3E2723)),
          ),
          Text(
            label,
            style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    Color textColor = const Color(0xFF3E2723),
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.08),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor, size: 24),
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: Colors.grey[400],
        size: 24,
      ),
    );
  }
}

class ProductSection extends StatelessWidget {
  final String title;
  final bool isSoldOutSection;

  const ProductSection({
    super.key,
    required this.title,
    required this.isSoldOutSection,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 18, 
                  fontWeight: FontWeight.bold, 
                  color: const Color(0xFF3E2723),
                ),
              ),
              Text(
                "Lihat Semua",
                style: GoogleFonts.poppins(
                  fontSize: 13, 
                  fontWeight: FontWeight.w600, 
                  color: const Color(0xFFFF7043),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(left: 24, right: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: isSoldOutSection
                ? [
                    ProductCard(
                      imageUrl: 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?q=80&w=1000', 
                      bookTitle: "Seharian Bareng Bestie",
                      author: "Hiradini Rahmah & Arie",
                      price: "Rp 33.000",
                      rating: "4.5",
                      isSoldOut: true,
                      onEditPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Edit buku: Seharian Bareng Bestie')),
                        );
                      },
                    ),
                  ]
                : [
                    ProductCard(
                      imageUrl: 'https://images.unsplash.com/photo-1543002588-bfa74002ed7e?q=80&w=1000', 
                      bookTitle: "Cape Deh!",
                      author: "Tere Liye",
                      price: "Rp 33.000",
                      rating: "4.7",
                      onEditPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Edit buku: Cape Deh!')),
                        );
                      },
                    ),
                    const SizedBox(width: 16),
                    _buildEmptyCard(),
                  ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyCard() {
    return Container(
      width: 200,
      height: 382, 
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.withOpacity(0.3), style: BorderStyle.solid),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            "Tambah Buku +",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[600], fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}