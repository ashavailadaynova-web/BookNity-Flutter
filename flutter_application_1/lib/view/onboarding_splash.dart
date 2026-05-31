import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Color(0xFFFFFDF2), Color(0xFFFDEEDC)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Booknity.',
                  style: GoogleFonts.dancingScript(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF42210B),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'CURATED',
                  style: GoogleFonts.montserrat(
                    fontSize: 56,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF42210B),
                    height: 1.1,
                  ),
                ),
                Text(
                  'FOR YOU',
                  style: GoogleFonts.montserrat(
                    fontSize: 56,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFFA15D1C),
                    height: 1.1,
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
