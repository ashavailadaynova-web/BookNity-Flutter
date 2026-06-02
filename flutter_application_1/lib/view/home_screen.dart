import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  int _selectedTab = 0;
  int _selectedKategori = 0;

  final PageController _bannerController = PageController();
  int _currentBanner = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Konten Utama yang bisa di-scroll
            SingleChildScrollView(
              padding: const EdgeInsets.only(
                bottom: 100,
              ), // Kasih space agar gak tertutup bottom bar
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
            // Floating Bottom Navigation Bar Custom
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildCustomBottomNavBar(),
            ),
          ],
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
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(
              Icons.chat_bubble_outline,
              color: Color(0xFF4A2E2B),
            ),
            onPressed: () {},
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
          CircleAvatar(
            backgroundColor: const Color(0xFF5C3826),
            child: const Icon(Icons.search, color: Colors.white),
          ),
        ],
      ),
    );
  }

  // 3. Banner Promo Slider (Murni Menggunakan File Gambar dari Asset)
  Widget _buildBannerSlider() {
    // 📝 Tinggal isi dengan list jalur file gambar banner kelompokmu yang ada di folder assets
    List<String> bannerImages = [
      'assets/promo_summer.png', // Ganti dengan nama file banner 1 kamu
      'assets/promo_komik.png', // Ganti dengan nama file banner 2 kamu
      'assets/promo_member.png', // Ganti dengan nama file banner 3 kamu
    ];

    return Column(
      children: [
        // Wadah PageView untuk Geser Banner
        SizedBox(
          height: 150, // Kamu bisa atur tinggi sesuai proporsi gambar bannermu
          child: PageView.builder(
            controller: _bannerController,
            itemCount: bannerImages.length,
            onPageChanged: (index) {
              setState(() {
                _currentBanner =
                    index; // Update posisi titik indikator di bawah
              });
            },
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                // ClipRRect dipasang agar pojok gambar ikut melengkung rapi (rounded) mengikuti container
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    bannerImages[index],
                    fit: BoxFit
                        .cover, // Gambar otomatis memenuhi seluruh area banner dengan rapi
                    // Menangani cadangan kalau file gambarnya belum ada/salah ketik biar gak crash merah
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

        // Titik-Titik Indikator (Dots) di bawah banner
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
                    ? const Color(0xFFA23914) // Warna cokelat/oranye aktif
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
        'color': const Color(0xFF3E2723), // Lingkaran Cokelat Tua
        'iconColor': Colors.white, // Ikon Putih
      },
      {
        'nama': 'FIKSI',
        'icon': Icons.menu_book,
        'color': const Color(0xFFFFCDD2), // Lingkaran Merah Muda Pastel
        'iconColor': const Color(0xFFE53935), // Ikon Merah Tegas
      },
      {
        'nama': 'SENI/HOBI',
        'icon': Icons.palette,
        'color': const Color(0xFFFFE0B2), // Lingkaran Oranye Pastel
        'iconColor': const Color(0xFFEF6C00), // Ikon Oranye Tegas
      },
      {
        'nama': 'KOMIK',
        'icon': Icons.sentiment_satisfied,
        'color': const Color(0xFFFFF9C4), // Lingkaran Kuning Pastel
        'iconColor': const Color(0xFFF57F17), // Ikon Kuning Pekat
      },
      {
        'nama': 'SEKOLAH',
        'icon': Icons.school,
        'color': const Color(0xFFC8E6C9), // Lingkaran Hijau Pastel
        'iconColor': const Color(0xFF2E7D32), // Ikon Hijau Tegas
      },
      {
        'nama': 'SEJARAH',
        'icon': Icons.gavel, // Ganti sesuai kebutuhan ikon sejarah kelompokmu
        'color': const Color(0xFFE3F2FD), // Lingkaran Biru Pastel
        'iconColor': const Color(0xFF1565C0), // Ikon Biru Tegas
      },
      {
        'nama': 'MASAKAN',
        'icon': Icons.restaurant, // Ikon sendok garpu / restoran
        'color': const Color(0xFFFCE4EC), // Pink pastel sangat muda
        'iconColor': const Color(0xFFD81B60), // Pink/merah tua tegas
      },
      {
        'nama': 'SELF-HELP',
        'icon': Icons
            .self_improvement, // Ikon meditasi/yoga (pas banget buat self-help)
        'color': const Color(0xFFF3E5F5), // Ungu pastel sangat muda
        'iconColor': const Color(0xFF8E24AA), // Ungu tegas
      },
      {
        'nama': 'ANAK-ANAK',
        'icon': Icons
            .child_care, // Ikon mainan mobil/anak-anak (bisa juga Icons.toys atau Icons.child_care)
        'color': const Color(0xFFFFFDE7), // Kuning pastel cerah
        'iconColor': const Color(0xFFF57F17), // Oranye/kuning tua pekat
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
              return Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor:
                          kategori[index]['color'], // Warna background dari list
                      child: Icon(
                        kategori[index]['icon'],
                        color:
                            kategori[index]['iconColor'], // Warna ikon langsung dari list
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
          height:
              280, // 🟢 DIUBAH KE 280: Memberikan ruang vertikal yang sangat lega agar teks toko & rating tidak jebol
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

  // 6. Tab Rekomendasi Untukmu (Bisa Diklik)
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
              // ✨ Cek apakah indeks tab ini yang sedang dipilih
              bool isSelected = _selectedTab == index;

              return GestureDetector(
                onTap: () {
                  // ✨ Mengubah state dan memperbarui tampilan saat tab diklik
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
                        ? const Color(
                            0xFFA23914,
                          ) // Warna Oranye/Cokelat jika aktif
                        : const Color(
                            0xFFF5F5F5,
                          ), // Warna Abu-abu jika tidak aktif
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

  // 7. Daftar Buku Rekomendasi (Sekarang Rapi Menggunakan Wrap, Bebas Peyang)
  Widget _buildDaftarBukuRekomendasi() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Align(
        alignment: Alignment
            .topLeft, // Mengunci barisan buku tetap rapi di sisi kiri layar
        child: Wrap(
          spacing: 16, // Jarak horizontal antar buku
          runSpacing: 16, // Jarak vertikal ke bawah
          children: [
            _buildCardBukuVertikal(
              'The Midnight Library',
              'Matt Haig',
              'Rp. 76.000',
              '4.7',
              'Serba Ada',
              'assets/midnight_library.png', // ⚠️ PASTIKAN nama file ini sama persis dengan di foldermu
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
              'assets/coding_paud.png', // ⚠️ PASTIKAN nama file ini sama persis dengan di foldermu
            ),
            _buildCardBukuVertikal(
              'Project Hail Mary',
              'Andy Weir',
              'Rp. 58.000',
              '4.7',
              'Rumahnya Buku',
              'assets/hail_mary.png', // ⚠️ PASTIKAN nama file ini sama persis dengan di foldermu
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
      width: 140, // Lebar card dikunci rapi
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
      width: 140, // Lebar disamakan persis dengan yang atas
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

  // Inti Komponen Buku (Anti Overflow & Ukuran Gambar Kembar)
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
      mainAxisSize: MainAxisSize
          .min, // Mengikuti tinggi konten secara alami biar gak overflow
      children: [
        // Kotak Gambar Buku (Rasio 3:4 yang sangat pas untuk sampul novel)
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
                // Mengatasi jika ada salah ketik nama file di kode agar tidak silang merah/crash
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
        // Judul & Favorit
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
        // Penulis
        Text(
          'oleh $penulis',
          style: const TextStyle(color: Colors.grey, fontSize: 11),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        // Harga
        Text(
          harga,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFFA23914),
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 2),
        // Toko & Rating
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

  // Custom Bottom Navigation Bar dengan lengkungan di tengah
  Widget _buildCustomBottomNavBar() {
    return SizedBox(
      height: 80,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 65,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(Icons.home, 'HOME', 0),
                  _buildNavItem(Icons.assignment, 'MY ORDER', 1),
                  const SizedBox(
                    width: 40,
                  ), // Space kosong untuk tombol + melayang
                  _buildNavItem(Icons.notifications, 'NOTIFIKASI', 2),
                  _buildNavItem(Icons.person, 'PROFIL', 3),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: FloatingActionButton(
              backgroundColor: const Color(0xFFA23914),
              shape: const CircleBorder(),
              onPressed: () {},
              child: const Icon(Icons.add, color: Colors.white, size: 30),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? const Color(0xFFA23914) : Colors.black54,
            size: 24,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: isSelected ? const Color(0xFFA23914) : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _bannerController
        .dispose(); // Matikan controller saat halaman tidak dipakai
    super.dispose();
  }
}
