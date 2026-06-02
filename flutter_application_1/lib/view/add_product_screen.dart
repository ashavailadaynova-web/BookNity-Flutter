import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'success_add_product_screen.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController isbnController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  String selectedCategory = "Fiksi";
  String selectedCondition = "Like New";

  final List<String> categories = [
    "Fiksi",
    "Seni/Hobi",
    "Komik",
    "Sekolah",
    "Sejarah"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F6F4),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xffF8F6F4),
        title: const Text(
          "Tambah Produk",
          style: TextStyle(
            color: Color(0xff2B2522),
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xff2B2522)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            /// IMAGE SECTION
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _imageBox(
                    width: double.infinity,
                    height: 220,
                    large: true,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  children: [
                    _imageBox(
                      width: 110,
                      height: 104,
                      large: false,
                    ),
                    const SizedBox(height: 12),
                    _imageBox(
                      width: 110,
                      height: 104,
                      large: false,
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 28),

            _title("JUDUL BUKU"),
            _textField(
              controller: titleController,
              hint: "Judul buku",
            ),

            _title("PENULIS BUKU"),
            _textField(
              controller: authorController,
              hint: "Nama penulis buku",
            ),

            _title("TAHUN TERBIT"),
            _textField(
              controller: yearController,
              hint: "Tahun buku diterbitkan",
              keyboardType: TextInputType.number,
            ),

            _title("ISBN (OPSIONAL)"),
            _textField(
              controller: isbnController,
              hint: "Kode ISBN (Bila ada)",
            ),

            _title("KATEGORI BUKU"),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: categories.map((category) {
                bool isSelected = selectedCategory == category;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = category;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xffE8DFC8)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      category,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            _title("KONDISI BUKU"),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedCondition,
                  isExpanded: true,
                  items: const [
                    DropdownMenuItem(
                      value: "Like New",
                      child: Text("Like New"),
                    ),
                    DropdownMenuItem(
                      value: "Good",
                      child: Text("Good"),
                    ),
                    DropdownMenuItem(
                      value: "Fair",
                      child: Text("Fair"),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedCondition = value!;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 24),

            _title("HARGA (RUPIAH)"),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  prefixText: "Rp. ",
                  hintText: "Harga jual buku",
                ),
              ),
            ),

            const SizedBox(height: 24),

            _title("DESKRIPSI (OPSIONAL)"),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: descriptionController,
                maxLines: 6,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(20),
                  hintText:
                      "Deskripsikan atau beri tahu detail dari buku yang kamu jual...",
                ),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SuccessAddProductScreen(),
                  ),
                );
              },
                child: const Text(
                  "Unggah Produk",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            const Text.rich(
              TextSpan(
                text:
                    "Dengan mengunggah, kamu setuju dengan seluruh ",
                children: [
                  TextSpan(
                    text: "peraturan dan ketentuan",
                    style: TextStyle(
                      color: Colors.deepOrange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: " dari komunitas kami.",
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _title(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 16),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
            color: Color(0xff5B1930),
          ),
        ),
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          hintText: hint,
        ),
      ),
    );
  }

  Widget _imageBox({
  required double width,
  required double height,
  bool large = false,
}) {
  return Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: const Color(0xffF7F2EC),
      borderRadius: BorderRadius.circular(28),
      border: Border.all(
        color: const Color(0xffE6DDD5),
      ),
    ),
    child: large
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: const BoxDecoration(
                  color: Color(0xffB84A14),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.add_a_photo_outlined,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Add Cover Photo",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xff2B2522),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Recommended: Bright, natural light",
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          )
        : const Center(
            child: Icon(
              Icons.add_a_photo_outlined,
              size: 28,
              color: Color(0xffD5C8BF),
            ),
          ),
  );
}
}