import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../model/book_model.dart';
import '../../model/address_model.dart';
import '../../viewmodel/chat_viewmodel.dart';
import '../../viewmodel/address_viewmodel.dart';
import '../chat_room_screen.dart';
import '../Profile/add_address_screen.dart';
import '../Profile/address_list_screen.dart';

class PaymentScreen extends StatefulWidget {
  final BookModel book;
  final int? customPrice; // harga hasil nego (opsional)

  const PaymentScreen({Key? key, required this.book, this.customPrice})
    : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedCourier = 'jne';
  AddressModel? _selectedAddress;
  bool _loadingAddress = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadAddress());
  }

  Future<void> _loadAddress() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() => _loadingAddress = false);
      return;
    }
    try {
      final vm = Provider.of<AddressViewModel>(context, listen: false);
      await vm.loadAddresses(user.uid);
      if (mounted) {
        setState(() {
          _selectedAddress = vm.addresses.isNotEmpty
              ? vm.addresses.first
              : null;
          _loadingAddress = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _loadingAddress = false);
    }
  }

  // Parse harga string → double (untuk kalkulasi)
  double _parsePrice(String priceStr) {
    final cleanStr = priceStr
        .replaceAll('Rp', '')
        .replaceAll('.', '')
        .replaceAll(',', '')
        .trim();
    return double.tryParse(cleanStr) ?? 0.0;
  }

  // Format int → "50.000"
  String _formatRupiah(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  // Harga buku yang dipakai: customPrice jika ada, fallback ke book.price
  double get _effectiveBookPrice {
    if (widget.customPrice != null) {
      return widget.customPrice!.toDouble();
    }
    return _parsePrice(widget.book.price);
  }

  // Teks harga buku yang ditampilkan
  String get _displayBookPrice {
    if (widget.customPrice != null) {
      return 'Rp ${_formatRupiah(widget.customPrice!)}';
    }
    return widget.book.price.startsWith('Rp')
        ? widget.book.price
        : 'Rp ${widget.book.price}';
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
              subtitle: 'Estimasi tiba: 2-3 hari kerja',
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
                if (_selectedAddress == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Harap tambahkan alamat pengiriman terlebih dahulu!',
                      ),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                  return;
                }

                int shippingCost = _selectedCourier == 'jne' ? 10000 : 7000;
                double bookPrice = _effectiveBookPrice; // ← pakai harga nego
                double serviceFee = 2500;
                double totalBayar = bookPrice + shippingCost + serviceFee;
                String kurirName = _selectedCourier == 'jne'
                    ? 'JNE Express'
                    : 'SiCepat Reguler';

                String alamatFinal =
                    'Kurir: $kurirName\n'
                    '${_selectedAddress!.recipient} (${_selectedAddress!.phone})\n'
                    '${_selectedAddress!.address}';

                String totalBayarFormatted = _formatRupiah(totalBayar.toInt());

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Membuka chat penjual dan mengirim invoice...',
                    ),
                  ),
                );

                final chatVm = Provider.of<ChatViewModel>(
                  context,
                  listen: false,
                );
                String roomId = chatVm.getRoomId(
                  chatVm.currentUserId,
                  widget.book.sellerId,
                );

                await chatVm.sendInvoiceMessage(
                  roomId: roomId,
                  address: alamatFinal,
                  title: widget.book.title,
                  author: widget.book.author,
                  image: widget.book.image,
                  totalPrice: totalBayarFormatted,
                  sellerId: widget.book.sellerId,
                );

                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ChatRoomScreen(sellerId: widget.book.sellerId),
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

  Widget _buildAddressCard() {
    if (_loadingAddress) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF9E3422)),
      );
    }

    if (_selectedAddress == null) {
      return GestureDetector(
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddAddressScreen()),
          );
          await _loadAddress();
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFAF6F0),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: const Row(
            children: [
              Icon(Icons.add_location_alt_outlined, color: Color(0xFF9E3422)),
              SizedBox(width: 10),
              Text(
                'Tambah alamat pengiriman',
                style: TextStyle(
                  color: Color(0xFF9E3422),
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFFFAF6F0),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        border: Border(left: BorderSide(color: Color(0xFFD7CCC8), width: 5)),
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
                'Alamat Pengiriman',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${_selectedAddress!.recipient} (${_selectedAddress!.phone})',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _selectedAddress!.address,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 12,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 10),
          Consumer<AddressViewModel>(
            builder: (context, vm, _) {
              if (vm.addresses.length <= 1) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: GestureDetector(
                  onTap: () => _showAddressPicker(vm.addresses),
                  child: const Text(
                    'Ganti alamat',
                    style: TextStyle(
                      color: Color(0xFF9E3422),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              );
            },
          ),
          GestureDetector(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddressListScreen()),
              );
              await _loadAddress();
            },
            child: const Text(
              'Kelola alamat',
              style: TextStyle(
                color: Color(0xFF9E3422),
                fontSize: 12,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddressPicker(List<AddressModel> addresses) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.all(20),
          itemCount: addresses.length,
          itemBuilder: (context, index) {
            final addr = addresses[index];
            return ListTile(
              title: Text(
                addr.label,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('${addr.recipient}\n${addr.address}'),
              isThreeLine: true,
              trailing: _selectedAddress?.id == addr.id
                  ? const Icon(Icons.check_circle, color: Color(0xFF9E3422))
                  : null,
              onTap: () {
                setState(() => _selectedAddress = addr);
                Navigator.pop(context);
              },
            );
          },
        );
      },
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
                Text(
                  widget.customPrice != null ? 'HARGA NEGO' : 'BELI LANGSUNG',
                  style: const TextStyle(
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
                  _displayBookPrice, // ← harga nego atau harga asli
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xffB64B1E),
                  ),
                ),
              ],
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
      onTap: () => setState(() => _selectedCourier = id),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : const Color(0xFFEBE6DD),
          borderRadius: BorderRadius.circular(16),
          border: isSelected
              ? Border.all(color: const Color(0xFF9E3422), width: 1.5)
              : null,
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
                  isSelected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
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
    double bookPrice = _effectiveBookPrice; // ← pakai harga nego jika ada
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
          _buildDetailRow('Harga Buku', _displayBookPrice), // ← harga nego
          _buildDetailRow(
            'Ongkir Pengiriman',
            'Rp ${shippingCost == 10000 ? "10.000" : "7.000"}',
          ),
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
                'Rp ${_formatRupiah(total.toInt())}',
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
