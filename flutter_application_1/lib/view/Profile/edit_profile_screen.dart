import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../../model/user_model.dart';
import '../../viewmodel/user_viewmodel.dart';
import 'dart:io';
import 'dart:convert'; // Untuk jsonDecode

import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http; // Ganti Firebase Storage dengan HTTP

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  File? _imageFile;
  String _photoUrl = '';
  bool _isLoading = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController(
    text: "",
  );
  final TextEditingController _locationController = TextEditingController(
    text: "",
  );
  final TextEditingController _bioController = TextEditingController(text: "");
  final TextEditingController _websiteController = TextEditingController(
    text: "",
  );
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();

  final List<String> _categories = [
    "Horror",
    "Fiction",
    "Mystery",
    "History",
    "Comic",
    "Biography",
    "Romance",
  ];
  final List<String> _selectedCategories = ["Horror", "Mystery"];

  // ISI DATA CLOUDINARY KAMU DI SINI
  final String _cloudinaryCloudName = "dgikejn83";
  final String _cloudinaryUploadPreset = "UploadImage";

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (pickedFile == null) return;

    setState(() {
      _imageFile = File(pickedFile.path);
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserData();
    });

    _bioController.addListener(() {
      setState(() {});
    });
  }

  // Fungsi Upload Baru Menggunakan REST API Cloudinary (Sangat Aman & Bebas Firebase Storage Error)
  Future<String> _uploadToCloudinary() async {
    // Jika user tidak memilih foto baru, pakai URL foto yang sudah ada saja
    if (_imageFile == null) {
      return _photoUrl;
    }

    try {
      final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/$_cloudinaryCloudName/image/upload',
      );

      final request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = _cloudinaryUploadPreset
        ..files.add(
          await http.MultipartFile.fromPath('file', _imageFile!.path),
        );

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final jsonMap = jsonDecode(responseData);
        // Mengembalikan URL secure (https) dari Cloudinary
        return jsonMap['secure_url'] ?? _photoUrl;
      } else {
        throw Exception(
          'Gagal mengunggah ke Cloudinary. Status Code: ${response.statusCode}',
        );
      }
    } catch (e) {
      print("Error Cloudinary Upload: $e");
      rethrow;
    }
  }

  Future<void> _loadUserData() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) return;

    final userVM = context.read<UserViewModel>();
    await userVM.getUser(firebaseUser.uid);

    final user = userVM.currentUser;
    if (user == null) return;

    setState(() {
      _nameController.text = user.name;
      _emailController.text = user.email;
      _bioController.text = user.bio;
      _locationController.text = user.location;
      _websiteController.text = user.website;
      _usernameController.text = user.username;
      _birthDateController.text = user.birthDate;
      _photoUrl = user.photoUrl;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2003, 12, 12),
      firstDate: DateTime(1970),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFB13D14),
              onPrimary: Colors.white,
              onSurface: Color(0xFF3E2723),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        final months = [
          "Januari",
          "Februari",
          "Maret",
          "April",
          "Mei",
          "Juni",
          "Juli",
          "Agustus",
          "September",
          "Oktober",
          "November",
          "Desember",
        ];
        _birthDateController.text =
            "${picked.day} ${months[picked.month - 1]} ${picked.year}";
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _locationController.dispose();
    _bioController.dispose();
    _websiteController.dispose();
    _emailController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryTextColor = Color(0xFF3E2723);
    const accentColor = Color(0xFFB13D14);
    const labelColor = Color(0xFF795548);
    const fieldColor = Color(0xFFF8F9FA);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: primaryTextColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Edit Profile",
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: primaryTextColor,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(
                      left: 24.0,
                      right: 24.0,
                      bottom: 100.0,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          Center(
                            child: GestureDetector(
                              onTap: _pickImage,
                              child: Stack(
                                children: [
                                  Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.brown.shade100,
                                    ),
                                    child: ClipOval(
                                      child: _imageFile != null
                                          ? Image.file(
                                              _imageFile!,
                                              fit: BoxFit.cover,
                                            )
                                          : (_photoUrl.isNotEmpty
                                                ? Image.network(
                                                    _photoUrl,
                                                    fit: BoxFit.cover,
                                                    errorBuilder:
                                                        (
                                                          context,
                                                          error,
                                                          stackTrace,
                                                        ) {
                                                          return const Icon(
                                                            Icons.person,
                                                            size: 50,
                                                            color: Colors.grey,
                                                          );
                                                        },
                                                  )
                                                : Center(
                                                    child: Text(
                                                      _nameController
                                                              .text
                                                              .isNotEmpty
                                                          ? _nameController
                                                                .text[0]
                                                                .toUpperCase()
                                                          : "?",
                                                      style: const TextStyle(
                                                        fontSize: 40,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  )),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(7),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFFF7043),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.camera_alt_rounded,
                                        color: Colors.white,
                                        size: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          _buildFieldLabel("FULL NAME", labelColor),
                          _buildTextField(
                            controller: _nameController,
                            fillColor: fieldColor,
                            textColor: primaryTextColor,
                            focusColor: accentColor,
                          ),
                          const SizedBox(height: 20),
                          _buildFieldLabel("USERNAME", labelColor),
                          _buildTextField(
                            controller: _usernameController,
                            fillColor: fieldColor,
                            textColor: primaryTextColor,
                            focusColor: accentColor,
                            prefixIcon: const Padding(
                              padding: EdgeInsets.all(14.0),
                              child: Text(
                                "@",
                                style: TextStyle(
                                  color: accentColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildFieldLabel("TANGGAL LAHIR", labelColor),
                          GestureDetector(
                            onTap: () => _selectDate(context),
                            child: AbsorbPointer(
                              child: _buildTextField(
                                controller: _birthDateController,
                                fillColor: fieldColor,
                                textColor: primaryTextColor,
                                focusColor: accentColor,
                                prefixIcon: const Icon(
                                  Icons.calendar_month_rounded,
                                  color: accentColor,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildFieldLabel("LOKASI", labelColor),
                          _buildTextField(
                            controller: _locationController,
                            fillColor: fieldColor,
                            textColor: primaryTextColor,
                            focusColor: accentColor,
                            prefixIcon: const Icon(
                              Icons.location_on_rounded,
                              color: accentColor,
                              size: 18,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildFieldLabel("BIO", labelColor),
                              Text(
                                "${_bioController.text.length}/150",
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  color: Colors.grey[500],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          _buildTextField(
                            controller: _bioController,
                            fillColor: fieldColor,
                            textColor: primaryTextColor,
                            focusColor: accentColor,
                            maxLines: 4,
                            maxLength: 150,
                            showCounter: false,
                            isBioField: true,
                          ),
                          const SizedBox(height: 20),
                          _buildFieldLabel("PERSONAL WEBSITE", labelColor),
                          _buildTextField(
                            controller: _websiteController,
                            fillColor: fieldColor,
                            textColor: primaryTextColor,
                            focusColor: accentColor,
                            prefixIcon: const Icon(
                              Icons.link_rounded,
                              color: Colors.grey,
                              size: 18,
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildFieldLabel("FAVORITE GENRES", labelColor),
                          const SizedBox(height: 4),
                          Wrap(
                            spacing: 8.0,
                            runSpacing: 4.0,
                            children: _categories.map((category) {
                              final isSelected = _selectedCategories.contains(
                                category,
                              );
                              return FilterChip(
                                label: Text(category),
                                labelStyle: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: isSelected
                                      ? Colors.white
                                      : primaryTextColor,
                                ),
                                selected: isSelected,
                                selectedColor: accentColor,
                                checkmarkColor: Colors.white,
                                backgroundColor: fieldColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide.none,
                                ),
                                onSelected: (bool selected) {
                                  setState(() {
                                    if (selected) {
                                      _selectedCategories.add(category);
                                    } else {
                                      _selectedCategories.remove(category);
                                    }
                                  });
                                },
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 32),
                          Text(
                            "Private Information",
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: primaryTextColor,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Divider(
                              color: Color(0xFFEFE6D5),
                              thickness: 1,
                            ),
                          ),
                          _buildFieldLabel("EMAIL ADDRESS", labelColor),
                          _buildTextField(
                            controller: _emailController,
                            fillColor: fieldColor,
                            textColor: primaryTextColor,
                            focusColor: accentColor,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 36),
                          Center(
                            child: TextButton(
                              onPressed: () {},
                              child: Text(
                                "Delete Account",
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red[700],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () async {
                            if (!_formKey.currentState!.validate()) return;
                            final firebaseUser =
                                FirebaseAuth.instance.currentUser;
                            if (firebaseUser == null) return;

                            setState(() {
                              _isLoading = true;
                            });

                            try {
                              // Mengunggah gambar aman langsung ke Cloudinary REST API
                              final cloudinaryUrl = await _uploadToCloudinary();

                              final updatedUser = UserModel(
                                uid: firebaseUser.uid,
                                name: _nameController.text.trim(),
                                email: _emailController.text.trim(),
                                bio: _bioController.text.trim(),
                                location: _locationController.text.trim(),
                                website: _websiteController.text.trim(),
                                username: _usernameController.text.trim(),
                                birthDate: _birthDateController.text.trim(),
                                photoUrl:
                                    cloudinaryUrl, // URL Cloudinary disimpan ke ViewModel
                              );

                              await context.read<UserViewModel>().updateUser(
                                updatedUser,
                              );
                              await context.read<UserViewModel>().getUser(
                                firebaseUser.uid,
                              );

                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Profil berhasil disimpan"),
                                ),
                              );
                              Navigator.pop(context);
                            } catch (e) {
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Gagal menyimpan profil: $e"),
                                ),
                              );
                            } finally {
                              if (mounted) {
                                setState(() {
                                  _isLoading = false;
                                });
                              }
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB13D14),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(
                      "Save Changes",
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (_isLoading)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: Card(
                    elevation: 4,
                    child: Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xFFB13D14),
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            "Mengunggah foto & profil...",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String labelText, Color color) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
      child: Text(
        labelText,
        style: GoogleFonts.poppins(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required Color fillColor,
    required Color textColor,
    required Color focusColor,
    Widget? prefixIcon,
    int maxLines = 1,
    int? maxLength,
    bool showCounter = false,
    bool isBioField = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      maxLength: maxLength,
      keyboardType: keyboardType,
      onChanged: isBioField ? null : (text) => setState(() {}),
      style: GoogleFonts.poppins(color: textColor, fontSize: 13, height: 1.4),
      decoration: InputDecoration(
        filled: true,
        fillColor: fillColor,
        prefixIcon: prefixIcon,
        counterText: showCounter ? null : "",
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: focusColor, width: 1.2),
        ),
      ),
    );
  }
}
