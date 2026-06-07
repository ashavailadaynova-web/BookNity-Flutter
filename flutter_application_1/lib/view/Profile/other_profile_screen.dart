import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../widgets/buyer_product_card.dart';
import '../../model/book_model.dart';
import '../product_detail_screen.dart';

class ProfileProductDummy {
  final String title;
  final String author;
  final String price;
  final String rating;
  final String imageUrl;

  ProfileProductDummy({
    required this.title,
    required this.author,
    required this.price,
    required this.rating,
    required this.imageUrl,
  });
}

class OtherProfileScreen extends StatefulWidget {
  final String sellerId;
  final String name;
  final String joinYear;
  final String followers;
  final String following;
  final String bio;
  final int totalTerjual;
  final int totalMembeli;
  final double penilaian;
  final String
  profileType; // 'martin_follow_back', 'martin_following', atau 'sabian_empty'

  const OtherProfileScreen({
    super.key,
    required this.sellerId,
    required this.name,
    required this.joinYear,
    required this.followers,
    required this.following,
    required this.bio,
    required this.totalTerjual,
    required this.totalMembeli,
    required this.penilaian,
    required this.profileType,
  });

  @override
  State<OtherProfileScreen> createState() => _OtherProfileScreenState();
}

class _OtherProfileScreenState extends State<OtherProfileScreen> {
  late String currentType;

  @override
  void initState() {
    super.initState();
    currentType = widget.profileType;
  }

