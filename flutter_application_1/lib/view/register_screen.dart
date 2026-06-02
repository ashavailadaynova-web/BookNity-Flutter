import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isAgreed = false;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF2), // Background krem lembut
      body: Stack(
        children: [
          // 1. Elemen Lingkaran Gradien di Atas (Posisi menyesuaikan gambar)
          Positioned(
            top: -220,
            right: -100,
            child: Container(
              height: 500,
              width: 500,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFFFFDF2),
                    Color(0xFFFCD399), // Orange hangat
                  ],
                ),
              ),
            ),
          ),

          // 2. Konten Utama
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 35.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 180), // Memberi ruang untuk judul
                  // Judul Halaman
                  Text(
                    'Create Account',
                    style: GoogleFonts.montserrat(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF8F4F17), // Cokelat tua
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Subtitle
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: GoogleFonts.montserrat(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF6B4E37),
                        height: 1.4,
                      ),
                      children: [
                        const TextSpan(
                          text: 'Create your own account for free journey\nto ',
                        ),
                        TextSpan(
                          text: 'explore',
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const TextSpan(text: ' more books you’ll love.'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Input Nama Lengkap
                  _buildInputField(
                    label: 'Full Name',
                    hint: 'Enter Your Full Name',
                    controller: _nameController,
                  ),
                  const SizedBox(height: 20),

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
                  const SizedBox(height: 15),

                  // Checkbox Terms & Conditions
                  Row(
                    children: [
                      SizedBox(
                        height: 24,
                        width: 24,
                        child: Checkbox(
                          value: _isAgreed,
                          activeColor: const Color(0xFF8F4F17),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _isAgreed = value ?? false;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      RichText(
                        text: TextSpan(
                          style: GoogleFonts.montserrat(
                            fontSize: 13,
                            color: const Color(0xFF6B4E37),
                          ),
                          children: [
                            const TextSpan(text: 'I agree to the '),
                            TextSpan(
                              text: 'terms & conditions.',
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Tombol Sign In (Sesuai teks di tombol gambar kamu)
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8F4F17),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Sign In', // Sesuai desain Figma kamu
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

                  // Tombol Media Sosial
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.facebook,
                        size: 32,
                        color: Color(0xFF1877F2),
                      ),
                      const SizedBox(width: 25),
                      const Icon(
                        Icons.g_mobiledata,
                        size: 45,
                        color: Colors.orange,
                      ),
                      const SizedBox(width: 25),
                      const Icon(Icons.apple, size: 32, color: Colors.black),
                    ],
                  ),
                  const SizedBox(height: 40),

                  // Teks Pindah ke Login
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF6B4E37),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context); // Kembali ke halaman Login
                        },
                        child: Text(
                          'Log In',
                          style: GoogleFonts.montserrat(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFB02E6E),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Reusable Input Field
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
            obscureText: isPassword,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.montserrat(
                color: const Color(0xFFB3A699),
                fontSize: 14,
              ),
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
}
