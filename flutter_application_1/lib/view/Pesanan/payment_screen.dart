import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  // State untuk memilih kurir pengiriman (JNE atau SiCepat)
  String _selectedCourier = 'jne';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFFFFFDF9,
      ), // Background krem muda khas Booknity
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
            // --- HEADER TITLE ---
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

            // --- KARTU PRODUK BUKU ---
            _buildBookInfoCard(),
            const SizedBox(height: 16),

            // --- KARTU ALAMAT RUMAH ---
            _buildAddressCard(),
            const SizedBox(height: 24),

            // --- SEKSI ONGKIR PENGIRIMAN ---
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

            // --- RINCIAN PEMBAYARAN ---
            _buildPaymentDetails(),
            const SizedBox(height: 24),

            // --- INSTRUKSI PEMBAYARAN ---
            _buildPaymentInstructions(),
            const SizedBox(height: 32),

            // --- TOMBOL KONFIRMASI UTAMA ---
            ElevatedButton(
              onPressed: () {
                // Tambahkan fungsi aksi submit kelompokmu di sini
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(
                  0xFF9E3422,
                ), // Warna merah bata tua
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

  // Widget 1: Info Buku Laut Bercerita
  Widget _buildBookInfoCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEFEBE4), // Background abu-krem kalem lembut
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              'https://picsum.photos/seed/book/100/140', // Ganti dengan aset gambar asli kelompokmu jika ada
              width: 70,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'PENAWARAN DITERIMA',
                  style: TextStyle(
                    color: Color(0xFFD32F2F),
                    fontWeight: FontWeight.bold,
                    fontSize: 9,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Laut Bercerita',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Terjual dari:',
                  style: TextStyle(color: Colors.black45, fontSize: 11),
                ),
                Text(
                  'Toko Buku Aceng',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Rp 55.000',
                  style: TextStyle(
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

  // Widget 2: Alamat Rumah
  Widget _buildAddressCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF6F0),
        borderRadius: BorderRadius.circular(16),
        border: const Border(
          left: BorderSide(
            color: Color(
              0xFFD7CCC8,
            ), // Warna cokelat/krem agak tua sesuai mockup asli
            width: 5, // Ketebalan garis border kiri
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
          const SizedBox(height: 6),
          const Text(
            'Jl. Senopati No. 42, Kebayoran Baru\nJakarta Selatan, DKI Jakarta 12190\n(+62) 812-3456-7890',
            style: TextStyle(color: Colors.black54, fontSize: 12, height: 1.4),
          ),
        ],
      ),
    );
  }

  // Widget 3: Opsi Pilihan Ongkir (Custom Radio Card)
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
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: const Color(0xFF9E3422),
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

  // Widget 4: Rincian Harga Pembayaran
  Widget _buildPaymentDetails() {
    // Menghitung ongkir dinamis berdasarkan kurir yang dipilih
    int shippingCost = _selectedCourier == 'jne' ? 10000 : 7000;
    int bookPrice = 55000;
    int serviceFee = 2500;
    int total = bookPrice + shippingCost + serviceFee;

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
          _buildDetailRow('Harga Buku', 'Rp 55.000'),
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
                'Rp ${total == 67500 ? "67.500" : "64.500"}',
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
      // 🟢 Properti 'style' dihapus dari sini karena Padding tidak membutuhkannya
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 🟢 Pindahkan TextStyle ke dalam properti 'style' milik widget Text masing-masing
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

  // Widget 5: Instruksi Manual Rekening Transfer
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
                const Text(
                  'A.N. TOKO BUKU ACENG',
                  style: TextStyle(fontSize: 10, color: Colors.black45),
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
          alignment: Alignment
              .center, // 🟢 Diubah dari Center() menjadi Alignment.center
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
