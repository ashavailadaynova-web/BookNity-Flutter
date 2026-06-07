import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../../model/address_model.dart';
import '../../viewmodel/address_viewmodel.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() =>
      _AddAddressScreenState();
}

class _AddAddressScreenState
    extends State<AddAddressScreen> {

  final _labelController =
      TextEditingController();

  final _recipientController =
      TextEditingController();

  final _phoneController =
      TextEditingController();

  final _addressController =
      TextEditingController();

  @override
  void dispose() {
    _labelController.dispose();
    _recipientController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    const primaryTextColor =
        Color(0xFF3E2723);

    const accentColor =
        Color(0xFFFF7043);

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: primaryTextColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: Text(
          "Tambah Alamat",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: primaryTextColor,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            _buildField(
              "Label Alamat",
              "Contoh: Rumah, Kost, Kantor",
              _labelController,
            ),

            const SizedBox(height: 16),

            _buildField(
              "Nama Penerima",
              "Masukkan nama penerima",
              _recipientController,
            ),

            const SizedBox(height: 16),

            _buildField(
              "Nomor Telepon",
              "08xxxxxxxxxx",
              _phoneController,
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller:
                  _addressController,
              maxLines: 4,

              decoration: InputDecoration(
                labelText:
                    "Alamat Lengkap",

                border:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(
                    16,
                  ),
                ),
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton(
                onPressed: () async {

                  // VALIDASI
                  if (_labelController.text.trim().isEmpty ||
                      _recipientController.text.trim().isEmpty ||
                      _phoneController.text.trim().isEmpty ||
                      _addressController.text.trim().isEmpty) {

                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Semua data alamat wajib diisi",
                        ),
                      ),
                    );

                    return;
                  }

                  final user =
                      FirebaseAuth.instance.currentUser;

                  if (user == null) return;

                  final address =
                      AddressModel(
                    id: '',
                    label: _labelController.text.trim(),
                    recipient: _recipientController.text.trim(),
                    phone: _phoneController.text.trim(),
                    address: _addressController.text.trim(),
                  );

                  await context
                      .read<AddressViewModel>()
                      .addAddress(
                        user.uid,
                        address,
                      );

                  if (!mounted) return;

                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Alamat berhasil disimpan",
                      ),
                    ),
                  );

                  Navigator.pop(context);
                },

                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      accentColor,

                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      24,
                    ),
                  ),
                ),

                child: Text(
                  "Simpan Alamat",
                  style:
                      GoogleFonts.poppins(
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

  Widget _buildField(
    String label,
    String hint,
    TextEditingController controller,
  ) {
    return TextFormField(
      controller: controller,

      decoration: InputDecoration(
        labelText: label,
        hintText: hint,

        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            16,
          ),
        ),
      ),
    );
  }
}