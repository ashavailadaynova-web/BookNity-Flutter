import 'package:flutter/material.dart';
import '../chat_room_screen.dart'; // Pastikan class di dalam file ini bernama "ChatRoomScreen"

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFFFFFDF9),
        appBar: AppBar(
          backgroundColor: const Color(0xFFFFFDF9),
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'Notifikasi',
            style: TextStyle(
              color: Color(0xFF3E2723),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          bottom: const TabBar(
            labelColor: Color(0xFF3E2723),
            unselectedLabelColor: Colors.black45,
            indicatorColor: Color(0xFFD32F2F),
            indicatorWeight: 3,
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            tabs: [
              Tab(text: 'Semua'),
              Tab(text: 'Belum Baca'),
              Tab(text: 'Sudah Baca'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildTabSemua(),
            _buildTabBelumBaca(),
            _buildTabSudahBaca(),
          ],
        ),
      ),
    );
  }

  // --- TAB 1: SEMUA NOTIFIKASI ---
  Widget _buildTabSemua() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader('Hari ini'),
        _buildMessageCard(
          name: 'Sabian Adam',
          time: '20 Menit',
          text: '"Walah gitu ya kak, boleh minta tolong fotoin ngga kak?"',
          avatarUrl: 'https://i.pravatar.cc/100?img=53',
          hasActionButtons: true,
          isUnread: true,
        ),
        _buildShopCard(
          shopName: 'Toko Buku Aceng',
          time: '1 Jam',
          text:
              '"Halo kak, terima kasih sudah berkunjung di Toko kami. Untuk tawaran buku ...',
          avatarUrl: 'https://i.pravatar.cc/100?img=12',
          hasActionButtons: true,
          isUnread: true,
        ),
        _buildStatusCard(
          title: 'Pesananmu Dikirim',
          time: '2 Jam',
          text:
              'Buku "Bumi Manusia" sedang menuju alamatmu. Kurir diperkirakan tiba sore ini.',
          icon: Icons.local_shipping_outlined,
          iconBgColor: const Color(0xFFFFEBEE),
          iconColor: const Color(0xFFD32F2F),
          isUnread: true,
        ),
        _buildFollowCard(
          name: 'Martin Edwards',
          time: '3 Jam',
          text: 'Mulai Mengikuti Anda',
          avatarUrl: 'https://i.pravatar.cc/100?img=60',
          isUnread: true,
        ),
        const SizedBox(height: 16),
        _buildSectionHeader('Kemarin'),
        _buildPromoCard(
          title: 'Promo Hari Ini!',
          text:
              'Dapatkan diskon hingga 50% untuk kategori komik dengan menggunakan kode...',
          icon: Icons.percent,
          iconBgColor: const Color(0xFFE0F2FE),
          iconColor: const Color(0xFF0284C7),
          isUnread: false,
        ),
        _buildStatusCard(
          title: 'Review Buku Kamu',
          time: 'Kemarin',
          text:
              'Bagaimana menurutmu tentang buku "Sapiens"? Bagikan ulasanmu dan dapatkan 50 poin.',
          icon: Icons.rate_review_outlined,
          iconBgColor: const Color(0xFFFEF9E7),
          iconColor: const Color(0xFFD4AC0D),
          isUnread: false,
        ),
        const SizedBox(height: 16),
        _buildSectionHeader('2 hari lalu'),
        _buildStatusCard(
          title: 'Pesanan Selesai',
          time: '2 hari lalu',
          text:
              'Transaksi #BK-88291 telah selesai. Terima kasih telah berbelanja di Bookity!',
          icon: Icons.shopping_bag_outlined,
          iconBgColor: const Color(0xFFE8F5E9),
          iconColor: const Color(0xFF2E7D32),
          isUnread: false,
        ),
      ],
    );
  }

  // --- TAB 2: BELUM BACA ---
  Widget _buildTabBelumBaca() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader('Hari ini'),
        _buildMessageCard(
          name: 'Sabian Adam',
          time: '20 Menit',
          text: '"Walah gitu ya kak, boleh minta tolong fotoin ngga kak?"',
          avatarUrl: 'https://i.pravatar.cc/100?img=53',
          hasActionButtons: true,
          isUnread: true,
        ),
        _buildShopCard(
          shopName: 'Toko Buku Aceng',
          time: '1 Jam',
          text:
              '"Halo kak, terima kasih sudah berkunjung di Toko kami. Untuk tawaran buku ...',
          avatarUrl: 'https://i.pravatar.cc/100?img=12',
          hasActionButtons: true,
          isUnread: true,
        ),
        _buildStatusCard(
          title: 'Pesananmu Dikirim',
          time: '2 Jam',
          text:
              'Buku "Bumi Manusia" sedang menuju alamatmu. Kurir diperkirakan tiba sore ini.',
          icon: Icons.local_shipping_outlined,
          iconBgColor: const Color(0xFFFFEBEE),
          iconColor: const Color(0xFFD32F2F),
          isUnread: true,
        ),
        _buildFollowCard(
          name: 'Martin Edwards',
          time: '3 Jam',
          text: 'Mulai Mengikuti Anda',
          avatarUrl: 'https://i.pravatar.cc/100?img=60',
          isUnread: true,
        ),
      ],
    );
  }

  // --- TAB 3: SUDAH BACA ---
  Widget _buildTabSudahBaca() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader('Kemarin'),
        _buildStatusCard(
          title: 'Review Buku Kamu',
          time: 'Kemarin',
          text:
              'Bagaimana menurutmu tentang buku "Sapiens"? Bagikan ulasanmu dan dapatkan 50 poin.',
          icon: Icons.rate_review_outlined,
          iconBgColor: const Color(0xFFFEF9E7),
          iconColor: const Color(0xFFD4AC0D),
          isUnread: false,
        ),
        const SizedBox(height: 16),
        _buildSectionHeader('2 hari lalu'),
        _buildStatusCard(
          title: 'Pesanan Selesai',
          time: '2 hari lalu',
          text:
              'Transaksi #BK-88291 telah selesai. Terima kasih telah berbelanja di Bookity!',
          icon: Icons.shopping_bag_outlined,
          iconBgColor: const Color(0xFFE8F5E9),
          iconColor: const Color(0xFF2E7D32),
          isUnread: false,
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, top: 4.0),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black87,
          fontSize: 14,
        ),
      ),
    );
  }

  // 1. Kartu Model Pesan Masuk
  Widget _buildMessageCard({
    required String name,
    required String time,
    required String text,
    required String avatarUrl,
    required bool hasActionButtons,
    required bool isUnread,
  }) {
    return Builder(
      builder: (context) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChatRoomScreen(
                  sellerId: 'seller_dummy_1',
                ), // <-- Tambahkan ini (tanpa const)
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundImage: NetworkImage(avatarUrl),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                ),
                                children: [
                                  const TextSpan(
                                    text: 'Pesan Baru dari ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  TextSpan(
                                    text: name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFE64A19),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Text(
                            time,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        text,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      if (hasActionButtons) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _buildActionSizeButton(
                              label: 'Balas',
                              bgColor: const Color(0xFF3E2723),
                              textColor: Colors.white,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ChatRoomScreen(
                                      sellerId: 'seller_dummy_1',
                                    ), // <-- Tambahkan ini
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 8),
                            _buildActionSizeButton(
                              label: 'Lihat Profil',
                              bgColor: const Color(0xFFEFEBE9),
                              textColor: const Color(0xFF3E2723),
                              onTap: () {
                                // Aksi lihat profil jika ada
                              },
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                if (isUnread) _buildUnreadDot(),
              ],
            ),
          ),
        );
      },
    );
  }

  // 2. Kartu Model Penawaran Toko Buku
  Widget _buildShopCard({
    required String shopName,
    required String time,
    required String text,
    required String avatarUrl,
    required bool hasActionButtons,
    required bool isUnread,
  }) {
    return Builder(
      builder: (context) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 22,
                backgroundImage: NetworkImage(avatarUrl),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                              ),
                              children: [
                                TextSpan(
                                  text: shopName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFE64A19),
                                  ),
                                ),
                                const TextSpan(
                                  text: ' Menerima Tawaran',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          time,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      text,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    if (hasActionButtons) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildActionSizeButton(
                            label: 'Balas',
                            bgColor: const Color(0xFF3E2723),
                            textColor: Colors.white,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ChatRoomScreen(
                                    sellerId: 'seller_dummy_shop',
                                  ), // <-- Tambahkan ini
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 8),
                          _buildActionSizeButton(
                            label: 'Lihat Profil',
                            bgColor: const Color(0xFFEFEBE9),
                            textColor: const Color(0xFF3E2723),
                            onTap: () {},
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              if (isUnread) _buildUnreadDot(),
            ],
          ),
        );
      },
    );
  }

  // 3. Kartu Model Status / Pengiriman / Review
  Widget _buildStatusCard({
    required String title,
    required String time,
    required String text,
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required bool isUnread,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Color(0xFFF5EFE6),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF4E342E), size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      time,
                      style: const TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  text,
                  style: const TextStyle(color: Colors.black54, fontSize: 12),
                ),
              ],
            ),
          ),
          if (isUnread) _buildUnreadDot(),
        ],
      ),
    );
  }

  // 4. Kartu Model Mulai Mengikuti (Follow)
  Widget _buildFollowCard({
    required String name,
    required String time,
    required String text,
    required String avatarUrl,
    required bool isUnread,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(radius: 22, backgroundImage: NetworkImage(avatarUrl)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                          ),
                          children: [
                            TextSpan(
                              text: name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFE64A19),
                              ),
                            ),
                            TextSpan(
                              text: ' $text',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      time,
                      style: const TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _buildActionSizeButton(
                  label: 'Lihat Profil',
                  bgColor: const Color(0xFFEFEBE9),
                  textColor: const Color(0xFF3E2723),
                  onTap: () {},
                ),
              ],
            ),
          ),
          if (isUnread) _buildUnreadDot(),
        ],
      ),
    );
  }

  // 5. Kartu Model Promo Khusus
  Widget _buildPromoCard({
    required String title,
    required String text,
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required bool isUnread,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Color(0xFFF5EFE6),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF4E342E), size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    const Text(
                      'Kemarin',
                      style: TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  text,
                  style: const TextStyle(color: Colors.black54, fontSize: 12),
                ),
              ],
            ),
          ),
          if (isUnread) _buildUnreadDot(),
        ],
      ),
    );
  }

  // Tombol aksi kecil (Balas / Lihat Profil) dengan deteksi Klik (onTap)
  Widget _buildActionSizeButton({
    required String label,
    required Color bgColor,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildUnreadDot() {
    return Container(
      margin: const EdgeInsets.only(left: 8, top: 4),
      width: 8,
      height: 8,
      decoration: const BoxDecoration(
        color: Color(0xFF4E342E),
        shape: BoxShape.circle,
      ),
    );
  }
}
