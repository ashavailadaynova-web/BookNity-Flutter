import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/book_model.dart';
import '../../viewmodel/chat_viewmodel.dart';
import '../chat_room_screen.dart';

class PaymentScreen extends StatefulWidget {
  final BookModel book;

  const PaymentScreen({Key? key, required this.book}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedCourier = 'jne';

  final _addressController = TextEditingController(
    text: 'Jl. Senopati No. 42, Kebayoran Baru, Jakarta Selatan, DKI Jakarta 12190',
  );

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  double _parsePrice(String priceStr) {
    final cleanStr = priceStr.replaceAll('Rp', '').replaceAll('.', '').replaceAll(',', '').trim();
    return double.tryParse(cleanStr) ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFDF9),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF3E2723)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: const Text(
          'Pembayaran',
          style: TextStyle(
            color: Color(0xFF3E2723),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Selesaikan Pesananmu',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Pastikan alamat pengiriman sudah benar\ndan pilih metode pengiriman untuk\nmenyelesaikan pesanan.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black54,
                fontSize: 13,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 24),

            _buildBookInfoCard(),
            const SizedBox(height: 16),

            _buildAddressCard(),
            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Ongkir Pengiriman',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                Icon(
                  Icons.local_shipping_outlined,
                  color: Color(0xFF1A1A1A),
                  size: 22,
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildCourierOption(
              id: 'jne',
              title: 'JNE Express (Next Day)',
              subtitle: 'Estimasi Tiba: Besok, sebelum jam 06.00',
              price: 'Rp 10.000',
              icon: Icons.flash_on,
              iconColor: const Color(0xFFD32F2F),
              iconBgColor: const Color(0xFFFFEBEE),
              isSelected: _selectedCourier == 'jne',
            ),
            const SizedBox(height: 12),
            _buildCourierOption(
              id: 'sicepat',
              title: 'SiCepat Reguler',
              subtitle: 'Estimated arrival: 2-3 business days',
              price: 'Rp 7.000',
              icon: Icons.local_shipping_outlined,
              iconColor: Colors.black54,
              iconBgColor: const Color(0xFFEFEBE9),
              isSelected: _selectedCourier == 'sicepat',
            ),
            const SizedBox(height: 24),

            _buildPaymentDetails(),
            const SizedBox(height: 24),

            _buildPaymentInstructions(),
            const SizedBox(height: 32),

            ElevatedButton(
              onPressed: () async {
                if (_addressController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Harap isi alamat pengiriman terlebih dahulu!'),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                  return;
                }

                String alamatFinal = _addressController.text.trim();
                int shippingCost = _selectedCourier == 'jne' ? 10000 : 7000;
                double bookPrice = _parsePrice(widget.book.price);
                double serviceFee = 2500;
                double totalBayar = bookPrice + shippingCost + serviceFee;
                String kurirName = _selectedCourier == 'jne' ? 'JNE Express' : 'SiCepat Reguler';

                String totalBayarFormated = totalBayar.toInt().toString().replaceAllMapped(
                    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Membuka chat penjual dan mengirim invoice...')),
                );

                final chatVm = Provider.of<ChatViewModel>(context, listen: false);
                String roomId = chatVm.getRoomId(chatVm.currentUserId, widget.book.sellerId);

                await chatVm.sendInvoiceMessage(
                  roomId: roomId,
                  address: "Kurir: $kurirName\nAlamat: $alamatFinal",
                  title: widget.book.title,
                  author: widget.book.author ?? "Unknown Author",
                  image: widget.book.image,
                  totalPrice: totalBayarFormated,
                );

                if (context.mounted) {
                  // 🟢 REVISI: Menggunakan pushAndRemoveUntil agar saat di-back langsung balik ke Inbox Utama (Page Pertama)
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatRoomScreen(
                        sellerId: widget.book.sellerId,
                      ),
                    ),
                    (route) => route.isFirst,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9E3422),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 3,
              ),
              child: const Text(
                'Konfirmasi Sudah Pembayaran',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildBookInfoCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEFEBE4),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: widget.book.image.startsWith('http')
                ? Image.network(
                    widget.book.image,
                    width: 70,
                    height: 100,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    widget.book.image,
                    width: 70,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'PENAWARAN DITERIMA',
                  style: TextStyle(
                    color: Color(0xFFD32F2F),
                    fontWeight: FontWeight.bold,
                    fontSize: 9,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.book.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Terjual dari:',
                  style: TextStyle(color: Colors.black45, fontSize: 11),
                ),
                Text(
                  widget.book.storeName,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  widget.book.price.startsWith('Rp') ? widget.book.price : 'Rp ${widget.book.price}',
                  style: const TextStyle(
                    color: Color(0xFF9E3422),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFFFAF6F0),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        border: Border(
          left: BorderSide(
            color: Color(0xFFD7CCC8),
            width: 5,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(
                Icons.location_on_outlined,
                size: 16,
                color: Color(0xFF3E2723),
              ),
              SizedBox(width: 6),
              Text(
                'Alamat Rumah',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Daynova Shava',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _addressController,
            maxLines: 3,
            style: const TextStyle(
              color: Color(0xFF1A1A1A),
              fontSize: 12,
              height: 1.4,
            ),
            decoration: InputDecoration(
              hintText: 'Masukkan alamat lengkap beserta nomor HP aktif...',
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 12),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.all(12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF9E3422), width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourierOption({
    required String id,
    required String title,
    required String subtitle,
    required String price,
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCourier = id;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : const Color(0xFFEBE6DD),
          borderRadius: BorderRadius.circular(16),
          border: isSelected ? Border.all(color: const Color(0xFF9E3422), width: 1.5) : null,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.black45, fontSize: 10),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  price,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Color(0xFF9E3422),
                  ),
                ),
                const SizedBox(height: 4),
                Icon(
                  isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                  size: 16,
                  color: isSelected ? const Color(0xFF9E3422) : Colors.black26,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentDetails() {
    int shippingCost = _selectedCourier == 'jne' ? 10000 : 7000;
    double bookPrice = _parsePrice(widget.book.price);
    double serviceFee = 2500;
    double total = bookPrice + shippingCost + serviceFee;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEFEBE4),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Rincian Pembayaran',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 16),
          _buildDetailRow('Harga Buku', widget.book.price.startsWith('Rp') ? widget.book.price : 'Rp ${widget.book.price}'),
          _buildDetailRow('Ongkir Pengiriman', 'Rp ${shippingCost == 10000 ? "10.000" : "7.000"}'),
          _buildDetailRow('Biaya Layanan', 'Rp 2.500'),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Divider(color: Colors.black12, thickness: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Pembayaran',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                ),
              ),
              Text(
                'Rp ${total.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF9E3422),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.black54, fontSize: 13),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentInstructions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF6F0),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Instruksi Pembayaran',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Color(0xFF9E3422),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFFEBEE),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.info_outline, size: 10, color: Color(0xFFD32F2F)),
                SizedBox(width: 4),
                Text(
                  'MANUAL TRANSFER',
                  style: TextStyle(
                    color: Color(0xFFD32F2F),
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildStepRow(
            number: '1',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Transfer ke rekening BCA:',
                  style: TextStyle(fontSize: 12, color: Colors.black87),
                ),
                const SizedBox(height: 2),
                Row(
                  children: const [
                    Text(
                      '1234567890',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    SizedBox(width: 6),
                    Icon(Icons.copy, size: 12, color: Colors.black45),
                  ],
                ),
                Text(
                  'A.N. ${widget.book.storeName.toUpperCase()}',
                  style: const TextStyle(fontSize: 10, color: Colors.black45),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _buildStepRow(
            number: '2',
            child: const Text(
              'Lampirkan bukti transfer di chat setelah melakukan pembayaran.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.black87,
                height: 1.3,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: Divider(color: Colors.black12),
          ),
          const Text(
            'Catatan: Pembayaran ini dilakukan secara manual di luar aplikasi. Pesanan akan diproses segera setelah bukti transfer divalidasi oleh Toko.',
            style: TextStyle(color: Colors.black45, fontSize: 10, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildStepRow({required String number, required Widget child}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 18,
          height: 18,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: Color(0xFF3E2723),
            shape: BoxShape.circle,
          ),
          child: Text(
            number,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(child: child),
      ],
    );
  }
}