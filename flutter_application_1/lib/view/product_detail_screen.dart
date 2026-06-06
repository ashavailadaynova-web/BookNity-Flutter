import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Untuk TextInputFormatter
import 'package:provider/provider.dart';
import '../widgets/buyer_product_card.dart';
import 'store_review_screen.dart';
import 'profile/other_profile_screen.dart';
import '../../model/book_model.dart';
import '../../viewmodel/chat_viewmodel.dart';
// import 'chat_room_screen.dart'; // Sesuaikan lokasi file ChatRoomScreen kamu

class ProductDetailScreen extends StatefulWidget {
  final BookModel book;

  const ProductDetailScreen({super.key, required this.book});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final Map<String, dynamic> currentSeller = {
    'name': 'Toko Buku Aceng',
    'joinYear': '2020',
    'followers': '1.2k',
    'following': '340',
    'bio':
        'Menyediakan buku-buku bekas berkualitas, original, dan siap kirim se-Indonesia. ✨',
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

  // 🔴 FUNGSI VALIDASI DAN POP-UP TAWAR HARGA (Max 10%)
  void _showBargainDialog(BuildContext context) {
    // Parsing harga dari string (Contoh "Rp 45.000" diambil angka idr-nya saja)
    final cleanedPriceStr = widget.book.price.replaceAll(RegExp(r'[^0-9]'), '');
    final double originalPrice = double.tryParse(cleanedPriceStr) ?? 0.0;

    // Batas minimum harga tawar pembeli = Original dikurangi 10% (Alias 90% dari harga asli)
    final double minBargainPrice = originalPrice * 0.9;

    final TextEditingController bargainController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Tawar Harga Buku',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Harga Asli: ${widget.book.price}",
                  style: const TextStyle(color: Colors.grey),
                ),
                Text(
                  "Batas Tawar Maksimal (10%): Rp ${minBargainPrice.toInt().toString()}",
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: bargainController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    prefixText: 'Rp ',
                    hintText: 'Masukkan harga tawaranmu',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Harga tawar tidak boleh kosong';
                    }
                    final inputPrice = double.tryParse(value) ?? 0.0;
                    if (inputPrice < minBargainPrice) {
                      return 'Tawaran terlalu rendah (Maksimal 10%)';
                    }
                    if (inputPrice > originalPrice) {
                      return 'Harga tawar tidak boleh melebihi harga asli';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  // Panggil viewmodel tanpa listen: false untuk menghindari context error luar scope build
                  final chatVM = Provider.of<ChatViewModel>(
                    context,
                    listen: false,
                  );

                  // Kirim kartu chat penawaran otomatis
                  chatVM.sendOfferMessage(
                    book: widget.book,
                    offeredPrice: "Rp ${bargainController.text}",
                  );

                  Navigator.pop(context); // Tutup dialog

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Tawaran berhasil dikirim ke Chat!'),
                    ),
                  );

                  // Pindah ke halaman chat room langsung (opsional)
                  // Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatRoomScreen()));
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFA23914),
              ),
              child: const Text('Tawar', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
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
                            widget.book.price,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFA23914),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: const [
                              Icon(
                                Icons.star_rounded,
                                color: Colors.amber,
                                size: 18,
                              ),
                              Icon(
                                Icons.star_rounded,
                                color: Colors.amber,
                                size: 18,
                              ),
                              Icon(
                                Icons.star_rounded,
                                color: Colors.amber,
                                size: 18,
                              ),
                              Icon(
                                Icons.star_rounded,
                                color: Colors.amber,
                                size: 18,
                              ),
                              Icon(
                                Icons.star_half_rounded,
                                color: Colors.amber,
                                size: 18,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),
                // TabBar, Overview, Detail Fisik, dll (Bisa tetap disesuaikan dengan kode aslimu)
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
                        'Rating Toko',
                        '${currentSeller['penilaian']} ★',
                      ),
                      Container(
                        width: 1,
                        height: 25,
                        color: Colors.grey.shade300,
                      ),
                      _buildStatItem('Disukai', '193 Orang'),
                      Container(
                        width: 1,
                        height: 25,
                        color: Colors.grey.shade300,
                      ),
                      _buildStatItem('Stok Lapak', '1 Buku'),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  widget.book.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade800,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),

          // 🟢 BOTTOM ACTION BAR DENGAN TOMBOL INTERAKTIF (ANTI-ERROR)
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
                    // 1. ICON CHAT ALA SHOPEE (Kirim Teks + Sangkutkan Informasi Buku)
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
                          final chatVM = Provider.of<ChatViewModel>(
                            context,
                            listen: false,
                          );
                          // Trigger info produk otomatis masuk ke ruang chat
                          chatVM.sendMessage(
                            text: "",
                            attachedBook: widget.book,
                            isProductInfo: true,
                          );

                          // Navigasi ke ChatRoomScreen-mu
                          // Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatRoomScreen()));
                        },
                      ),
                    ),
                    const SizedBox(width: 12),

                    // 2. TOMBOL TAWAR HARGA
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: OutlinedButton(
                          onPressed: () => _showBargainDialog(context),
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

                    // 3. TOMBOL BELI LANGSUNG
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {},
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
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
