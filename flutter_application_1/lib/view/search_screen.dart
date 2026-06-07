import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/book_model.dart';
import 'package:flutter_application_1/view/product_detail_screen.dart';
import 'package:flutter_application_1/view/Beranda/category_screen.dart';
import '../../widgets/buyer_product_card.dart'; // Memakai card standar kelompokmu

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();

  List<DocumentSnapshot> _allBooks = [];
  List<DocumentSnapshot> _filteredBooks = [];
  bool _isLoading = true;

  List<String> histories = [
    "Harry Potter",
    "Self Improvement",
    "Cooking",
    "Tere Liye",
  ];

  @override
  void initState() {
    super.initState();
    _fetchSearchData();
  }

  // 1. Ambil data mentah Firestore sekali saja agar proses ketik pencarian terasa instan
  Future<void> _fetchSearchData() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('books')
          .get();
      setState(() {
        _allBooks = snapshot.docs;
        _filteredBooks =
            snapshot.docs; // Awal mula tampilkan semua buku populer
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Gagal memuat data pencarian: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  // 2. Filter Pencarian Multi-Parameter (Judul, Penulis, ISBN)
  void _filterSearch(String query) {
    String cleanQuery = query.toLowerCase().trim();
    setState(() {
      if (cleanQuery.isEmpty) {
        _filteredBooks = _allBooks;
      } else {
        _filteredBooks = _allBooks.where((doc) {
          final data = doc.data() as Map<String, dynamic>;

          String title = (data['title'] ?? '').toString().toLowerCase();
          String author = (data['author'] ?? '').toString().toLowerCase();
          String isbn = (data['isbn'] ?? '').toString().toLowerCase();

          return title.contains(cleanQuery) ||
              author.contains(cleanQuery) ||
              isbn.contains(cleanQuery);
        }).toList();
      }
    });
  }

  String formatRupiah(String hargaRaw) {
    if (hargaRaw.isEmpty) return 'Rp 0';
    String cleanHarga = hargaRaw.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanHarga.isEmpty) return 'Rp 0';

    final value = int.tryParse(cleanHarga) ?? 0;
    String str = value.toString();
    String result = '';
    int count = 0;

    for (int i = str.length - 1; i >= 0; i--) {
      result = str[i] + result;
      count++;
      if (count == 3 && i != 0) {
        result = '.$result';
        count = 0;
      }
    }
    return 'Rp $result';
  }

  Future<void> toggleWishlist(String docId, bool currentStatus) async {
    try {
      await FirebaseFirestore.instance.collection('books').doc(docId).update({
        'isFavorite': !currentStatus,
      });
      _fetchSearchData(); // Refresh data lokal setelah status wishlist berubah
    } catch (e) {
      debugPrint('Gagal update wishlist: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F4EC),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// SEARCH BAR
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.arrow_back,
                            color: Color(0xFF4A2E2B),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: const Color(0xffECE4D2),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: TextField(
                              controller: searchController,
                              onChanged: (value) {
                                _filterSearch(value);
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: const Icon(
                                  Icons.search,
                                  color: Color(0xFF4A2E2B),
                                ),
                                hintText: "Search books, authors, ISBN...",
                                hintStyle: GoogleFonts.plusJakartaSans(
                                  color: Colors.grey,
                                ),
                                suffixIcon: IconButton(
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    searchController.clear();
                                    _filterSearch("");
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    /// RIWAYAT PENCARIAN
                    if (histories.isNotEmpty) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Riwayat Pencarian",
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                              color: const Color(0xFF4A2E2B),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                histories.clear();
                              });
                            },
                            child: Text(
                              "Hapus Semua",
                              style: GoogleFonts.plusJakartaSans(
                                color: const Color(0xffC84F15),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: histories.map((item) {
                          return GestureDetector(
                            onTap: () {
                              searchController.text = item;
                              _filterSearch(item);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xffE9DED4),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    item,
                                    style: GoogleFonts.plusJakartaSans(
                                      color: const Color(0xFF4A2E2B),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  const Icon(
                                    Icons.history,
                                    size: 16,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 30),
                    ],

                    /// KATEGORI POPULER
                    Text(
                      "Kategori Populer",
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: const Color(0xFF4A2E2B),
                      ),
                    ),

                    const SizedBox(height: 18),

                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 15,
                      childAspectRatio: 1.4,
                      children: [
                        categoryCard(
                          title: "FIKSI",
                          icon: Icons.menu_book,
                          backgroundIcon: Icons.menu_book,
                          bgColor: const Color(0xffF5E3D6),
                          textColor: const Color(0xffC14C12),
                        ),
                        categoryCard(
                          title: "SEKOLAH",
                          icon: Icons.school,
                          backgroundIcon: Icons.school,
                          bgColor: const Color(0xffEBDDDD),
                          textColor: const Color(0xff650D2E),
                        ),
                        categoryCard(
                          title: "SENI/HOBI",
                          icon: Icons.palette,
                          backgroundIcon: Icons.palette_outlined,
                          bgColor: const Color(0xffF7E1E4),
                          textColor: const Color(0xffFF6B98),
                        ),
                        categoryCard(
                          title: "SEJARAH",
                          icon: Icons.gavel,
                          backgroundIcon: Icons.gavel,
                          bgColor: const Color(0xffE9E4DB),
                          textColor: const Color(0xff33211C),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    /// HASIL / SEDANG POPULER
                    Text(
                      searchController.text.isEmpty
                          ? "Sedang Populer"
                          : "Hasil Pencarian",
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: const Color(0xFF4A2E2B),
                      ),
                    ),

                    const SizedBox(height: 18),

                    _filteredBooks.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Text(
                                'Buku tidak ditemukan...',
                                style: GoogleFonts.plusJakartaSans(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          )
                        : GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _filteredBooks.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 15,
                                  mainAxisSpacing: 15,
                                  childAspectRatio: 0.55,
                                ),
                            itemBuilder: (context, index) {
                              final docId = _filteredBooks[index].id;
                              final bookMap =
                                  _filteredBooks[index].data()
                                      as Map<String, dynamic>;
                              final bool favStatus =
                                  bookMap['isFavorite'] ?? false;

                              return BuyerProductCard(
                                imageUrl:
                                    bookMap['image'] ??
                                    bookMap['imageUrl'] ??
                                    '',
                                title: bookMap['title'] ?? '',
                                author: bookMap['author'] ?? '',
                                price: formatRupiah(
                                  bookMap['price']?.toString() ?? '',
                                ),
                                rating: bookMap['rating']?.toString() ?? '0.0',
                                storeName: bookMap['storeName'] ?? 'Toko Buku',
                                isFavorite: favStatus,
                                onTap: () {
                                  // Bungkus map data menjadi bentuk objek BookModel
                                  BookModel selectedBook = BookModel.fromMap(
                                    bookMap,
                                    docId,
                                  );

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ProductDetailScreen(
                                        book: selectedBook,
                                      ),
                                    ),
                                  );
                                },
                                onFavoriteTap: () {
                                  toggleWishlist(docId, favStatus);
                                },
                              );
                            },
                          ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget categoryCard({
    required String title,
    required IconData icon,
    required IconData backgroundIcon,
    required Color bgColor,
    required Color textColor,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => CategoryScreen(category: title)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Stack(
          children: [
            /// ICON BESAR BELAKANG
            Positioned(
              right: -10,
              bottom: -10,
              child: Icon(
                backgroundIcon,
                size: 110,
                color: textColor.withOpacity(0.08),
              ),
            ),

            /// KONTEN DEPAN
            Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, size: 30, color: textColor),
                  const Spacer(),
                  Text(
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
