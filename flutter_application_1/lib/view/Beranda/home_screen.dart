import 'package:flutter/material.dart';

// --- IMPORT SEMUA HALAMAN KATEGORI YANG SUDAH KAMU BUAT ---
import 'Kategori_Buku/anak_anak_screen.dart';
import 'Kategori_Buku/fiksi_screen.dart';
import 'Kategori_Buku/komik_screen.dart';
import 'Kategori_Buku/masakan_screen.dart';
import 'Kategori_Buku/sejarah_screen.dart';
import 'Kategori_Buku/sekolah_screen.dart';
import 'Kategori_Buku/selfhelp_screen.dart';
import 'Kategori_Buku/semua_screen.dart';
import 'Kategori_Buku/senihobi_screen.dart';
import '../message_screen.dart';
import 'wishlist_screen.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            bottom: 100, // Menghindari konten tertutup oleh navbar utama
          ),
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
          icon: const Icon(
            Icons.favorite_border,
            color: Color(0xFF4A2E2B),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const WishlistScreen(),
              ),
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
              MaterialPageRoute(
                builder: (_) => const MessageScreen(),
              ),
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
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8EE),
                borderRadius: BorderRadius.circular(25),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search books, authors, ISBN',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          const CircleAvatar(
            backgroundColor: Color(0xFF5C3826),
            child: Icon(Icons.search, color: Colors.white),
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

  // 4. Kategori Buku (SEKARANG SEMUANYA SUDAH BISA DIKLIK)
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
      {
        'nama': 'MASAKAN',
        'icon': Icons.restaurant,
        'color': const Color(0xFFFCE4EC),
        'iconColor': const Color(0xFFD81B60),
      },
      {
        'nama': 'SELF-HELP',
        'icon': Icons.self_improvement,
        'color': const Color(0xFFF3E5F5),
        'iconColor': const Color(0xFF8E24AA),
      },
      {
        'nama': 'ANAK-ANAK',
        'icon': Icons.child_care,
        'color': const Color(0xFFFFFDE7),
        'iconColor': const Color(0xFFF57F17),
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
                  String namaKategori = kategori[index]['nama'];

                  // Peta navigasi berdasarkan nama kategori yang ditekan
                  Widget targetScreen;

                  if (namaKategori == 'SEMUA') {
                    targetScreen = const SemuaScreen();
                  } else if (namaKategori == 'FIKSI') {
                    targetScreen = const FiksiScreen();
                  } else if (namaKategori == 'SENI/HOBI') {
                    targetScreen = const SeniHobiScreen();
                  } else if (namaKategori == 'KOMIK') {
                    targetScreen = const KomikScreen();
                  } else if (namaKategori == 'SEKOLAH') {
                    targetScreen = const SekolahScreen();
                  } else if (namaKategori == 'SEJARAH') {
                    targetScreen = const SejarahScreen();
                  } else if (namaKategori == 'MASAKAN') {
                    targetScreen = const MasakanScreen();
                  } else if (namaKategori == 'SELF-HELP') {
                    targetScreen = const SelfHelpScreen();
                  } else if (namaKategori == 'ANAK-ANAK') {
                    targetScreen = const AnakAnakScreen();
                  } else {
                    return;
                  }

                  // Eksekusi perpindahan halaman secara mulus
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => targetScreen),
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
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _buildCardBukuHorizontal(
                'Laut Bercerita',
                'Leila S. Chudori',
                'Rp. 60.000',
                '4.7',
                true,
                'assets/laut_bercerita.png',
                'Toko Buku Aceng',
              ),
              _buildCardBukuHorizontal(
                'Cantik Itu Luka',
                'Eka Kurniawan',
                'Rp. 58.000',
                '4.8',
                false,
                'assets/cantik_itu_luka.png',
                'Buku Bekas Ayu',
              ),
            ],
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
      child: Align(
        alignment: Alignment.topLeft,
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _buildCardBukuVertikal(
              'The Midnight Library',
              'Matt Haig',
              'Rp. 76.000',
              '4.7',
              'Serba Ada',
              'assets/midnight_library.png',
            ),
            _buildCardBukuVertikal(
              'Hukum Perdata Internasional',
              'Dr. Ronald Saija',
              'Rp. 58.000',
              '4.5',
              'Buku Surabaya',
              'assets/hukum_perdata.png',
            ),
            _buildCardBukuVertikal(
              'Coding Untuk PAUD',
              'Ria Hayyu',
              'Rp. 29.900',
              '4.7',
              'Toko Buku Aceng',
              'assets/coding_paud.png',
            ),
            _buildCardBukuVertikal(
              'Project Hail Mary',
              'Andy Weir',
              'Rp. 58.000',
              '4.7',
              'Rumahnya Buku',
              'assets/hail_mary.png',
            ),
          ],
        ),
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
    String judul,
    String penulis,
    String harga,
    String rating,
    String namaToko,
    String pathGambar,
  ) {
    return SizedBox(
      width: 140,
      child: _buildKontenCard(
        judul,
        penulis,
        harga,
        rating,
        false,
        pathGambar,
        namaToko,
      ),
    );
  }

  // Inti Komponen Buku
  Widget _buildKontenCard(
    String judul,
    String penulis,
    String harga,
    String rating,
    bool isFavorite,
    String pathGambar,
    String namaToko,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AspectRatio(
          aspectRatio: 3 / 4,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                pathGambar,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey.shade300,
                    alignment: Alignment.center,
                    child: const Icon(Icons.book, color: Colors.grey, size: 40),
                  );
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                judul,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.grey,
              size: 16,
            ),
          ],
        ),
        Text(
          'oleh $penulis',
          style: const TextStyle(color: Colors.grey, fontSize: 11),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          harga,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFFA23914),
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            const Icon(Icons.store, size: 12, color: Colors.grey),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                namaToko,
                style: const TextStyle(color: Colors.grey, fontSize: 10),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.star, size: 12, color: Colors.amber),
            const SizedBox(width: 2),
            Text(
              rating,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _bannerController.dispose();
    super.dispose();
  }
}
