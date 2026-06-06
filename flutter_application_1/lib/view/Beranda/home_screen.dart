import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'category_screen.dart';
import '../message_screen.dart';
import 'wishlist_screen.dart';
import '../search_screen.dart';
import '../../widgets/buyer_product_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTab = 0;
  final PageController _bannerController = PageController();
  int _currentBanner = 0;

  // 🟢 HELPER UTK FORMAT RUPIAH
  String formatRupiah(String hargaRaw) {
    if (hargaRaw.isEmpty) return 'Rp 0';
    // Menghapus karakter non-angka jika ada
    String cleanHarga = hargaRaw.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanHarga.isEmpty) return 'Rp 0';

    final value = int.tryParse(cleanHarga) ?? 0;
    // Format manual ribuan tanpa package tambahan
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

  // 🟢 FUNGSIONALITAS TOGGLE WISHLIST DI FIRESTORE
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

  // 1. Header: Profil & Nama User
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.orange.shade100,
            child: const Icon(Icons.person, color: Colors.orange, size: 30),
          ),
          const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hi, Shava!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A2E2B),
                ),
              ),
            ],
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
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    bannerImages[index],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xFF4DB6AC),
                        alignment: Alignment.center,
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image_not_supported,
                              size: 40,
                              color: Colors.white,
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Gambar Banner Belum Ada',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
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
        _buildSectionTitle('Kategori Buku'),
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
        _buildSectionTitle('Sedang Populer'),
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
                  final docId =
                      bookDocs[index].id; // Ambil ID Dokumen Firestore
                  final book = bookDocs[index].data() as Map<String, dynamic>;
                  final bool favStatus = book['isFavorite'] ?? false;

                  return _buildCardBukuHorizontal(
                    docId, // 🟢 Oper ID Dokumen
                    book['title'] ?? '',
                    book['author'] ?? '',
                    formatRupiah(book['price'] ?? ''), // 🟢 Format Jadi Rp
                    book['rating']?.toString() ?? '0.0',
                    favStatus,
                    book['image'] ?? '',
                    book['storeName'] ?? '',
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
        _buildSectionTitle('Rekomendasi Untukmu'),
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

          final bookDocs = snapshot.data!.docs;

          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.55,
            ),
            itemCount: bookDocs.length,
            itemBuilder: (context, index) {
              final docId = bookDocs[index].id; // Ambil ID Dokumen Firestore
              final book = bookDocs[index].data() as Map<String, dynamic>;
              final bool favStatus = book['isFavorite'] ?? false;

              return _buildCardBukuVertikal(
                docId, // 🟢 Oper ID Dokumen
                book['title'] ?? '',
                book['author'] ?? '',
                formatRupiah(book['price'] ?? ''), // 🟢 Format Jadi Rp
                book['rating']?.toString() ?? '0.0',
                book['storeName'] ?? '',
                book['image'] ?? '',
                favStatus, // 🟢 Oper Status Favorit
              );
            },
          );
        },
      ),
    );
  }

  // Helper: Judul Section
  Widget _buildSectionTitle(String title) {
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

  // Helper Card untuk Bagian Atas (Sedang Populer)
  Widget _buildCardBukuHorizontal(
    String docId,
    String judul,
    String penulis,
    String harga,
    String rating,
    bool isFavorite,
    String pathGambar,
    String namaToko,
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
      ),
    );
  }

  // Helper Card untuk Bagian Bawah (Rekomendasi Untukmu)
  Widget _buildCardBukuVertikal(
    String docId,
    String judul,
    String penulis,
    String harga,
    String rating,
    String namaToko,
    String pathGambar,
    bool isFavorite,
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
    );
  }

  // Blueprint Utama penghubung ke BuyerProductCard widget
  Widget _buildKontenCard(
    String docId,
    String judul,
    String penulis,
    String harga,
    String rating,
    bool isFavorite,
    String pathGambar,
    String namaToko,
  ) {
    return BuyerProductCard(
      imageUrl: pathGambar,
      title: judul,
      author: penulis,
      price: harga,
      rating: rating,
      storeName: namaToko,
      isFavorite: isFavorite,
      onTap: () {
        Navigator.pushNamed(context, '/product_detail');
      },
      onFavoriteTap: () {
        // 🟢 EKSEKUSI TOGGLE WISHLIST REAL-TIME KE FIRESTORE
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
