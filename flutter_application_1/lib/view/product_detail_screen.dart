import 'package:flutter/material.dart';
import '../widgets/buyer_product_card.dart';
import 'store_review_screen.dart';
import 'profile/other_profile_screen.dart';
import '../../model/book_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../view/add_offer_screen.dart';
import '../view/chat_room_screen.dart';
import 'Pesanan/payment_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final BookModel book;

  const ProductDetailScreen({super.key, required this.book});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
        title: const Text(
          'Detail Buku Bekas',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 1. AREA KONTEN (Bisa di-scroll)
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // AREA HERO: FOTO & DETAIL INFORMASI UTAMA BUKU
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 130,
                        height: 185,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: widget.book.image.startsWith('http')
                              ? Image.network(
                                  widget.book.image,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      _buildImagePlaceholder(),
                                )
                              : Image.asset(
                                  widget.book.image,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      _buildImagePlaceholder(),
                                ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.book.title,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Karya : ${widget.book.author}',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              widget.book.price.startsWith('Rp')
                                  ? widget.book.price
                                  : 'Rp ${widget.book.price}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFA23914),
                              ),
                            ),
                            const SizedBox(height: 10),

                            // RATING BINTANG
                            Row(
                              children: List.generate(5, (index) {
                                return Icon(
                                  index < widget.book.rating.floor()
                                      ? Icons.star_rounded
                                      : (index < widget.book.rating &&
                                              widget.book.rating % 1 != 0)
                                          ? Icons.star_half_rounded
                                          : Icons.star_outline_rounded,
                                  color: Colors.amber,
                                  size: 18,
                                );
                              }),
                            ),
                            const SizedBox(height: 12),

                            // HASHTAGS
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: [
                                if (widget.book.category.isNotEmpty)
                                  _buildTag(
                                    '#${widget.book.category.toLowerCase().replaceAll(' ', '')}',
                                  ),
                                if (widget.book.condition.isNotEmpty)
                                  _buildTag(
                                    '#kondisi${widget.book.condition.toLowerCase()}',
                                  ),
                                if (widget.book.year.isNotEmpty)
                                  _buildTag('#th${widget.book.year}'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // BOX STATISTIK PRODUK
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F0E6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatItem(
                          'Rating Buku',
                          '${widget.book.rating} ★',
                        ),
                        Container(
                          width: 1,
                          height: 25,
                          color: Colors.grey.shade300,
                        ),
                        _buildStatItem('Disukai', '${widget.book.likes} Orang'),
                        Container(
                          width: 1,
                          height: 25,
                          color: Colors.grey.shade300,
                        ),
                        _buildStatItem(
                          'Stok Lapak',
                          '${widget.book.stock} Buku',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // WIDGET TABBAR
                  TabBar(
                    controller: _tabController,
                    labelColor: const Color(0xFFA23914),
                    unselectedLabelColor: Colors.grey.shade500,
                    indicatorColor: const Color(0xFFA23914),
                    indicatorWeight: 3,
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    tabs: const [
                      Tab(text: 'Overview'),
                      Tab(text: 'Detail Fisik'),
                      Tab(text: 'Review Toko'),
                    ],
                  ),

                  // KONTEN TABBAR
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: AnimatedBuilder(
                      animation: _tabController,
                      builder: (context, child) {
                        if (_tabController.index == 0) {
                          return Text(
                            widget.book.description.isNotEmpty
                                ? widget.book.description
                                : 'Tidak ada deskripsi untuk buku ini.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade800,
                              height: 1.6,
                            ),
                          );
                        } else if (_tabController.index == 1) {
                          return Text(
                            widget.book.physicalDetail ??
                                '• Kondisi Buku: ${widget.book.condition}\n• Tahun Terbit: ${widget.book.year.isNotEmpty ? widget.book.year : '-'}\n• No. ISBN: ${widget.book.isbn.isNotEmpty ? widget.book.isbn : '-'}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade800,
                              height: 1.6,
                            ),
                          );
                        } else {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const StoreReviewScreen(),
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('reviews')
                                    .where(
                                      'sellerId',
                                      isEqualTo: widget.book.sellerId,
                                    )
                                    .limit(2)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: CircularProgressIndicator(
                                        color: Color(0xFFA23914),
                                      ),
                                    );
                                  }
                                  if (!snapshot.hasData ||
                                      snapshot.data!.docs.isEmpty) {
                                    return const Center(
                                      child: Text(
                                        'Belum ada ulasan dari pembeli',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontStyle: FontStyle.italic,
                                          fontSize: 14,
                                        ),
                                      ),
                                    );
                                  }
                                  final storeReviews = snapshot.data!.docs;
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: storeReviews.map((doc) {
                                      final rev =
                                          doc.data() as Map<String, dynamic>;
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 14,
                                        ),
                                        child: _buildReviewItem(
                                          rev['reviewerName'] ?? 'Pembeli',
                                          '${rev['rating'] ?? 5.0} ★',
                                          rev['comment'] ?? '',
                                        ),
                                      );
                                    }).toList(),
                                  );
                                },
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),

                  const Divider(color: Color(0xFFEFEBE4), height: 32),

                  // IDENTITAS LAPAK PENJUAL
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.grey.shade300,
                        backgroundImage: widget.book.sellerAvatar.startsWith('http')
                            ? NetworkImage(widget.book.sellerAvatar)
                            : (widget.book.sellerAvatar.isNotEmpty
                                ? AssetImage(widget.book.sellerAvatar)
                                : const AssetImage(
                                    'assets/images/default_avatar.png',
                                  )) as ImageProvider,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.book.storeName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              '${widget.book.sellerCity}',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () async {
                          final sId = widget.book.sellerId;
                          if (sId.trim().isEmpty) {
                            _showSnackBar(
                              context,
                              'Gagal melihat toko: ID Penjual tidak valid.',
                            );
                            return;
                          }

                          _showLoadingDialog(context);
                          try {
                            DocumentSnapshot sellerDoc = await FirebaseFirestore
                                .instance
                                .collection('users')
                                .doc(sId)
                                .get();

                            if (context.mounted) Navigator.pop(context);

                            if (sellerDoc.exists && context.mounted) {
                              Map<String, dynamic> sellerData =
                                  sellerDoc.data() as Map<String, dynamic>;

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OtherProfileScreen(
                                    name:
                                        sellerData['name'] ??
                                        sellerData['username'] ??
                                        widget
                                            .book
                                            .storeName, // Tambahkan fallback username
                                    joinYear: sellerData['joinYear'] ?? '2024',
                                    followers:
                                        '${sellerData['followers'] ?? 0}',
                                    following:
                                        '${sellerData['following'] ?? 0}',
                                    bio:
                                        sellerData['bio'] ??
                                        'Belum ada biodata toko.',
                                    totalTerjual: sellerData['totalTerjual'] ?? 0,
                                    totalMembeli: sellerData['totalMembeli'] ?? 0,
                                    penilaian: sellerData['rating'] != null
                                        ? (sellerData['rating'] as num)
                                            .toDouble()
                                        : widget.book.rating,
                                    profileType: sellerData['profileType'] ?? 'seller',
                                  ),
                                ),
                              );
                            } else if (context.mounted) {
                              _showSnackBar(
                                context,
                                'Profil penjual tidak ditemukan!',
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              Navigator.pop(context);
                              _showSnackBar(context, 'Gagal memuat profil: $e');
                            }
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFA23914)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                        ),
                        child: const Text(
                          'Lihat Toko',
                          style: TextStyle(
                            color: Color(0xFFA23914),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // AREA BUKU SERUBA
                  const Row(
                    children: [
                      Text(
                        'Buku Serupa',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  SizedBox(
                    height: 250,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('books')
                          .where('category', isEqualTo: widget.book.category)
                          .limit(
                            11,
                          ) // Ambil 11 data (karena 1 data akan dibuang jika itu buku yang sedang dibuka)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          print(
                            "Jumlah buku kategori ${widget.book.category} yang ditemukan: ${snapshot.data!.docs.length}",
                          );
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFFA23914),
                            ),
                          );
                        }
                        if (snapshot.hasError) {
                          return const Center(
                            child: Text('Gagal memuat rekomendasi buku.'),
                          );
                        }
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Center(
                            child: Text(
                              'Tidak ada buku lain di kategori ini.',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                            ),
                          );
                        }

                        // 🟢 1. PENYELAMAT: Filter agar buku yang sedang dibuka saat ini tidak masuk daftar rekomendasi
                        final rawDocs = snapshot.data!.docs;
                        final recommendedBooks = rawDocs
                            .where((doc) => doc.id != widget.book.id)
                            .toList();

                        // Jika setelah difilter ternyata kosong (artinya di DB cuma ada 1 buku ini saja untuk kategori tersebut)
                        if (recommendedBooks.isEmpty) {
                          return const Center(
                            child: Text(
                              'Tidak ada buku serupa lainnya.',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                            ),
                          );
                        }

                        return ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: recommendedBooks.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(width: 16),
                          itemBuilder: (context, index) {
                            final bookData =
                                recommendedBooks[index].data()
                                    as Map<String, dynamic>;
                            return BuyerProductCard(
                              imageUrl:
                                  bookData['imageUrl'] ??
                                  'assets/images/placeholder.jpg',
                              title: bookData['title'] ?? 'Tanpa Judul',
                              author: bookData['author'] ?? 'Anonim',
                              price: 'Rp ${bookData['price'] ?? 0}',
                              rating: '${bookData['rating'] ?? 0.0}',
                              storeName: bookData['storeName'] ?? 'Toko Buku',
                              isFavorite: bookData['isFavorite'] ?? false,
                              onTap: () {},
                              onFavoriteTap: () {},
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. FIXED BOTTOM BAR (Selalu nempel di paling bawah screen)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.chat_bubble_outline,
                        color: Color(0xFFA23914),
                        size: 20,
                      ),
                      onPressed: () {
                        final currentUser = FirebaseAuth.instance.currentUser;

                        if (currentUser == null) {
                          _showSnackBar(
                            context,
                            'Silakan login terlebih dahulu untuk chat penjual.',
                          );
                          return;
                        }

                        final buyerId = currentUser.uid;
                        final sellerId = widget.book.sellerId;

                        if (buyerId == sellerId) {
                          _showSnackBar(
                            context,
                            'Ini adalah buku Anda sendiri.',
                          );
                          return;
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ChatRoomScreen(sellerId: sellerId),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: OutlinedButton(
                        onPressed: () {
                          final cleanPriceString = widget.book.price
                              .replaceAll('.', '')
                              .replaceAll(',', '');
                          final double parsedPrice =
                              double.tryParse(cleanPriceString) ?? 0.0;

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OfferScreen(
                                    productId: widget.book.id ?? '',
                                    title: widget.book.title,
                                    author: widget.book.author,
                                    imageUrl: widget.book.image,
                                    originalPrice: parsedPrice,
                                    sellerId: widget.book.sellerId,
                                  ),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: Color(0xFFA23914),
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Tawar',
                          style: TextStyle(
                            color: Color(0xFFA23914),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigasi dengan membawa objek data buku ke halaman pembayaran
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PaymentScreen(book: widget.book),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFA23914),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Beli Langsung',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}