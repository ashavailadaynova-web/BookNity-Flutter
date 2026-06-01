import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingScreen3 extends StatelessWidget {
  const OnboardingScreen3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFCEBEC), Color(0xFFFCD399)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Buy and Sell.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.dancingScript(
                    fontSize: 44,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFB02E6E),
                  ),
                ),
                const SizedBox(height: 16),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: GoogleFonts.montserrat(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF6B4E37),
                      height: 1.5,
                    ),
                    children: [
                      const TextSpan(
                        text: 'Your reading list, reimagined as a\n',
                      ),
                      TextSpan(
                        text: 'dreamy',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF42210B),
                        ),
                      ),
                      const TextSpan(text: ' digital archive of\nsunshine.'),
                    ],
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
