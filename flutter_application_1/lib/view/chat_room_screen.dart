import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../model/chat_model.dart';

class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({super.key});

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final TextEditingController controller = TextEditingController();

  void _showMediaMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.camera_alt,
                    color: Color(0xff4A241B),
                  ),
                  title: Text(
                    "Ambil Foto",
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);

                    /// nanti controller kamera
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.photo_library,
                    color: Color(0xff4A241B),
                  ),
                  title: Text(
                    "Pilih dari Galeri",
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);

                    /// nanti controller galeri
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  final List<MessageModel> messages = [
    MessageModel(
      type: MessageType.offerPending,
      isMe: true,
      time: "10:45 AM",
      bookTitle: "Laut Bercerita",
      author: "Leila S Chudori",
      price: "55.000",
      cover: "https://covers.openlibrary.org/b/id/14613167-L.jpg",
    ),
    MessageModel(
      text: "Mohon tunggu respon penawaran dari penjual",
      isMe: false,
      time: "10:46 AM",
    ),
    MessageModel(
      text:
          "Halo kak, terima kasih sudah berkunjung di Toko kami. Untuk tawaran buku Laut Bercerita kami terima ya.",
      isMe: false,
      time: "11:00 AM",
    ),
    MessageModel(
      type: MessageType.offerAccepted,
      isMe: false,
      time: "11:00 AM",
      bookTitle: "Laut Bercerita",
      author: "Leila S Chudori",
      price: "55.000",
      cover: "https://covers.openlibrary.org/b/id/14613167-L.jpg",
    ),
    MessageModel(
      text: "Hai Kak Aceng, baik saya akan melanjutkan ke pembayaran",
      isMe: true,
      time: "11:12 AM",
    ),
  ];

  // Fungsi khusus untuk merender komponen bubble chat khusus penawaran (Custom Offer Cards)
  Widget _buildCustomOfferMessage(MessageModel message) {
    if (message.type == MessageType.offerPending) {
      return Container(
        width: 215,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xffE8DFC7),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                message.cover ?? '',
                width: 55,
                height: 75,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.book, size: 55),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "MENUNGGU PENAWARAN",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 8,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xffC45A1A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Penawaran kamu",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: const Color(0xffC45A1A),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    message.bookTitle ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    "oleh ${message.author ?? ''}",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Rp. ${message.price ?? ''}",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    if (message.type == MessageType.offerAccepted) {
      return Container(
        width: 255,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xffE8DFC7),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          children: [
            Text(
              "PENAWARAN DITERIMA",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: const Color(0xffC45A1A),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    message.cover ?? '',
                    width: 50,
                    height: 70,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.book, size: 50),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Dengan Penawaran",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: const Color(0xffC45A1A),
                        ),
                      ),
                      Text(
                        message.bookTitle ?? '',
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        "oleh ${message.author ?? ''}",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        "Rp. ${message.price ?? ''}",
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: 150,
              height: 34,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: const Color(0xffB64B1E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  "Lanjutkan Pembayaran",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Default fallback jika tipenya tidak dikenal (mengurangi risiko crash/error)
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xffF9F6EE,
      ), // Menambahkan background scaffold agar serasi
      appBar: AppBar(
        title: const Text("Chat Room"),
        backgroundColor: const Color(0xff4A241B),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),

          /// DATE
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xffEFE7D7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "SABTU, 11 APRIL",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xff7D7065),
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          /// PRODUCT CARD AT TOP
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: const EdgeInsets.only(left: 24),
              width: 180,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xffE7DFC7),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      "https://covers.openlibrary.org/b/id/14613167-L.jpg",
                      width: 56,
                      height: 76,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Produk kamu",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xffD36A1D),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "Teka Teki Rumah Aneh",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xff2D2D2D),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "Oleh Uketsu",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            color: const Color(0xff777777),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "Rp. 45.000",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xff2D2D2D),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 18),

          /// MESSAGES LISTVIEW
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                bool isOffer =
                    message.type == MessageType.offerPending ||
                    message.type == MessageType.offerAccepted;

                return Align(
                  alignment: message.isMe
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: message.isMe
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      // Logika Pemisahan Render Chat Bubble
                      isOffer
                          ? _buildCustomOfferMessage(message)
                          : Container(
                              constraints: const BoxConstraints(maxWidth: 260),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              decoration: BoxDecoration(
                                color: message.isMe
                                    ? const Color(0xff4A241B)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Text(
                                message.text ?? '',
                                style: GoogleFonts.plusJakartaSans(
                                  color: message.isMe
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                      const SizedBox(height: 6),
                      Text(
                        message.time,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          color: const Color(0xffB4AEA8),
                        ),
                      ),
                      const SizedBox(height: 18),
                    ],
                  ),
                );
              },
            ),
          ),

          /// INPUT CHAT BAR
          Container(
            margin: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            height: 54,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: _showMediaMenu,
                  child: const Icon(Icons.add, color: Color(0xff5A4038)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Type a message...",
                      hintStyle: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                   
                        color: const Color(0xffB6B6B6),
                      ),
                    ),
                  ),
                ),
                const Icon(
                  Icons.emoji_emotions_outlined,
                  color: Color(0xff5A4038),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Color(0xff4A241B),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.send, size: 18, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
