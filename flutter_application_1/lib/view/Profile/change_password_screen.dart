import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState
    extends State<ChangePasswordScreen> {

  final _currentPasswordController =
      TextEditingController();

  final _newPasswordController =
      TextEditingController();

  final _confirmPasswordController =
      TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  Widget build(BuildContext context) {
    const primaryTextColor =
        Color(0xFF3E2723);

    const accentColor =
        Color(0xFFFF7043);

    final softGrey =
        Colors.grey[100]!;

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: primaryTextColor,
            size: 20,
          ),
          onPressed: () =>
              Navigator.pop(context),
        ),

        title: Text(
          "Ubah Kata Sandi",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: primaryTextColor,
          ),
        ),

        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),

        child: Column(
          children: [

            _buildPasswordField(
              "Kata Sandi Sekarang",
              softGrey,
              _currentPasswordController,
              _obscureCurrent,
              () {
                setState(() {
                  _obscureCurrent =
                      !_obscureCurrent;
                });
              },
            ),

           _buildPasswordField(
              "Kata Sandi Baru",
              softGrey,
              _newPasswordController,
              _obscureNew,
              () {
                setState(() {
                  _obscureNew =
                      !_obscureNew;
                });
              },
            ),

          _buildPasswordField(
            "Konfirmasi Kata Sandi Baru",
            softGrey,
            _confirmPasswordController,
            _obscureConfirm,
            () {
              setState(() {
                _obscureConfirm =
                    !_obscureConfirm;
              });
            },
          ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 50,

              child: ElevatedButton(
                onPressed: () async {

                  try {

                    final user =
                        FirebaseAuth
                            .instance
                            .currentUser;

                    if (user == null) {
                      return;
                    }

                    if (_newPasswordController.text.length < 6) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Password minimal 6 karakter",
                        ),
                      ),
                    );

                      return;
                    }

                    if (_currentPasswordController.text ==
                        _newPasswordController.text) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Password baru harus berbeda",
                          ),
                        ),
                      );

                      return;
                    }

                    if (_newPasswordController.text
                            !=
                        _confirmPasswordController
                            .text) {

                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Konfirmasi password tidak cocok",
                          ),
                        ),
                      );

                      return;
                    }

                    final credential =
                        EmailAuthProvider
                            .credential(
                      email:
                          user.email!,
                      password:
                          _currentPasswordController
                              .text,
                    );

                    await user
                        .reauthenticateWithCredential(
                      credential,
                    );

                    await user
                        .updatePassword(
                      _newPasswordController
                          .text,
                    );

                    if (!mounted) {
                      return;
                    }

                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Password berhasil diperbarui",
                        ),
                      ),
                    );

                    Navigator.pop(
                      context,
                    );

                  } catch (e) {

                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Password lama salah",
                        ),
                      ),
                    );
                  }
                },

                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      accentColor,
                  elevation: 0,

                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      25,
                    ),
                  ),
                ),

                child: Text(
                  "Perbarui Kata Sandi",
                  style:
                      GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight:
                        FontWeight.bold,
                    color:
                        Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField(
    String label,
    Color fillColor,
    TextEditingController controller,
    bool obscureText,
     VoidCallback onToggle,
  ) {
    return Padding(
      padding:
          const EdgeInsets.only(
        bottom: 20,
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Text(
            label,
            style:
                GoogleFonts.poppins(
              fontSize: 13,
              fontWeight:
                  FontWeight.bold,
              color:
                  const Color(
                0xFF8D6E63,
              ),
            ),
          ),

          const SizedBox(
            height: 8,
          ),

         TextFormField(
            controller: controller,

            obscureText: obscureText,

            decoration:
                InputDecoration(
              filled: true,
              fillColor:
                  fillColor,

             suffixIcon: IconButton(
              icon: Icon(
                obscureText
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
              ),
              onPressed: onToggle,
            ),

              contentPadding:
                  const EdgeInsets
                      .symmetric(
                horizontal: 20,
                vertical: 16,
              ),

              border:
                  OutlineInputBorder(
                borderRadius:
                    BorderRadius
                        .circular(
                  16,
                ),
                borderSide:
                    BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}