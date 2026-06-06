import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../model/chat_model.dart';
import '../../viewmodel/chat_viewmodel.dart'; // Sesuaikan folder Controller timmu

class ChatRoomScreen extends StatefulWidget {
  final String roomId;
  final String currentUserId;

  const ChatRoomScreen({
    super.key,
    this.roomId = "room_dummy_1",
    this.currentUserId = "user_pembeli",
  });

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final TextEditingController controller = TextEditingController();
  final ChatViewModel _chatViewModel = ChatViewModel(); // Menggunakan class ViewModel Inez

  // --- REPARASI LIST MOCKUP BIAR TIDAK MERAH LAGI ---
  List<MessageModel> get _defaultMockupMessages => [
        MessageModel(
          id: 'm1',
          senderId: widget.currentUserId,
          message: '', // Kosong karena ini tipe kartu penawaran
          timestamp: DateTime.now(),
          type: MessageType.offerPending,
          time: "10:45 AM",
          bookTitle: "Laut Bercerita",
          author: "Leila S Chudori",
          price: "55.000",
          cover: "https://covers.openlibrary.org/b/id/14613167-L.jpg",
        ),
        MessageModel(
          id: 'm2',
          senderId: "other_user",
          message: "Mohon tunggu respon penawaran dari penjual",
          timestamp: DateTime.now(),
          type: MessageType.text,
          time: "10:46 AM",
        ),
        MessageModel(
          id: 'm3',
          senderId: "other_user",
          message: "Halo kak, terima kasih sudah berkunjung di Toko kami.",
          timestamp: DateTime.now(),
          type: MessageType.text,
          time: "11:00 AM",
        ),
      ];

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
                  leading: const Icon(Icons.camera_alt, color: Color(0xff4A241B)),
                  title: Text("Ambil Foto", style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600)),
                  onTap: () => Navigator.pop(context),
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library, color: Color(0xff4A241B)),
                  title: Text("Pilih dari Galeri", style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600)),
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _actionSendMessage() {
    if (controller.text.trim().isEmpty) return;
    _chatViewModel.sendMessage(
      roomId: widget.roomId,
      senderId: widget.currentUserId,
      messageText: controller.text, // <--- UBAH 'text:' MENJADI 'messageText:'
    );
    
    controller.clear();
  }

  Widget _buildCustomOfferMessage(MessageModel message) {
    String currentCover = message.cover ?? "https://covers.openlibrary.org/b/id/14613167-L.jpg";
    String currentTitle = message.bookTitle ?? "Laut Bercerita";
    String currentAuthor = message.author ?? "Leila S Chudori";
    String currentPrice = message.price ?? "55.000";

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
                currentCover,
                width: 55,
                height: 75,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.book, size: 55),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "MENUNGGU PENAWARAN",
                    style: GoogleFonts.plusJakartaSans(fontSize: 8, fontWeight: FontWeight.w800, color: const Color(0xffC45A1A)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Penawaran kamu",
                    style: GoogleFonts.plusJakartaSans(fontSize: 11, color: const Color(0xffC45A1A), fontWeight: FontWeight.w600),
                  ),
                  Text(
                    currentTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  Text("oleh $currentAuthor", style: GoogleFonts.plusJakartaSans(fontSize: 11, color: Colors.black54)),
                  const SizedBox(height: 4),
                  Text("Rp. $currentPrice", style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w700)),
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
              style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w800, color: const Color(0xffC45A1A)),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    currentCover,
                    width: 50,
                    height: 70,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("With Offer", style: GoogleFonts.plusJakartaSans(fontSize: 12, color: const Color(0xffC45A1A))),
                      Text(currentTitle, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700)),
                      Text("oleh $currentAuthor", style: GoogleFonts.plusJakartaSans(fontSize: 11, color: Colors.black54)),
                      Text("Rp. $currentPrice", style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 18)),
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: Text(
                  "Continue to Payment",
                  style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    bool checkIsMe(MessageModel msg) {
      if (msg.id.startsWith('m')) {
        return msg.senderId == widget.currentUserId;
      }
      return msg.isMe;
    }

    return Scaffold(
      backgroundColor: const Color(0xffF9F6EE),
      appBar: AppBar(
        title: const Text("Chat Room"),
        backgroundColor: const Color(0xff4A241B),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
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
                        Text("Produk kamu", style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w700, color: const Color(0xffD36A1D))),
                        const SizedBox(height: 2),
                        Text("Teka Teki Rumah Aneh", maxLines: 2, overflow: TextOverflow.ellipsis, style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700, color: const Color(0xff2D2D2D))),
                        const SizedBox(height: 2),
                        Text("Oleh Uketsu", style: GoogleFonts.plusJakartaSans(fontSize: 10, color: const Color(0xff777777))),
                        const SizedBox(height: 2),
                        Text("Rp. 45.000", style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w700, color: const Color(0xff2D2D2D))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          Expanded(
            child: StreamBuilder<List<MessageModel>>(
              stream: _chatViewModel.streamMessages(widget.roomId, widget.currentUserId),
              initialData: _defaultMockupMessages, // Menampilkan data bawaan jika Firebase kosong
              builder: (context, snapshot) {
                final firebaseMessages = snapshot.data ?? _defaultMockupMessages;

                return ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: firebaseMessages.length,
                  itemBuilder: (context, index) {
                    final message = firebaseMessages[index];
                    bool isOffer = message.type == MessageType.offerPending || message.type == MessageType.offerAccepted;
                    bool itemIsMe = checkIsMe(message);

                    return Align(
                      alignment: itemIsMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: itemIsMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          isOffer
                              ? _buildCustomOfferMessage(message)
                              : Container(
                                  constraints: const BoxConstraints(maxWidth: 260),
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                  decoration: BoxDecoration(
                                    color: itemIsMe ? const Color(0xff4A241B) : Colors.white,
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: Text(
                                    message.message, // Menampilkan field .message sesuai model kamu
                                    style: GoogleFonts.plusJakartaSans(
                                      color: itemIsMe ? Colors.white : Colors.black,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                          const SizedBox(height: 6),
                          Text(
                            message.time, // Menampilkan teks jam desaimu
                            style: GoogleFonts.plusJakartaSans(fontSize: 10, color: const Color(0xffB4AEA8)),
                          ),
                          const SizedBox(height: 18),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            height: 54,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 4)),
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
                      hintStyle: GoogleFonts.plusJakartaSans(fontSize: 14, color: const Color(0xffB6B6B6)),
                    ),
                    onSubmitted: (_) => _actionSendMessage(),
                  ),
                ),
                const Icon(Icons.emoji_emotions_outlined, color: Color(0xff5A4038)),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _actionSendMessage,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(color: Color(0xff4A241B), shape: BoxShape.circle),
                    child: const Icon(Icons.send, size: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}