  Future<void> _toggleWishlist(String docId, bool currentStatus) async {
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
      backgroundColor: const Color(0xFFFDFBF7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black87,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.name,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 1. FOTO PROFIL UTAMA
            Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFF5F0E6), width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const CircleAvatar(
                  backgroundColor: Color(0xFFECE6DA),
                  backgroundImage: AssetImage(
                    'assets/images/avatar_placeholder.jpg',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 2. NAMA & TAHUN BERGABUNG
            Text(
              widget.name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Bergabung sejak ${widget.joinYear}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),

            // 3. COUNTER PENGIKUT & MENGIKUTI
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildFollowCounter(widget.followers, 'PENGIKUT'),
                Container(
                  width: 1,
                  height: 20,
                  color: Colors.grey.shade300,
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                ),
                _buildFollowCounter(widget.following, 'MENGIKUTI'),
              ],
            ),
            const SizedBox(height: 24),

            // 4. TOMBOL AKSI DINAMIS (Sesuai image_5037fe.png)
            Row(
              children: [
                Expanded(child: _buildPrimaryActionButton()),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF7A45),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'Kirim Pesan',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 5. BOX BIO BANNER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Text(
                      'BIO',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink.shade200,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const Positioned(
                    top: 0,
                    right: 0,
                    child: Icon(
                      Icons.format_quote_rounded,
                      color: Color(0xFFEFEBE4),
                      size: 36,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, right: 20),
                    child: Text(
                      widget.bio,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade800,
                        height: 1.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 6. TIGA KARTU KOTAK STATISTIK JUAL/BELI
            Row(
              children: [
                Expanded(
                  child: _buildGridStatItem(
                    Icons.menu_book_rounded,
                    '${widget.totalTerjual}',
                    'TERJUAL',
                    const Color(0xFFF5E6E1),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildGridStatItem(
                    Icons.local_fire_department_rounded,
                    '${widget.totalMembeli}',
                    'MEMBELI',
                    const Color(0xFFFBECE6),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildGridStatItem(
                    Icons.stars_rounded,
                    '${widget.penilaian}',
                    'PENILAIAN',
                    const Color(0xFFFDF0D5),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // 7. KONDISIONAL KONTEN PRODUK (Ada Barang vs Kosong)
            if (currentType == 'sabian_empty')
              _buildEmptyState()
            else
              _buildRealProductSections(),
          ],
        ),
      ),
    );
  }

  Widget _buildFollowCounter(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade500,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildPrimaryActionButton() {
    if (currentType == 'martin_follow_back') {
      return SizedBox(
        height: 44,
        child: ElevatedButton(
          onPressed: () {
            setState(() => currentType = 'martin_following');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2D2522),
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: const Text(
            'Ikuti Balik',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ),
      );
    } else if (currentType == 'martin_following') {
      return SizedBox(
        height: 44,
        child: OutlinedButton(
          onPressed: () {
            setState(() => currentType = 'martin_follow_back');
          },
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.white,
            side: BorderSide(color: Colors.grey.shade300, width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Text(
            'Mengikuti',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: Colors.grey.shade700,
            ),
          ),
        ),
      );
    } else {
      return SizedBox(
        height: 44,
        child: ElevatedButton(
          onPressed: () {
            setState(() => currentType = 'martin_following');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2D2522),
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: const Text(
            'Ikuti',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ),
      );
    }
  }

  Widget _buildGridStatItem(
    IconData icon,
    String value,
    String label,
    Color bgColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, size: 18, color: const Color(0xFFA23914)),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRealProductSections() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('books')
          .where(
            'sellerId',
            isEqualTo: widget.sellerId,
          ) // Filter buku milik penjual ini
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFA23914)),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmptyState();
        }

        // Membagi dokumen menjadi Produk Aktif dan Produk Habis secara lokal dari Stream tunggal
        final allBooks = snapshot.data!.docs;

        // Sesuaikan parameter filter status habis ('isSoldOut' atau 'status') dengan database milikmu
        final activeBooks = allBooks.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return (data['isSoldOut'] ?? false) == false;
        }).toList();

        final soldOutBooks = allBooks.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return (data['isSoldOut'] ?? false) == true;
        }).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Produk ${widget.name}'),
            const SizedBox(height: 12),
            activeBooks.isEmpty
                ? const Text(
                    'Tidak ada produk aktif.',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  )
                : _buildProductHorizontalList(activeBooks),
            const SizedBox(height: 24),
            _buildSectionHeader('Produk Habis'),
            const SizedBox(height: 12),
            soldOutBooks.isEmpty
                ? const Text(
                    'Tidak ada produk habis.',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  )
                : _buildProductHorizontalList(soldOutBooks),
          ],
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Text(
              'Items listed in the marketplace',
              style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
            ),
          ],
        ),
        TextButton(
          onPressed: () {},
          child: const Text(
            'Lihat Semua',
            style: TextStyle(
              color: Color(0xFFA23914),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductHorizontalList(List<QueryDocumentSnapshot> bookDocs) {
    return SizedBox(
      height:
          250, // Ditinggikan menjadi 250 agar BuyerProductCard tidak terpotong (Layout Error)
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: bookDocs.length,
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final doc = bookDocs[index];
          final bookData = doc.data() as Map<String, dynamic>;
          final bool currentIsFavorite = bookData['isFavorite'] ?? false;

          return SizedBox(
            width: 150, // Mengamankan batas layout card horizontal
            child: BuyerProductCard(
              imageUrl: bookData['image'] ?? 'assets/images/placeholder.jpg',
              title: bookData['title'] ?? 'Tanpa Judul',
              author: bookData['author'] ?? 'Anonim',
              price: 'Rp ${bookData['price'] ?? 0}',
              rating: bookData['rating'] != null
                  ? '${bookData['rating']}'
                  : '0.0',
              storeName: bookData['storeName'] ?? widget.name,
              isFavorite: currentIsFavorite,
              onTap: () {
                // 🟢 Membuka detail produk baru saat card diklik
                final clickedBook = BookModel.fromMap(bookData, doc.id);
                // Sesuaikan 'ProductDetailScreen' jika penamaannya berbeda di projectmu
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ProductDetailScreen(book: clickedBook),
                  ),
                );
              },
              onFavoriteTap: () async {
                // 🟢 Berfungsi langsung menyimpan status ke database wishlist
                await _toggleWishlist(doc.id, currentIsFavorite);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: const TextStyle(fontSize: 14, color: Colors.black87),
              children: [
                TextSpan(
                  text: widget.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF7A45),
                  ),
                ),
                const TextSpan(
                  text: ' Belum\nMenambahkan Produk Apapun',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Ikuti untuk tahu lebih banyak tentang akun ini',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}
