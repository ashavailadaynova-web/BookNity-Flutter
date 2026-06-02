import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FiksiFilter extends StatefulWidget {
  const FiksiFilter({Key? key}) : super(key: key);

  @override
  State<FiksiFilter> createState() => _FiksiFilterState();
}

class _FiksiFilterState extends State<FiksiFilter> {
  String _selectedUrutan = 'Terbaru';
  double _currentPriceRange = 0.0;
  String _selectedRating = '1+';

  final List<String> _categories = [
    'Fiction', 'Mystery', 'Romance', 'Thriller', 'Fantasy', 'History', 'Poetry', 'Biography'
  ];
  final List<String> _selectedCategories = ['Fiction']; // Default terpilih sesuai figma

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: const EdgeInsets.only(top: 16, left: 24, right: 24, bottom: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Filter
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.sort, color: Color(0xFF42210B)),
                  const SizedBox(width: 10),
                  Text(
                    'Filter',
                    style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.w700, color: const Color(0xFF42210B)),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const CircleAvatar(
                  radius: 16,
                  backgroundColor: Color(0xFFF3EFE0),
                  child: Icon(Icons.close, size: 18, color: Colors.black),
                ),
              ),
            ],
          ),
          const Divider(height: 30, thickness: 1),

          // SECTION 1: URUTKAN
          _buildSectionTitle('URUTKAN'),
          Row(
            children: ['Terbaru', 'Populer', 'Harga'].map((type) {
              final isSelected = _selectedUrutan == type;
              return Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: ChoiceChip(
                  label: Text(type),
                  selected: isSelected,
                  selectedColor: Colors.white,
                  backgroundColor: Colors.white,
                  labelStyle: GoogleFonts.montserrat(
                    color: isSelected ? const Color(0xFF42210B) : Colors.grey[700],
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: isSelected ? const Color(0xFF42210B) : Colors.grey[300]!),
                  ),
                  onSelected: (val) => setState(() => _selectedUrutan = type),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // SECTION 2: KATEGORI
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSectionTitle('KATEGORI'),
              Text('Pilih Lebih Dari Satu', style: GoogleFonts.montserrat(fontSize: 11, color: Colors.grey)),
            ],
          ),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: _categories.map((cat) {
              final isSelected = _selectedCategories.contains(cat);
              return ChoiceChip(
                label: Text(cat),
                selected: isSelected,
                selectedColor: const Color(0xFFEFEAD8),
                backgroundColor: const Color(0xFFF5F1E6).withOpacity(0.5),
                labelStyle: GoogleFonts.montserrat(color: const Color(0xFF42210B), fontSize: 13),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide.none),
                onSelected: (val) {
                  setState(() {
                    if (val) {
                      _selectedCategories.add(cat);
                    } else {
                      _selectedCategories.remove(cat);
                    }
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // SECTION 3: RENTANG HARGA
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSectionTitle('RENTANG HARGA'),
              Text('${_currentPriceRange.toInt()}', style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, color: const Color(0xFF42210B))),
            ],
          ),
          Slider(
            value: _currentPriceRange,
            max: 500000,
            activeColor: const Color(0xFFC67C4E),
            inactiveColor: const Color(0xFFEFEAD8),
            onChanged: (val) => setState(() => _currentPriceRange = val),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('MIN', style: GoogleFonts.montserrat(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold)),
              Text('MAX', style: GoogleFonts.montserrat(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 20),

          // SECTION 4: RATING MINIMUM
          _buildSectionTitle('RATING MINIMUM'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ['1+', '2+', '3+', '4+', '5'].map((star) {
              final isSelected = _selectedRating == star;
              return GestureDetector(
                onTap: () => setState(() => _selectedRating = star),
                child: Container(
                  width: 55,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFEAD8).withOpacity(0.7),
                    shape: BoxShape.circle,
                    border: isSelected ? Border.all(color: const Color(0xFFC67C4E), width: 2) : null,
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.star, color: Color(0xFFB3541E), size: 18),
                      const SizedBox(height: 4),
                      Text(star, style: GoogleFonts.montserrat(fontSize: 11, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 35),

          // BUTTONS: ULANGI & TERAPKAN
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {},
                  child: Text('Ulangi', style: GoogleFonts.montserrat(color: const Color(0xFF42210B), fontWeight: FontWeight.w600)),
                ),
              ),
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A3428),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                    ),
                    child: Text('Terapkan ›', style: GoogleFonts.montserrat(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFF8F4F17), letterSpacing: 0.5),
      ),
    );
  }
}