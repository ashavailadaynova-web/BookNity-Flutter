import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../viewmodel/user_viewmodel.dart';
import '../../model/book_model.dart';
import 'category_screen.dart';
import '../message_screen.dart';
import 'wishlist_screen.dart';
import '../search_screen.dart';
import '../product_detail_screen.dart';
import '../../widgets/buyer_product_card.dart';
import 'package:flutter_application_1/view/Profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTab = 0;
  final PageController _bannerController = PageController();
  int _currentBanner = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser != null) {
        context.read<UserViewModel>().getUser(firebaseUser.uid);
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
        result = '.' + result;
        count = 0;
      }
    }
    return 'Rp ' + result;
  }

  Future<void> toggleWishlist(String docId, bool currentStatus) async {
    try {
      await FirebaseFirestore.instance.collection('books').doc(docId).update({
        'isFavorite': !currentStatus,
      });
    } catch (e) {
      debugPrint('Gagal update wishlist: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              _buildSearchBar(),
              _buildBannerSlider(),
              _buildKategoriBuku(),
              _buildSedangPopuler(),
              _buildRekomendasiUntukmu(),
              _buildDaftarBukuRekomendasi(),
            ],
          ),
        ),
      ),
    );
  }

  // 1. Header: Profil (SUDAH AKTIF BISA DIKLIK) & Nama User Dinamis
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          // 🟢 SEKARANG SUDAH BISA DIKLIK: Pindah ke Profil saat bulatan ditekan
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
            child: CircleAvatar(
              radius: 24,
              backgroundColor: Colors.orange.shade100,
              child: const Icon(Icons.person, color: Colors.orange, size: 30),
            ),
          ),
          const SizedBox(width: 12),
          Consumer<UserViewModel>(
            builder: (context, userVM, child) {
              final userData = userVM.currentUser;
              final String namaUser = userData?.name.isNotEmpty == true
                  ? userData!.name
                  : "Pengguna";

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hi, ' + namaUser + '!',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A2E2B),
                    ),
                  ),
                ],
              );
            },
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Color(0xFF4A2E2B)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const WishlistScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.chat_bubble_outline,
              color: Color(0xFF4A2E2B),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MessageScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  // 2. Search Bar
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SearchScreen()),
                );
              },
              child: Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8EE),
                  borderRadius: BorderRadius.circular(25),
                ),
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Search books, authors, ISBN',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchScreen()),
              );
            },
            child: const CircleAvatar(
              backgroundColor: Color(0xFF5C3826),
              child: Icon(Icons.search, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // 3. Banner Promo Slider
  Widget _buildBannerSlider() {
    List<String> bannerImages = [
      'assets/promo_summer.png',
      'assets/promo_komik.png',
      'assets/promo_member.png',
    ];

    return Column(
      children: [
        SizedBox(
          height: 150,
          child: PageView.builder(
            controller: _bannerController,
            itemCount: bannerImages.length,
            onPageChanged: (index) {
              setState(() {
                _currentBanner = index;
              });
            },
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ClipRRect(borderRadius: BorderRadius.circular(15)),
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(bannerImages.length, (index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 6,
              width: _currentBanner == index ? 16 : 6,
              decoration: BoxDecoration(
                color: _currentBanner == index
                    ? const Color(0xFFA23914)
                    : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        ),
      ],
    );
  }

  // 4. Kategori Buku
  Widget _buildKategoriBuku() {
    List<Map<String, dynamic>> kategori = [
      {
        'nama': 'SEMUA',
        'icon': Icons.grid_view,
        'color': const Color(0xFF3E2723),
        'iconColor': Colors.white,
      },
      {
        'nama': 'FIKSI',
        'icon': Icons.menu_book,
        'color': const Color(0xFFFFCDD2),
        'iconColor': const Color(0xFFE53935),
      },
      {
        'nama': 'SENI/HOBI',
        'icon': Icons.palette,
        'color': const Color(0xFFFFE0B2),
        'iconColor': const Color(0xFFEF6C00),
      },
      {
        'nama': 'KOMIK',
        'icon': Icons.sentiment_satisfied,
        'color': const Color(0xFFFFF9C4),
        'iconColor': const Color(0xFFF57F17),
      },
      {
        'nama': 'SEKOLAH',
        'icon': Icons.school,
        'color': const Color(0xFFC8E6C9),
        'iconColor': const Color(0xFF2E7D32),
      },
      {
        'nama': 'SEJARAH',
        'icon': Icons.gavel,
        'color': const Color(0xFFE3F2FD),
        'iconColor': const Color(0xFF1565C0),
      },
    ];

    return Column(
      children: [
        // 🟢 DIHAPUS: Mengirim parameter false agar "VIEW ALL" hilang
        _buildSectionTitle('Kategori Buku', showViewAll: false),
        SizedBox(
          height: 90,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: kategori.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          CategoryScreen(category: kategori[index]['nama']),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: kategori[index]['color'],
                        child: Icon(
                          kategori[index]['icon'],
                          color: kategori[index]['iconColor'],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        kategori[index]['nama'],
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // 5. Sedang Populer
  Widget _buildSedangPopuler() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🟢 DIHAPUS: Mengirim parameter false agar "VIEW ALL" hilang
        _buildSectionTitle('Sedang Populer', showViewAll: false),
        SizedBox(
          height: 280,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('books').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text('Tidak ada buku populer saat ini'),
                );
              }

              final bookDocs = snapshot.data!.docs;

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: bookDocs.length,
                itemBuilder: (context, index) {
                  final docId = bookDocs[index].id;
                  final book = bookDocs[index].data() as Map<String, dynamic>;
                  final bool favStatus = book['isFavorite'] ?? false;

                  return _buildCardBukuHorizontal(
                    docId,
                    book['title'] ?? '',
                    book['author'] ?? '',
                    formatRupiah(book['price'] ?? ''),
                    book['rating']?.toString() ?? '0.0',
                    favStatus,
                    book['image'] ?? book['imageUrl'] ?? '',
                    book['storeName'] ?? '',
                    book,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  // 6. Tab Rekomendasi Untukmu
  Widget _buildRekomendasiUntukmu() {
    List<String> tabs = [
      'Sering Dikunjungi',
      'Wishlist',
      'Terdekat',
      'Mengikuti',
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Rekomendasi Untukmu', showViewAll: false),
        SizedBox(
          height: 38,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: tabs.length,
            itemBuilder: (context, index) {
              bool isSelected = _selectedTab == index;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedTab = index;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFFA23914)
                        : const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    tabs[index],
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  // 7. Daftar Buku Rekomendasi
  Widget _buildDaftarBukuRekomendasi() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('books').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Belum ada rekomendasi buku'));
          }

          List<QueryDocumentSnapshot> filteredDocs = List.from(
            snapshot.data!.docs,
          );

          if (_selectedTab == 1) {
            filteredDocs = filteredDocs.where((doc) {
              final bookData = doc.data() as Map<String, dynamic>;
              return bookData['isFavorite'] == true;
            }).toList();
          } else if (_selectedTab == 0) {
            filteredDocs.sort((a, b) {
              final dataA = a.data() as Map<String, dynamic>;
              final dataB = b.data() as Map<String, dynamic>;
              final double ratingA =
                  double.tryParse(dataA['rating']?.toString() ?? '0.0') ?? 0.0;
              final double ratingB =
                  double.tryParse(dataB['rating']?.toString() ?? '0.0') ?? 0.0;
              return ratingB.compareTo(ratingA);
            });
          }

          if (filteredDocs.isEmpty) {
            String namaTab = _selectedTab == 1 ? "Wishlist" : "Kategori Ini";
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Center(
                child: Text(
                  'Belum ada buku untuk kategori ' + namaTab,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
            );
          }

          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.55,
            ),
            itemCount: filteredDocs.length,
            itemBuilder: (context, index) {
              final docId = filteredDocs[index].id;
              final book = filteredDocs[index].data() as Map<String, dynamic>;
              final bool favStatus = book['isFavorite'] ?? false;

              return _buildCardBukuVertikal(
                docId,
                book['title'] ?? '',
                book['author'] ?? '',
                formatRupiah(book['price'] ?? ''),
                book['rating']?.toString() ?? '0.0',
                book['storeName'] ?? '',
                book['image'] ?? book['imageUrl'] ?? '',
                favStatus,
                book,
              );
            },
          );
        },
      ),
    );
  }

  // Fungsi Section Title dengan opsi menyembunyikan VIEW ALL
  Widget _buildSectionTitle(String title, {bool showViewAll = true}) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A2E2B),
            ),
          ),
          if (showViewAll)
            const Text(
              'VIEW ALL',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFFA23914),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCardBukuHorizontal(
    String docId,
    String judul,
    String penulis,
    String harga,
    String rating,
    bool isFavorite,
    String pathGambar,
    String namaToko,
    Map<String, dynamic> rawMap,
  ) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 16),
      child: _buildKontenCard(
        docId,
        judul,
        penulis,
        harga,
        rating,
        isFavorite,
        pathGambar,
        namaToko,
        rawMap,
      ),
    );
  }

  Widget _buildCardBukuVertikal(
    String docId,
    String judul,
    String penulis,
    String harga,
    String rating,
    String namaToko,
    String pathGambar,
    bool isFavorite,
    Map<String, dynamic> rawMap,
  ) {
    return _buildKontenCard(
      docId,
      judul,
      penulis,
      harga,
      rating,
      isFavorite,
      pathGambar,
      namaToko,
      rawMap,
    );
  }

  Widget _buildKontenCard(
    String docId,
    String judul,
    String penulis,
    String harga,
    String rating,
    bool isFavorite,
    String pathGambar,
    String namaToko,
    Map<String, dynamic> rawMap,
  ) {
    return BuyerProductCard(
      imageUrl: pathGambar,
      title: judul,
      author: penulis,
      price: harga,
      rating: rating,
      storeName: namaToko.isEmpty ? 'Toko Buku' : namaToko,
      isFavorite: isFavorite,
      onTap: () {
        BookModel selectedBook = BookModel.fromMap(rawMap, docId);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(book: selectedBook),
          ),
        );
      },
      onFavoriteTap: () {
        toggleWishlist(docId, isFavorite);
      },
    );
  }

  @override
  void dispose() {
    _bannerController.dispose();
    super.dispose();
  }
}
