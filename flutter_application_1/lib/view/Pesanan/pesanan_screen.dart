import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../viewmodel/pesanan_view_model.dart';
import '../../viewmodel/chat_viewmodel.dart'; 
import 'package:flutter_application_1/view/chat_room_screen.dart';

class PesananScreen extends StatefulWidget {
  const PesananScreen({super.key});

  @override
  State<PesananScreen> createState() => _PesananScreenState();
}

class _PesananScreenState extends State<PesananScreen> 
 with SingleTickerProviderStateMixin {
   bool isSellerView = false;
  late PesananViewModel _pesananController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _pesananController = Provider.of<PesananViewModel>(context);
  }

  void _bukaUlasanBottomSheet(String title, String author, String image, String sellerId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _LokalUlasanBottomSheet(
        bookTitle: title,
        bookAuthor: author,
        bookImage: image,
        targetSellerId: sellerId,
        controller: _pesananController,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        backgroundColor: const Color(0xFFFFFDF2),
        appBar: AppBar(
          backgroundColor: const Color(0xFFFFFDF2),
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Center(
            child: Text(
              'Pesanan Saya',
              style: GoogleFonts.montserrat(color: const Color(0xFF42210B), fontWeight: FontWeight.w700, fontSize: 16),
            ),
          ),
          bottom: TabBar(
            indicatorColor: const Color(0xFFC76E2E),
            labelColor: const Color(0xFF42210B),
            unselectedLabelColor: const Color(0xFF8C8C8C),
            labelStyle: GoogleFonts.montserrat(fontWeight: FontWeight.w700, fontSize: 13),
            unselectedLabelStyle: GoogleFonts.montserrat(fontWeight: FontWeight.w500, fontSize: 13),
            tabs: const [
              Tab(text: 'Berlangsung'),
              Tab(text: 'Selesai'),
              Tab(text: 'Dibatalkan'),
            ],
          ),
        ),
       body: Column(
  children: [

    Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isSellerView = false;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: !isSellerView
                      ? const Color(0xFFA23914)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  "Saya Membeli",
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),

          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isSellerView = true;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSellerView
                      ? const Color(0xFFA23914)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  "Saya Menjual",
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    ),

    Expanded(
      child: TabBarView(
        children: [
          _buildBerlangsungTab(),
          _buildSelesaiTab(),
          _buildDibatalkanTab(),
        ],
      ),
    ),
  ],
),
      ),
    );
  }

  // ======================================================================
  // TAB 1: BERLANGSUNG
  // ======================================================================
  Widget _buildBerlangsungTab() {
    final String myId = FirebaseAuth.instance.currentUser?.uid ?? "";
    final chatVm = Provider.of<ChatViewModel>(context, listen: false);

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('orders')
          .where(
            isSellerView
                ? 'sellerId'
                : 'buyerId',
            isEqualTo: myId,
          )
          .where('statusPesanan', whereIn: ['disetujui', 'menunggu_konfirmasi', 'dikemas', 'dikirim'])
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFFC76E2E)));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('Belum ada pesanan berlangsung.', style: GoogleFonts.montserrat(color: Colors.grey, fontSize: 13)));
        }

        final orders = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.all(20.0),
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final docId = orders[index].id;
            final item = orders[index].data() as Map<String, dynamic>;
            final String statusStr = item['statusPesanan'] ?? 'disetujui';
           
            // ==========================================================
            // KODE SAKTI: PINDAHKAN MATA KE TERMINAL VS CODE UNTUK MELIHAT INI
            // ==========================================================
            print("DEBUG DATA ORDERAN TAB BERLANGSUNG -> $item");
            
            // Mencoba mengambil dari berbagai kemungkinan nama field database kamu
            final String sellerId = item['sellerId '] ?? item['sellerId'] ?? '';
            final String roomId = item['roomId'] ?? chatVm.getRoomId(myId, sellerId);

            return Container(
              margin: const EdgeInsets.only(bottom: 15),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 6)],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      _buildBookCover(item['cover'] ?? ''),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['bookTitle'] ?? '',
                              style: GoogleFonts.montserrat(fontWeight: FontWeight.w700, fontSize: 14, color: const Color(0xFF42210B)),
                            ),
                            Text(item['author'] ?? '', style: GoogleFonts.montserrat(fontSize: 11, color: Colors.grey)),
                            const SizedBox(height: 6),
                            Text("Rp ${item['price'] ?? ''}", style: GoogleFonts.montserrat(fontSize: 13, fontWeight: FontWeight.w700, color: const Color(0xFF261206))),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                              decoration: BoxDecoration(
                                color: _getStatusColor(statusStr).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Text(
                                statusStr.replaceAll("_", " ").toUpperCase(),
                                style: GoogleFonts.montserrat(fontSize: 10, fontWeight: FontWeight.w700, color: _getStatusColor(statusStr)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: Color(0xFFEFEFEF), height: 20),
                 Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [

                  if (!isSellerView)
                    OutlinedButton(
                      onPressed: () {
                        print("TOMBOL DIKLIK: Mengirim Seller ID -> '$sellerId'");

                        if (sellerId.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ChatRoomScreen(sellerId: sellerId),
                            ),
                          );
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: Color(0xFFD3C2B5),
                        ),
                      ),
                      child: const Text(
                        'Chat Seller',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                    ),

                  if (!isSellerView)
                    const SizedBox(width: 10),
                     ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderDetailScreen(
          roomId: roomId,
          messageId: docId,
          bookTitle: item['bookTitle'] ?? '',
          totalPrice: (item['price'] ?? '').toString(),
          authorName: item['author'] ?? '',
          addressInfo:
              item['alamat'] ??
              item['address'] ??
              'Alamat tidak tertera',
          coverImage: item['cover'] ?? '',
          currentStatus: statusStr,

          isSeller: isSellerView,

          isOfferType: false,
          chatVm: chatVm,
        ),
      ),
    );
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF4A352F),
  ),
  child: Text(
    isSellerView
        ? 'Kelola Pesanan'
        : 'Lihat Detail',
    style: const TextStyle(
      color: Colors.white,
      fontSize: 12,
    ),
  ),
),
                    ],
                  )
                  
                ],
              ),
            );
            
          },
        );
      },
    );
  }

  // ======================================================================
  // TAB 2: SELESAI
  // ======================================================================
  Widget _buildSelesaiTab() {
    final String myId = FirebaseAuth.instance.currentUser?.uid ?? "";
    final chatVm = Provider.of<ChatViewModel>(context, listen: false);

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('orders')
          .where(
  isSellerView
      ? 'sellerId'
      : 'buyerId',
  isEqualTo: myId,
)
          .where('statusPesanan', isEqualTo: 'selesai')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFFC76E2E)));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('Belum ada pesanan selesai.', style: GoogleFonts.montserrat(color: Colors.grey, fontSize: 13)));
        }

        final orders = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.all(20.0),
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final docId = orders[index].id;
            final item = orders[index].data() as Map<String, dynamic>;
            
            print("DEBUG DATA ORDERAN TAB SELESAI -> $item");

            final String sellerId = item['sellerId '] ?? item['sellerId'] ?? '';
            final String roomId = item['roomId'] ?? chatVm.getRoomId(myId, sellerId);

            String tglSelesai = "Selesai";
            if (item['createdAt'] != null) {
              DateTime dt = (item['createdAt'] as Timestamp).toDate();
              tglSelesai = "${dt.day}/${dt.month}/${dt.year}";
            }

            return Container(
              margin: const EdgeInsets.only(bottom: 15),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 6)],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      _buildBookCover(item['cover'] ?? ''),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    item['bookTitle'] ?? '',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.montserrat(fontWeight: FontWeight.w700, fontSize: 14, color: const Color(0xFF42210B)),
                                  ),
                                ),
                                Text(tglSelesai, style: GoogleFonts.montserrat(fontSize: 10, color: Colors.grey)),
                              ],
                            ),
                            Text(item['author'] ?? '', style: GoogleFonts.montserrat(fontSize: 11, color: Colors.grey)),
                            const SizedBox(height: 6),
                            Text("Rp ${item['price'] ?? ''}", style: GoogleFonts.montserrat(fontSize: 13, fontWeight: FontWeight.w700, color: const Color(0xFF261206))),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: Color(0xFFEFEFEF), height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderDetailScreen(
                                roomId: roomId,
                                messageId: docId,
                                bookTitle: item['bookTitle'] ?? '',
                                totalPrice: (item['price'] ?? '').toString(),
                                authorName: item['author'] ?? '',
                                addressInfo: item['alamat'] ?? item['address'] ?? 'Alamat tidak tertera',
                                coverImage: item['cover'] ?? '',
                                currentStatus: 'selesai',
                                isSeller: isSellerView,
                                isOfferType: false,
                                chatVm: chatVm,
                              ),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFFD3C2B5))),
                        child: const Text('Lihat Detail', style: TextStyle(color: Colors.black, fontSize: 12)),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () => _bukaUlasanBottomSheet(
                          item['bookTitle'] ?? '',
                          item['author'] ?? '',
                          item['cover'] ?? '',
                          sellerId, 
                        ),
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4A352F)),
                        child: const Text('Beri Ulasan', style: TextStyle(color: Colors.white, fontSize: 12)),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ======================================================================
  // TAB 3: DIBATALKAN
  // ======================================================================
  Widget _buildDibatalkanTab() {
    final String myId = FirebaseAuth.instance.currentUser?.uid ?? "";
    final chatVm = Provider.of<ChatViewModel>(context, listen: false);

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
         .collection('orders')
        .where(
          isSellerView
              ? 'sellerId'
              : 'buyerId',
          isEqualTo: myId,
        )
        .where('statusPesanan', isEqualTo: 'dibatalkan')
         
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFFC76E2E)));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('Tidak ada pesanan dibatalkan.', style: GoogleFonts.montserrat(color: Colors.grey, fontSize: 13)));
        }

        final orders = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.all(20.0),
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final docId = orders[index].id;
            final item = orders[index].data() as Map<String, dynamic>;
            
            print("DEBUG DATA ORDERAN TAB DIBATALKAN -> $item");

            final String sellerId = item['sellerId'] ?? item['idPenjual'] ?? item['ownerId'] ?? item['sellerUid'] ?? item['id_penjual'] ?? '';
            final String roomId = item['roomId'] ?? chatVm.getRoomId(myId, sellerId);

            return Container(
              margin: const EdgeInsets.only(bottom: 15),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 6)],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      _buildBookCover(item['cover'] ?? ''),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['bookTitle'] ?? '',
                              style: GoogleFonts.montserrat(fontWeight: FontWeight.w700, fontSize: 14, color: const Color(0xFF42210B)),
                            ),
                            Text(item['author'] ?? '', style: GoogleFonts.montserrat(fontSize: 11, color: Colors.grey)),
                            const SizedBox(height: 6),
                            Text("Rp ${item['price'] ?? ''}", style: GoogleFonts.montserrat(fontSize: 13, fontWeight: FontWeight.w700, color: const Color(0xFF261206))),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: Color(0xFFEFEFEF), height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderDetailScreen(
                                roomId: roomId,
                                messageId: docId,
                                bookTitle: item['bookTitle'] ?? '',
                                totalPrice: (item['price'] ?? '').toString(),
                                authorName: item['author'] ?? '',
                                addressInfo: item['alamat'] ?? item['address'] ?? 'Alamat tidak tertera',
                                coverImage: item['cover'] ?? '',
                                currentStatus: 'dibatalkan',
                               isSeller: isSellerView,
                                isOfferType: false,
                                chatVm: chatVm,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4A352F)),
                        child: const Text('Lihat Detail', style: TextStyle(color: Colors.white, fontSize: 12)),
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBookCover(String networkImageUrl) {
    return Container(
      width: 65,
      height: 90,
      decoration: BoxDecoration(color: const Color(0xFFF5EFE6), borderRadius: BorderRadius.circular(8)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: networkImageUrl.isNotEmpty
            ? Image.network(networkImageUrl, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.book, color: Color(0xFF4A352F)))
            : const Icon(Icons.book, color: Color(0xFF4A352F)),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'disetujui': return Colors.orange;
      case 'menunggu_konfirmasi': return Colors.blueGrey;
      case 'dikemas': return Colors.blue;
      case 'dikirim': return Colors.purple;
      default: return Colors.orange;
    }
  }
}

