import 'package:flutter/material.dart';
// Impor halaman OtherProfileScreen sesuai dengan lokasi file di proyekmu
// import 'other_profile_screen.dart'; 

class StoreReviewScreen extends StatefulWidget {
  final String storeName;

  const StoreReviewScreen({
    super.key,
    this.storeName = 'Toko Buku Aceng',
  });

  @override
  State<StoreReviewScreen> createState() => _StoreReviewScreenState();
}

class _StoreReviewScreenState extends State<StoreReviewScreen> {
  // State untuk melacak filter mana yang sedang aktif
  String _selectedFilter = 'Semua (45)';

  // Dummy data list ulasan agar bisa disaring secara dinamis berdasarkan filter
  final List<Map<String, dynamic>> _allReviews = [
    {
      'buyerName': 'Rian H.',
      'rating': 5,
      'date': '2 hari lalu',
      'bookTitle': 'Laut Bercerita',
      'comment': 'Toko Buku Aceng pelayanannya top! Tiap beli buku bekas di sini deskripsinya jujur banget sesuai kondisi asli, dapet bonus pembatas buku juga.',
      'hasDescription': true,
    },
    {
      'buyerName': 'Siti_Nabila',
      'rating': 5,
      'date': '1 minggu lalu',
      'bookTitle': 'The Midnight Library',
      'comment': 'Respon chat cepat dan ramah pas nego harga. Pengemasan bukunya aman pakai bubble wrap tebal berlapis-lapis. Sangat amanah dan direkomendasikan buat berburu buku bekas.',
      'hasDescription': true,
    },
    {
      'buyerName': 'Budi_S',
      'rating': 4,
      'date': '3 minggu lalu',
      'bookTitle': 'Hukum Perdata Internasional',
      'comment': 'Kondisi buku lumayan mulus untuk ukuran bekas. Pengiriman agak sedikit telat dari kurirnya, tapi dari pihak penjual langsung dikemas hari itu juga. Makasih cak!',
      'hasDescription': true,
    },
    {
      'buyerName': 'Amalia Putri',
      'rating': 5,
      'date': '1 bulan lalu',
      'bookTitle': 'Bumi Manusia',
      'comment': 'Suka banget langganan di sini. Bukunya disampul plastik rapi jadi pas dateng gak ada tekukan sama sekali. Sukses terus lapaknya!',
      'hasDescription': true,
    },
  ];

  // Fungsi untuk menyaring ulasan yang ditampilkan berdasarkan chip yang dipilih
  List<Map<String, dynamic>> _getFilteredReviews() {
    if (_selectedFilter.startsWith('Bintang 5')) {
      return _allReviews.where((r) => r['rating'] == 5).toList();
    } else if (_selectedFilter.startsWith('Bintang 4')) {
      return _allReviews.where((r) => r['rating'] == 4).toList();
    } else if (_selectedFilter.startsWith('Dengan Deskripsi')) {
      return _allReviews.where((r) => r['hasDescription'] == true).toList();
    }
    return _allReviews; // Default: Semua
  }

  @override
  Widget build(BuildContext context) {
    final filteredReviews = _getFilteredReviews();

    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF7), // Background cream hangat Booknity
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Ulasan ${widget.storeName}',
          style: const TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. RINGKASAN RATING & GRAFIK BINTANG
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F0E6),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  // Angka Rating Utama
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        '4.9',
                        style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      const Text(
                        'dari 5',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: const [
                          Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                          Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                          Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                          Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                          Icon(Icons.star_half_rounded, color: Colors.amber, size: 16),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '45 Ulasan',
                        style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(width: 24),
                  
                  // Progress Bar Distribusi Rating Bintang
                  Expanded(
                    child: Column(
                      children: [
                        _buildRatingBar('5', 0.85),
                        _buildRatingBar('4', 0.10),
                        _buildRatingBar('3', 0.03),
                        _buildRatingBar('2', 0.01),
                        _buildRatingBar('1', 0.01),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),

            // 2. FILTER TAGS (Bisa Diklik dan Mengubah State)
            SizedBox(
              height: 35,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildFilterChip('Semua (45)'),
                  _buildFilterChip('Bintang 5 (38)'),
                  _buildFilterChip('Dengan Deskripsi (12)'),
                  _buildFilterChip('Bintang 4 (5)'),
                ],
              ),
            ),

            const SizedBox(height: 16),
            const Divider(color: Color(0xFFEFEBE4), height: 20),

            // 3. DAFTAR ULASAN PEMBELI (Dinamis Sesuai Filter)
            filteredReviews.isEmpty
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    child: Center(child: Text('Tidak ada ulasan untuk filter ini.')),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredReviews.length,
                    itemBuilder: (context, index) {
                      final review = filteredReviews[index];
                      return _buildBuyerReview(
                        context,
                        buyerName: review['buyerName'],
                        rating: review['rating'],
                        date: review['date'],
                        bookTitle: review['bookTitle'],
                        comment: review['comment'],
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }

  // Widget Helper: Bar Distribusi Rating (Warna Bintang diubah ke Amber)
  Widget _buildRatingBar(String starNumber, double percentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            starNumber,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black54),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.star_rounded, color: Colors.amber, size: 12), // Menggunakan Colors.amber agar serasi
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percentage,
                backgroundColor: Colors.grey.shade300,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
                minHeight: 6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget Helper: Tombol Filter Chips Interaktif
  Widget _buildFilterChip(String text) {
    final isActive = _selectedFilter == text;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = text;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFA23914) : const Color(0xFFECE6DA),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
              color: isActive ? Colors.white : Colors.grey.shade800,
            ),
          ),
        ),
      ),
    );
  }

  // Widget Helper: Item Komponen Ulasan Pembeli dengan InkWell Navigasi
  Widget _buildBuyerReview(
    BuildContext context, {
    required String buyerName,
    required int rating,
    required String date,
    required String bookTitle,
    required String comment,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // InkWell membungkus profil pembeli agar bisa diklik menuju halaman profil lain
              InkWell(
                onTap: () {
                  // Hapus tanda komentar di bawah jika OtherProfileScreen sudah siap digunakan
                  /*
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OtherProfileScreen(
                        name: buyerName,
                        profileType: 'buyer_empty',
                        joinYear: '2024',
                        followers: '5',
                        following: '20',
                        bio: 'Pencinta Buku Bekas Berkualitas',
                        totalTerjual: 0,
                        totalMembeli: 15,
                        penilaian: 0,
                      ),
                    ),
                  );
                  */
                  // ScaffoldMessenger sementara untuk testing klik
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Menuju ke profil $buyerName'), duration: const Duration(seconds: 1)),
                  );
                },
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 14,
                        backgroundColor: const Color(0xFFECE6DA),
                        child: Text(
                          buyerName[0].toUpperCase(),
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFFA23914)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        buyerName,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ),
              Text(
                date,
                style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: List.generate(
              5,
              (index) => Icon(
                Icons.star_rounded,
                color: index < rating ? Colors.amber : Colors.grey.shade300,
                size: 16,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Membeli: $bookTitle',
            style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: Color(0xFFA23914)),
          ),
          const SizedBox(height: 6),
          Text(
            comment,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade800, height: 1.5),
          ),
          const SizedBox(height: 12),
          const Divider(color: Color(0xFFEFEBE4), height: 1),
        ],
      ),
    );
  }
}