import 'package:flutter/material.dart';
import '../../widgets/buyer_product_card.dart';

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
  final String name;
  final String joinYear;
  final String followers;
  final String following;
  final String bio;
  final int totalTerjual;
  final int totalMembeli;
  final double penilaian;
  final String profileType; // 'martin_follow_back', 'martin_following', atau 'sabian_empty'

  const OtherProfileScreen({
    super.key,
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

  final List<ProfileProductDummy> activeProducts = [
    ProfileProductDummy(
      title: 'Animal Farm',
      author: 'George Orwell',
      price: 'Rp. 47.000',
      rating: '4.8',
      imageUrl: 'assets/images/animal_farm.jpg',
    ),
    ProfileProductDummy(
      title: 'Pergi',
      author: 'Tere Liye',
      price: 'Rp. 58.000',
      rating: '4.7',
      imageUrl: 'assets/images/pergi.jpg',
    ),
  ];

  final List<ProfileProductDummy> soldOutProducts = [
    ProfileProductDummy(
      title: 'Laut Bercerita',
      author: 'Leila S. Chudori',
      price: 'Rp. 60.000',
      rating: '4.7',
      imageUrl: 'assets/images/laut_bercerita.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.name,
          style: const TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold),
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
                    )
                  ],
                ),
                child: const CircleAvatar(
                  backgroundColor: Color(0xFFECE6DA),
                  backgroundImage: AssetImage('assets/images/avatar_placeholder.jpg'),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 2. NAMA & TAHUN BERGABUNG
            Text(
              widget.name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 4),
            Text(
              'Bergabung sejak ${widget.joinYear}',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),

            // 3. COUNTER PENGIKUT & MENGIKUTI
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildFollowCounter(widget.followers, 'PENGIKUT'),
                Container(width: 1, height: 20, color: Colors.grey.shade300, margin: const EdgeInsets.symmetric(horizontal: 24)),
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
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      child: const Text('Kirim Pesan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
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
                  )
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Text('BIO', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.pink.shade200, letterSpacing: 1)),
                  ),
                  const Positioned(
                    top: 0,
                    right: 0,
                    child: Icon(Icons.format_quote_rounded, color: Color(0xFFEFEBE4), size: 36),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, right: 20),
                    child: Text(
                      widget.bio,
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade800, height: 1.5, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 6. TIGA KARTU KOTAK STATISTIK JUAL/BELI
            Row(
              children: [
                Expanded(child: _buildGridStatItem(Icons.menu_book_rounded, '${widget.totalTerjual}', 'TERJUAL', const Color(0xFFF5E6E1))),
                const SizedBox(width: 10),
                Expanded(child: _buildGridStatItem(Icons.local_fire_department_rounded, '${widget.totalMembeli}', 'MEMBELI', const Color(0xFFFBECE6))),
                const SizedBox(width: 10),
                Expanded(child: _buildGridStatItem(Icons.stars_rounded, '${widget.penilaian}', 'PENILAIAN', const Color(0xFFFDF0D5))),
              ],
            ),
            const SizedBox(height: 32),

            // 7. KONDISIONAL KONTEN PRODUK (Ada Barang vs Kosong)
            if (currentType == 'sabian_empty') _buildEmptyState() else _buildProductSections(),
          ],
        ),
      ),
    );
  }

  Widget _buildFollowCounter(String count, String label) {
    return Column(
      children: [
        Text(count, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade500, letterSpacing: 0.5)),
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          child: const Text('Ikuti Balik', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          child: Text('Mengikuti', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey.shade700)),
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          child: const Text('Ikuti', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        ),
      );
    }
  }

  Widget _buildGridStatItem(IconData icon, String value, String label, Color bgColor) {
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
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey.shade600)),
        ],
      ),
    );
  }

  Widget _buildProductSections() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Produk ${widget.name}'),
        const SizedBox(height: 12),
        _buildProductHorizontalList(activeProducts, false),
        const SizedBox(height: 24),
        _buildSectionHeader('Produk Habis'),
        const SizedBox(height: 12),
        _buildProductHorizontalList(soldOutProducts, true),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87)),
            Text('Items listed in the marketplace', style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
          ],
        ),
        TextButton(
          onPressed: () {},
          child: const Text('Lihat Semua', style: TextStyle(color: Color(0xFFA23914), fontSize: 12, fontWeight: FontWeight.bold)),
        )
      ],
    );
  }

  Widget _buildProductHorizontalList(List<ProfileProductDummy> products, bool isSoldOut) {
    return SizedBox(
      height: 210,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        itemBuilder: (context, index) {
          final item = products[index];
          return Container(
            width: 140,
            margin: const EdgeInsets.only(right: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      height: 140,
                      width: 140,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFEBE4),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: ColorFiltered(
                          colorFilter: isSoldOut 
                              ? ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.dstATop) 
                              : const ColorFilter.mode(Colors.transparent, BlendMode.dst),
                          child: const Icon(Icons.book, size: 40, color: Colors.grey),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: Icon(
                          isSoldOut ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          size: 14, 
                          color: isSoldOut ? Colors.red : Colors.grey,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 6),
                Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87)),
                Text('oleh ${item.author}', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
                const SizedBox(height: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(item.price, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFA23914))),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, color: Colors.amber, size: 12),
                        const SizedBox(width: 2),
                        Text(item.rating, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black54)),
                      ],
                    )
                  ],
                )
              ],
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
                TextSpan(text: widget.name, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFF7A45))),
                const TextSpan(text: ' Belum\nMenambahkan Produk Apapun', style: TextStyle(fontWeight: FontWeight.bold)),
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