class _LokalUlasanBottomSheet extends StatefulWidget {
  final String bookTitle;
  final String bookAuthor;
  final String bookImage;
  final String targetSellerId;
  final PesananViewModel controller;

  const _LokalUlasanBottomSheet({
    required this.bookTitle,
    required this.bookAuthor,
    required this.bookImage,
    required this.targetSellerId,
    required this.controller,
  });

  @override
  State<_LokalUlasanBottomSheet> createState() => _LokalUlasanBottomSheetState();
}

class _LokalUlasanBottomSheetState extends State<_LokalUlasanBottomSheet> {
  int _rating = 0;
  bool _isSubmitted = false;
  final TextEditingController _deskripsiController = TextEditingController();
  bool _fotoDitambahkan = false;

  @override
  void dispose() {
    _deskripsiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (_, controller) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFFFFFDF2),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          ),
          child: _isSubmitted ? _buildSuccessState() : _buildInputState(controller),
        );
      },
    );
  }

  Widget _buildInputState(ScrollController scrollController) {
    bool isButtonEnabled = _rating > 0;

    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
      children: [
        Center(
          child: Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: Text(
            'Ulas Penjual Toko',
            style: GoogleFonts.montserrat(color: const Color(0xFF42210B), fontWeight: FontWeight.w700, fontSize: 16),
          ),
        ),
        const SizedBox(height: 25),
        Center(
          child: Container(
            width: 130,
            height: 180,
            decoration: BoxDecoration(
              color: const Color(0xFFF5EFE6),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 4))],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: widget.bookImage.isNotEmpty
                  ? Image.network(widget.bookImage, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.book, size: 50, color: Color(0xFF4A352F)))
                  : const Icon(Icons.book, size: 50, color: Color(0xFF4A352F)),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Text(
            widget.bookTitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(fontWeight: FontWeight.w700, fontSize: 18, color: const Color(0xFF42210B)),
          ),
        ),
        Center(child: Text('Item dibeli dari penjual', style: GoogleFonts.montserrat(fontSize: 12, color: const Color(0xFF8C8C8C)))),
        const SizedBox(height: 25),
        Center(
          child: Text(
            'BAGAIMANA PENGALAMANMU BELANJA DI TOKO INI?',
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(fontSize: 11, fontWeight: FontWeight.w600, color: const Color(0xFF8C8C8C), letterSpacing: 0.5),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return GestureDetector(
              onTap: () => setState(() => _rating = index + 1),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Icon(index < _rating ? Icons.star_rounded : Icons.star_outline_rounded, color: const Color(0xFFC76E2E), size: 38),
              ),
            );
          }),
        ),
        const SizedBox(height: 25),
        Text('TAMBAHKAN FOTO KONDISI BARANG', style: GoogleFonts.montserrat(fontSize: 11, fontWeight: FontWeight.w600, color: const Color(0xFF8C8C8C))),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => setState(() => _fotoDitambahkan = !_fotoDitambahkan),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: const Color(0xFFEFECE1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFD3C2B5), width: 1),
              ),
              child: _fotoDitambahkan
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: widget.bookImage.isNotEmpty ? Image.network(widget.bookImage, fit: BoxFit.cover) : const Icon(Icons.book, color: Color(0xFF8C8C8C)),
                    )
                  : const Icon(Icons.add_photo_alternate_outlined, color: Color(0xFF8C8C8C)),
            ),
          ),
        ),
        const SizedBox(height: 25),
        Text('ULASAN PELAYANAN TOKO', style: GoogleFonts.montserrat(fontSize: 11, fontWeight: FontWeight.w600, color: const Color(0xFF8C8C8C))),
        const SizedBox(height: 8),
        TextField(
          controller: _deskripsiController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Bagikan ulasan mengenai keramahan, kecepatan respons, atau kualitas pengemasan penjual ini...',
            hintStyle: GoogleFonts.montserrat(fontSize: 12, color: const Color(0xFFA8A8A8)),
            filled: true,
            fillColor: const Color(0xFFEFECE1),
            contentPadding: const EdgeInsets.all(12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
          ),
          style: GoogleFonts.montserrat(fontSize: 13, color: const Color(0xFF42210B)),
        ),
        const SizedBox(height: 35),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: isButtonEnabled
                ? () {
                    widget.controller.kirimUlasanKeDatabase(
                      sellerId: widget.targetSellerId,
                      judulBuku: widget.bookTitle,
                      rating: _rating,
                      deskripsi: _deskripsiController.text,
                      denganFoto: _fotoDitambahkan,
                    );
                    setState(() => _isSubmitted = true);
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF261206),
              disabledBackgroundColor: const Color(0xFF261206).withOpacity(0.5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            ),
            child: Text(
              'Kirim Ulasan Toko',
              style: GoogleFonts.montserrat(color: isButtonEnabled ? Colors.white : Colors.white.withOpacity(0.6), fontWeight: FontWeight.w700, fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessState() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(color: Color(0xFF7A4B31), shape: BoxShape.circle),
            child: const Icon(Icons.check, size: 50, color: Color(0xFFFFFDF2)),
          ),
          const SizedBox(height: 25),
          Text('Ulasan Toko Terkirim!', style: GoogleFonts.montserrat(color: const Color(0xFF42210B), fontWeight: FontWeight.w700, fontSize: 18)),
          const SizedBox(height: 8),
          Text(
            'Terima kasih telah membantu meningkatkan\nkepercayaan komunitas Booknity terhadap penjual ini.',
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(color: const Color(0xFF8C8C8C), fontSize: 13),
          ),
          const SizedBox(height: 35),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF261206), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
              child: Text('Kembali Ke Beranda', style: GoogleFonts.montserrat(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14)),
            ),
          ),
        ],
      ),
    );
  }
}