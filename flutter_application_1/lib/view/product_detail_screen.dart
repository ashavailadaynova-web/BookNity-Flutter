import 'package:flutter/material.dart';
import '../widgets/buyer_product_card.dart';
import 'store_review_screen.dart';
import 'profile/other_profile_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Data tiruan profil penjual untuk halaman ini (Bisa disesuaikan secara dinamis nanti)
  final Map<String, dynamic> currentSeller = {
    'name': 'Toko Buku Aceng',
    'joinYear': '2020',
    'followers': '1.2k',
    'following': '340',
    'bio': 'Menyediakan buku-buku bekas berkualitas, original, dan siap kirim se-Indonesia. ✨',
    'totalTerjual': 48,
    'totalMembeli': 13,
    'penilaian': 4.9,
    'profileType': 'martin_follow_back', 
    'avatar': 'assets/images/aceng_profile.jpg',
  };

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
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Detail Buku Bekas',
          style: TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100, left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                
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
                        child: Image.asset(
                          'assets/images/laut_bercerita.jpg',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: const Color(0xFFEFEBE4),
                              child: const Icon(Icons.book, size: 50, color: Colors.grey),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Laut Bercerita',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87, height: 1.2),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Karya : Leila S. Chudori',
                            style: TextStyle(fontSize: 13, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 10),
                          
                          const Text(
                            'Rp 45.000',
                            style: TextStyle(
                              fontSize: 24, 
                              fontWeight: FontWeight.bold, 
                              color: Color(0xFFA23914), 
                            ),
                          ),
                          const SizedBox(height: 10),
                          
                          Row(
                            children: const [
                              Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                              Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                              Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                              Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                              Icon(Icons.star_half_rounded, color: Colors.amber, size: 18),
                            ],
                          ),
                          const SizedBox(height: 12),
                          
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: [
                              _buildTag('#fiksisejarah'),
                              _buildTag('#kondisimulus'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F0E6), 
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatItem('Rating Toko', '${currentSeller['penilaian']} ★'),
                      Container(width: 1, height: 25, color: Colors.grey.shade300),
                      _buildStatItem('Disukai', '193 Orang'),
                      Container(width: 1, height: 25, color: Colors.grey.shade300),
                      _buildStatItem('Stok Lapak', '1 Buku'),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
                
                TabBar(
                  controller: _tabController,
                  labelColor: const Color(0xFFA23914), 
                  unselectedLabelColor: Colors.grey.shade500,
                  indicatorColor: const Color(0xFFA23914),
                  indicatorWeight: 3,
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                  tabs: const [
                    Tab(text: 'Overview'),
                    Tab(text: 'Detail Fisik'),
                    Tab(text: 'Review Toko'),
                  ],
                ),
                
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Builder(
                    builder: (context) {
                      if (_tabController.index == 0) {
                        return Text(
                          'Buku fiksi sejarah yang sangat emosional karya Leila S. Chudori. Menceritakan tentang penculikan aktivis di era Orde Baru dari sudut pandang keluarga dan sahabat yang ditinggalkan.\n\nAlur ceritanya membawa kita kembali ke masa-masa perjuangan reformasi yang penuh ketegangan sekaligus menyentuh hati di setiap lembarnya.',
                          style: TextStyle(fontSize: 14, color: Colors.grey.shade800, height: 1.6),
                        );
                      } else if (_tabController.index == 1) {
                        return Text(
                          '• Kondisi Halaman: Lengkap, tidak ada yang robek atau hilang.\n• Sampul: Original Softcover (masih mulus, tidak kusut).\n• Coretan: Bersih tanpa highlight atau tulisan tangan.\n• Catatan Penjual: Disimpan dalam plastik pembungkus rapi.',
                          style: TextStyle(fontSize: 14, color: Colors.grey.shade800, height: 1.6),
                        );
                      } else {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const StoreReviewScreen()),
                            );
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildReviewItem('Rian H.', '5.0 ★', 'Toko Buku Aceng pelayanannya top! Tiap beli buku bekas di sini deskripsinya jujur banget sesuai kondisi asli, dapet bonus pembatas buku juga.'),
                                const SizedBox(height: 14),
                                _buildReviewItem('Siti_Nabila', '4.8 ★', 'Respon chat cepat dan ramah pas nego harga. Pengemasan bukunya aman pakai bubble wrap tebal berlapis-lapis. Sangat amanah.'),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text(
                                      'Lihat Semua Ulasan Toko',
                                      style: TextStyle(color: Color(0xFFA23914), fontWeight: FontWeight.bold, fontSize: 13),
                                    ),
                                    SizedBox(width: 4),
                                    Icon(Icons.arrow_forward_rounded, size: 16, color: Color(0xFFA23914)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
                
                const Divider(color: Color(0xFFEFEBE4), height: 32),
                
                // 5. KARTU IDENTITAS LAPAK PENJUAL
                Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.grey,
                      backgroundImage: AssetImage(currentSeller['avatar']),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentSeller['name'],
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
                          ),
                          Text(
                            'Aktif 1 jam yang lalu • Surabaya',
                            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        // Mengirim data penampung 'currentSeller' secara dinamis ke halaman profil tujuan
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OtherProfileScreen(
                              name: currentSeller['name'],
                              joinYear: currentSeller['joinYear'],
                              followers: currentSeller['followers'],
                              following: currentSeller['following'],
                              bio: currentSeller['bio'],
                              totalTerjual: currentSeller['totalTerjual'],
                              totalMembeli: currentSeller['totalMembeli'],
                              penilaian: currentSeller['penilaian'],
                              profileType: currentSeller['profileType'],
                            ),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFA23914)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
                      ),
                      child: const Text(
                        'Lihat Toko',
                        style: TextStyle(color: Color(0xFFA23914), fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Buku Serupa',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Lihat Semua',
                        style: TextStyle(color: Color(0xFFA23914), fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                
                SizedBox(
                  height: 250,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      BuyerProductCard(
                        imageUrl: 'assets/images/midnight_library.jpg',
                        title: 'The Midnight Library',
                        author: 'Matt Haig',
                        price: 'Rp 76.000',
                        rating: '4.7',
                        storeName: 'Serba Ada',
                        isFavorite: false,
                        onTap: () {},
                        onFavoriteTap: () {},
                      ),
                      const SizedBox(width: 16),
                      BuyerProductCard(
                        imageUrl: 'assets/images/hukum_perdata.jpg',
                        title: 'Hukum Perdata Internasional',
                        author: 'Dr. Ronald Saija',
                        price: 'Rp 58.000',
                        rating: '4.5',
                        storeName: 'Buku Surabaya',
                        isFavorite: true,
                        onTap: () {},
                        onFavoriteTap: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
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
                child: Row(
                  children: [
                    Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300, width: 1.5),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.chat_bubble_outline, color: Color(0xFFA23914), size: 20),
                        onPressed: () {},
                      ),
                    ),
                    const SizedBox(width: 12),

                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFA23914), width: 1.5),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          child: const Text(
                            'Tawar',
                            style: TextStyle(color: Color(0xFFA23914), fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFA23914),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Beli Langsung', 
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFECE6DA),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 11, color: Colors.grey.shade800, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
      ],
    );
  }

  Widget _buildReviewItem(String name, String rating, String comment) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
            Text(rating, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.amber)),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          comment,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 13, color: Colors.grey.shade700, height: 1.4),
        ),
      ],
    );
  }
}