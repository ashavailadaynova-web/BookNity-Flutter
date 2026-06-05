import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'success_add_product_screen.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../model/book_model.dart';
import '../viewmodel/book_viewmodel.dart';


class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});
  

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  File? selectedImage;

  final ImagePicker _picker =ImagePicker();
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

  Future<void> pickImage() async {
  final XFile? image =
      await _picker.pickImage(
    source: ImageSource.gallery,
  );

  if (image != null) {
    setState(() {
      selectedImage = File(image.path);
    });
  }
}

Future<void> uploadBook() async {
if (selectedImage == null) {
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content: Text(
'Silakan pilih cover buku terlebih dahulu',
),
),
);
return;
}

if (titleController.text.trim().isEmpty ||
authorController.text.trim().isEmpty ||
priceController.text.trim().isEmpty) {
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content: Text(
'Lengkapi data buku terlebih dahulu',
),
),
);
return;
}

try {
final bookViewModel =
context.read<BookViewModel>();

final imageUrl =
    await bookViewModel.uploadImage(
  selectedImage!,
);

final book = BookModel(
  title: titleController.text.trim(),
  author: authorController.text.trim(),
  image: imageUrl,
  price: priceController.text.trim(),
  category: selectedCategory,
  description:
      descriptionController.text.trim(),
  rating: 0,
  storeName: "Booknity Store",
  year: yearController.text.trim(),
  isbn: isbnController.text.trim(),
  condition: selectedCondition,
);

await bookViewModel.addBook(book);

if (!mounted) return;

Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (_) =>
        const SuccessAddProductScreen(),
  ),
);


} catch (e) {
ScaffoldMessenger.of(context).showSnackBar(
SnackBar(
content: Text(
'Upload gagal: $e',
),
),
);
}
}


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
            SizedBox(
            width: double.infinity,
            child: GestureDetector(
              onTap: pickImage,
              child: _imageBox(
                width: double.infinity,
                height: 220,
                large: true,
              ),
            ),
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
              print("TOMBOL DITEKAN");
            },
            child: const Text(
              "Unggah Produk",
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
  @override
  void dispose() {
    titleController.dispose();
    authorController.dispose();
    yearController.dispose();
    isbnController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    super.dispose();
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
    child: selectedImage != null && large
    ? ClipRRect(
    borderRadius: BorderRadius.circular(28),
    child: Image.file(
    selectedImage!,
    fit: BoxFit.cover,
    width: width,
    height: height,
    ),
    )
    : large
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