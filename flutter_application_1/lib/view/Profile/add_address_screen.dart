
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() =>
      _AddAddressScreenState();
}

class _AddAddressScreenState
    extends State<AddAddressScreen> {

  final _recipientController =
      TextEditingController();

  final _phoneController =
      TextEditingController();

  final _addressController =
      TextEditingController();

  final _labelController =
      TextEditingController();

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
          onPressed: () =>
              Navigator.pop(context),
        ),

        title: Text(
          "Tambah Alamat",
          style: GoogleFonts.poppins(
            fontWeight:
                FontWeight.bold,
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

              decoration:
                  InputDecoration(
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
                onPressed: () {

                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Alamat berhasil disimpan",
                      ),
                    ),
                  );

                  Navigator.pop(
                    context,
                  );
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

