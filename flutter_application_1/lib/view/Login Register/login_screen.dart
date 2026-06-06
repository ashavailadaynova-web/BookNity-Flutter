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

  // 🟢 FUNGSI RESET PASSWORD YANG SUDAH DIPISAH AGAR TIDAK MERUSAK DIALOG
  Future<void> _handleForgotPassword(String email) async {
    if (email.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Email tidak boleh kosong')));
      return;
    }

    // Tampilkan loading di halaman utama biar dialog aman dari rebuild crash
    // Menggunakan Navigator.pop(context) di awal agar dialog langsung tertutup bersih
    Navigator.pop(context);

    // Panggil fungsi Firebase menggunakan context halaman utama via read
    final authViewModel = context.read<AuthViewModel>();

    // Kita manipulasi loading manual lewat fungsi temporary atau langsung eksekusi
    final success = await authViewModel.forgotPassword(email: email);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF8F4F17),
          content: Text(
            'Email reset telah dikirim! Periksa Inbox/Spam kamu.',
            style: GoogleFonts.montserrat(color: Colors.white),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal mengirim email. Pastikan email terdaftar.'),
        ),
      );
    }
  }

  // 🟢 POPUP DIALOG BERSIH TANPA STATEFULBUILDER (ANTI-CRASH)
  void _openForgotPasswordDialog() {
    final resetEmailController = TextEditingController(
      text: _emailController.text,
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFFFFDF2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Reset Password',
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w700,
              color: const Color(0xFF8F4F17),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Masukkan email terdaftar kamu untuk menerima link reset password.',
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  color: const Color(0xFF6B4E37),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF5EFE6),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextField(
                  controller: resetEmailController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Masukkan Email Address',
                    hintStyle: GoogleFonts.montserrat(
                      color: const Color(0xFFB3A699),
                      fontSize: 13,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Batal',
                style: GoogleFonts.montserrat(color: const Color(0xFF8C8C8C)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final emailInput = resetEmailController.text.trim();
                _handleForgotPassword(emailInput);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB02E6E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 0,
              ),
              child: Text(
                'Kirim Link',
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Memantau state loading global hanya untuk tombol login utama
    final isAppLoading = context.select<AuthViewModel, bool>(
      (vm) => vm.isLoading,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF2),
      body: Stack(
        children: [
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
                  colors: [Color(0xFFFFFDF2), Color(0xFFFCD399)],
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 35.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 260),
                  Text(
                    'Hi, Welcome Back!',
                    style: GoogleFonts.montserrat(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF8F4F17),
                    ),
                  ),
                  const SizedBox(height: 8),
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
                  _buildInputField(
                    label: 'Email',
                    hint: 'Enter Email Address',
                    controller: _emailController,
                  ),
                  const SizedBox(height: 20),
                  _buildInputField(
                    label: 'Password',
                    hint: 'Enter Password',
                    controller: _passwordController,
                    isPassword: true,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _openForgotPasswordDialog,
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
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: isAppLoading
                          ? null
                          : () async {
                              final success = await context
                                  .read<AuthViewModel>()
                                  .login(
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
                        backgroundColor: const Color(0xFF8F4F17),
                        disabledBackgroundColor: const Color(0xFFD9D9D9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      child: isAppLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : Text(
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      isAppLoading
                          ? const SizedBox(
                              width: 50,
                              height: 50,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xFF8F4F17),
                                ),
                              ),
                            )
                          : _buildSocialButton(
                              'assets/google.png',
                              customWidget: Image.asset(
                                'assets/google.png',
                                width: 32,
                                height: 32,
                                fit: BoxFit.contain,
                              ),
                              onTap: () async {
                                final success = await context
                                    .read<AuthViewModel>()
                                    .loginWithGoogle();

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
                                      content: Text(
                                        'Gagal melakukan Login dengan Google',
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                    ],
                  ),
                  const SizedBox(height: 35),
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
                            color: const Color(0xFFB02E6E),
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

  Widget _buildSocialButton(
    String assetPath, {
    IconData? iconData,
    Color? iconColor,
    Widget? customWidget,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFD9D9D9), width: 1),
        ),
        child: Center(
          child:
              customWidget ??
              Icon(iconData ?? Icons.circle, size: 32, color: iconColor),
        ),
      ),
    );
  }
}
