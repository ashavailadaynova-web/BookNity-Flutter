import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController(text: "");
  final TextEditingController _locationController = TextEditingController(text: "");
  final TextEditingController _bioController = TextEditingController(
    text: "Lover of gothic horror and vintage hardcovers. Usually found in a sun-drenched corner with a cup of oolong and a thick novel.",
  );
  final TextEditingController _websiteController = TextEditingController(text: "");
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();

  // Daftar kategori dalam Bahasa Inggris
  final List<String> _categories = ["Horror", "Fiction", "Mystery", "History", "Comic", "Biography", "Romance"];
  final List<String> _selectedCategories = ["Horror", "Mystery"]; 

  @override
void initState() {
  super.initState();

  final user =
      FirebaseAuth.instance.currentUser;

  if (user != null) {
    _nameController.text =
        user.email!
            .split('@')
            .first;

    _emailController.text =
        user.email ?? '';
  }
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
          "Januari", "Februari", "Maret", "April", "Mei", "Juni", 
          "Juli", "Agustus", "September", "Oktober", "November", "Desember"
        ];
        _birthDateController.text = "${picked.day} ${months[picked.month - 1]} ${picked.year}";
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
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      
                      Center(
                        child: Stack(
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                                image: const DecorationImage(
                                  image: NetworkImage('https://i.imgur.com/8QjU0rU.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () {},
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
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      _buildFieldLabel("FULL NAME", labelColor),
                      _buildTextField(controller: _nameController, fillColor: fieldColor, textColor: primaryTextColor, focusColor: accentColor),
                      
                      const SizedBox(height: 20),
                      
                      _buildFieldLabel("USERNAME", labelColor),
                      _buildTextField(
                        controller: _usernameController, 
                        fillColor: fieldColor, 
                        textColor: primaryTextColor, 
                        focusColor: accentColor,
                        prefixIcon: const Padding(
                          padding: EdgeInsets.all(14.0),
                          child: Text("@", style: TextStyle(color: accentColor, fontWeight: FontWeight.bold, fontSize: 16)),
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
                            prefixIcon: const Icon(Icons.calendar_month_rounded, color: accentColor, size: 18),
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
                        prefixIcon: const Icon(Icons.location_on_rounded, color: accentColor, size: 18),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildFieldLabel("BIO", labelColor),
                          Text(
                            "${_bioController.text.length}/150",
                            style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey[500], fontWeight: FontWeight.w500),
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
                      ),
                      
                      const SizedBox(height: 20),
                      
                      _buildFieldLabel("PERSONAL WEBSITE", labelColor),
                      _buildTextField(
                        controller: _websiteController, 
                        fillColor: fieldColor, 
                        textColor: primaryTextColor, 
                        focusColor: accentColor,
                        prefixIcon: const Icon(Icons.link_rounded, color: Colors.grey, size: 18),
                      ),

                      const SizedBox(height: 20),

                      // LABEL DIGANTI MENJADI FAVORITE GENRES
                      _buildFieldLabel("FAVORITE GENRES", labelColor),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 4.0,
                        children: _categories.map((category) {
                          final isSelected = _selectedCategories.contains(category);
                          return FilterChip(
                            label: Text(category),
                            labelStyle: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected ? Colors.white : primaryTextColor,
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
                        child: Divider(color: Color(0xFFEFE6D5), thickness: 1),
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

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  )
                ]
              ),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.pop(context);
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
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      maxLength: maxLength,
      keyboardType: keyboardType,
      onChanged: (text) => setState(() {}),
      style: GoogleFonts.poppins(color: textColor, fontSize: 13, height: 1.4),
      decoration: InputDecoration(
        filled: true,
        fillColor: fillColor,
        prefixIcon: prefixIcon,
        counterText: showCounter ? null : "",
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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