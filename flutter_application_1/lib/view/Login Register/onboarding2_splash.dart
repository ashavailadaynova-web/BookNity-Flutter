import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingScreen2 extends StatelessWidget {
  const OnboardingScreen2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Color(0xFFFFFDF2), Color(0xFFFDEEDC)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 30.0,
              vertical: 50.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Discover',
                  style: GoogleFonts.montserrat(
                    fontSize: 56,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF42210B),
                    height: 1.0,
                  ),
                ),
                Text(
                  'Your Next',
                  style: GoogleFonts.montserrat(
                    fontSize: 56,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFFB02E6E),
                    height: 1.0,
                  ),
                ),
                Text(
                  'Read',
                  style: GoogleFonts.montserrat(
                    fontSize: 56,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF42210B),
                    height: 1.0,
                  ),
                ),
                const SizedBox(height: 40),
                _buildChip(
                  Icons.search,
                  'SELF IMPROVEMENT BOOK',
                  const Color(0xFFE88C24),
                  Colors.white,
                ),
                const SizedBox(height: 15),
                _buildChip(
                  Icons.favorite_border,
                  'NOVEL REMAJA',
                  Colors.white,
                  const Color(0xFF9151B0),
                  hasBorder: true,
                ),
                const SizedBox(height: 15),
                _buildChip(
                  Icons.eco,
                  'TUTORIAL CODING',
                  const Color(0xFFFDEEDC),
                  const Color(0xFF42210B),
                  hasBorder: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChip(
    IconData icon,
    String label,
    Color bg,
    Color text, {
    bool hasBorder = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(30),
        border: hasBorder
            ? Border.all(color: text.withOpacity(0.3), width: 1.5)
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: text, size: 20),
          const SizedBox(width: 10),
          Text(
            label,
            style: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: text,
            ),
          ),
        ],
      ),
    );
  }
}
