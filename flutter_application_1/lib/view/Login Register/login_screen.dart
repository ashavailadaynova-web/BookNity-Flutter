import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'register_screen.dart';
import '../../main_screen.dart';
import 'package:provider/provider.dart';

import '../../viewmodel/auth_viewmodel.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordHidden = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF2), // Background krem super lembut
      body: Stack(
        children: [
          // 1. Elemen Lingkaran Gradien Besar di Atas
          Positioned(
            top: -250,
            left: -80,
            right: -80,
            child: Container(
              height: 550,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFFFFDF2),
                    Color(0xFFFCD399), // Orange/Kuning hangat meleleh ke bawah
                  ],
                ),
              ),
            ),
          ),

          // 2. Konten Utama Form Login
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 35.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 260,
                  ), // Memberi ruang untuk lingkaran di atas
                  // Judul Selamat Datang
                  Text(
                    'Hi, Welcome Back!',
                    style: GoogleFonts.montserrat(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF8F4F17), // Cokelat ikonik
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Subtitle dengan teks "explore" yang dicetak miring/tebal
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: GoogleFonts.montserrat(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF6B4E37),
                      ),
                      children: [
                        const TextSpan(text: 'Log in to '),
                        TextSpan(
                          text: 'explore',
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const TextSpan(text: ' more books.'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 35),

                  // Input Email
                  _buildInputField(
                    label: 'Email',
                    hint: 'Enter Email Address',
                    controller: _emailController,
                  ),
                  const SizedBox(height: 20),

                  // Input Password
                  _buildInputField(
                    label: 'Password',
                    hint: 'Enter Password',
                    controller: _passwordController,
                    isPassword: true,
                  ),

                  // Tombol Forgot Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        'Forgot Password?',
                        style: GoogleFonts.montserrat(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF8F4F17),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Tombol Log In Utama
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () async {
                        final authViewModel = context.read<AuthViewModel>();

                        final success = await authViewModel.login(
                          email: _emailController.text.trim(),
                          password: _passwordController.text.trim(),
                        );

                        if (!mounted) return;

                        if (success) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const MainScreen(),
                            ),
                            (route) => false,
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Email atau password salah'),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                          0xFF8F4F17,
                        ), // Warna cokelat tua
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Log In',
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Pembatas "Or"
                  Row(
                    children: [
                      const Expanded(
                        child: Divider(
                          color: Color(0xFFD9D9D9),
                          thickness: 1.5,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Text(
                          'Or',
                          style: GoogleFonts.montserrat(
                            color: const Color(0xFF8C8C8C),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Divider(
                          color: Color(0xFFD9D9D9),
                          thickness: 1.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Tombol Media Sosial (Sekarang Hanya Google)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSocialButton(
                        'assets/google.png',
                        isIconData: false,
                        customWidget: const Icon(
                          Icons.g_mobiledata,
                          size: 40,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 35),

                  // Teks Register / Daftar Akun Baru
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have any account? ",
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF6B4E37),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Register',
                          style: GoogleFonts.montserrat(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: const Color(
                              0xFFB02E6E,
                            ), // Warna magenta kontras
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper Widget untuk membuat Input Field (Email & Password)
  Widget _buildInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
          child: Text(
            label,
            style: GoogleFonts.montserrat(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF42210B),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF5EFE6).withOpacity(0.6),
            borderRadius: BorderRadius.circular(30),
          ),
          child: TextField(
            controller: controller,
            obscureText: isPassword ? _isPasswordHidden : false,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.montserrat(
                color: const Color(0xFFB3A699),
                fontSize: 14,
              ),
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        _isPasswordHidden
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordHidden = !_isPasswordHidden;
                        });
                      },
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 16,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  // Helper Widget untuk Tombol Sosial Media
  Widget _buildSocialButton(
    String assetPath, {
    required bool isIconData,
    IconData? iconData,
    Color? iconColor,
    Widget? customWidget,
  }) {
    return Container(
      width: 50,
      height: 50,
      decoration: const BoxDecoration(shape: BoxShape.circle),
      child: Center(
        child:
            customWidget ??
            Icon(iconData ?? Icons.circle, size: 32, color: iconColor),
      ),
    );
  }
}
