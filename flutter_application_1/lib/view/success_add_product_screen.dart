import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../main_screen.dart';

class SuccessAddProductScreen extends StatelessWidget {
  const SuccessAddProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFAF8F6),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                /// ICON CHECK
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: const Color(0xffA45A00),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 50,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 32),

                /// TITLE
                Text(
                  "Produk Ditambahkan",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xff33231F),
                  ),
                ),

                const SizedBox(height: 12),

                /// DESCRIPTION
                Text(
                  "Kamu telah berhasil menambahkan\nproduk, produk kamu akan terlihat di profil.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    height: 1.6,
                    color: const Color(0xff6B625F),
                  ),
                ),

                const SizedBox(height: 40),

                /// BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 68,
                  child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MainScreen(
                          selectedIndex: 3,
                        ),
                      ),
                      (route) => false,
                    );
                  },
                    style: ElevatedButton.styleFrom(
                      elevation: 8,
                      backgroundColor: const Color(0xff4A241B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    child: Text(
                      "Lihat di Profil",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}