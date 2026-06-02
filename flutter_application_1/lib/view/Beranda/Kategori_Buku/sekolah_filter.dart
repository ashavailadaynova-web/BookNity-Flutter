import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SekolahFilterBottomSheet extends StatefulWidget {
  const SekolahFilterBottomSheet({Key? key}) : super(key: key);

  @override
  State<SekolahFilterBottomSheet> createState() => _SekolahFilterBottomSheetState();
}

class _SekolahFilterBottomSheetState extends State<SekolahFilterBottomSheet> {
  double _currentSliderValue = 0;
  String _selectedRating = '1+';

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          // Header Filter
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.tune, color: Colors.black, size: 22),
                    const SizedBox(width: 10),
                    Text(
                      'Filter',
                      style: GoogleFonts.montserrat(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const CircleAvatar(
                    radius: 16,
                    backgroundColor: Color(0xFFF5EFE6),
                    child: Icon(Icons.close, size: 16, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFEFEFEF)),

          // Pilihan Filter (Scrollable)
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
              children: [
                // URUTKAN
                _buildFilterTitle('URUTKAN'),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _buildFilterChip('Terbaru', isSelected: true),
                    const SizedBox(width: 10),
                    _buildFilterChip('Populer', isSelected: false),
                    const SizedBox(width: 10),
                    _buildFilterChip('Harga', isSelected: false),
                  ],
                ),
                const SizedBox(height: 25),

                // KATEGORI
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildFilterTitle('KATEGORI'),
                    Text(
                      'Pilih Lebih Dari Satu',
                      style: GoogleFonts.montserrat(
                        fontSize: 10, 
                        color: const Color(0xFF8C8C8C),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _buildCategoryChip('Fiction', isActive: true),
                    _buildCategoryChip('Mystery', isActive: true),
                    _buildCategoryChip('Romance', isActive: true),
                    _buildCategoryChip('Thriller', isActive: false),
                    _buildCategoryChip('Fantasy', isActive: false),
                    _buildCategoryChip('History', isActive: false),
                    _buildCategoryChip('Poetry', isActive: false),
                    _buildCategoryChip('Biography', isActive: false),
                  ],
                ),
                const SizedBox(height: 25),

                // RENTANG HARGA
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildFilterTitle('RENTANG HARGA'),
                    Text(
                      '${_currentSliderValue.toInt()}',
                      style: GoogleFonts.montserrat(fontWeight: FontWeight.w700, fontSize: 14),
                    ),
                  ],
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: const Color(0xFFE8D8C8),
                    inactiveTrackColor: const Color(0xFFEFEFEF),
                    thumbColor: Colors.white,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 10, 
                      pressedElevation: 4
                    ),
                  ),
                  child: Slider(
                    value: _currentSliderValue,
                    min: 0,
                    max: 100000,
                    onChanged: (value) {
                      setState(() {
                        _currentSliderValue = value;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('MIN', style: GoogleFonts.montserrat(fontSize: 10, color: const Color(0xFF8C8C8C), fontWeight: FontWeight.w600)),
                      Text('MAX', style: GoogleFonts.montserrat(fontSize: 10, color: const Color(0xFF8C8C8C), fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                const SizedBox(height: 25),

                // RATING MINIMUM
                _buildFilterTitle('RATING MINIMUM'),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildRatingItem('1+'),
                    _buildRatingItem('2+'),
                    _buildRatingItem('3+'),
                    _buildRatingItem('4+'),
                    _buildRatingItem('5'),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),

          // Tombol Bawah
          const Divider(height: 1, color: Color(0xFFEFEFEF)),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _currentSliderValue = 0;
                        _selectedRating = '1+';
                      });
                    },
                    child: Text(
                      'Ulangi',
                      style: GoogleFonts.montserrat(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A352F), 
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Terapkan',
                          style: GoogleFonts.montserrat(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15),
                        ),
                        const SizedBox(width: 5),
                        const Icon(Icons.chevron_right, color: Colors.white, size: 18),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.montserrat(
        color: const Color(0xFF801A3B), 
        fontWeight: FontWeight.w700,
        fontSize: 12,
        letterSpacing: 0.8,
      ),
    );
  }

  Widget _buildFilterChip(String label, {required bool isSelected}) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? Colors.transparent : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFD3C2B5), width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
      child: Text(
        label,
        style: GoogleFonts.montserrat(
          fontSize: 13,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          color: isSelected ? const Color(0xFF42210B) : const Color(0xFF6E5D53),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label, {required bool isActive}) {
    return Container(
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFEFE8DE) : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      child: Text(
        label,
        style: GoogleFonts.montserrat(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF42210B),
        ),
      ),
    );
  }

  Widget _buildRatingItem(String label) {
    final bool isSelected = _selectedRating == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedRating = label;
        });
      },
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFFEFE8DE),
              shape: BoxShape.circle,
              border: isSelected ? Border.all(color: const Color(0xFFC76E2E), width: 2) : null,
            ),
            child: const Icon(Icons.star, color: Color(0xFFC76E2E), size: 22),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: GoogleFonts.montserrat(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}