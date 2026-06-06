import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../model/chat_model.dart';
import '../viewmodel/chat_viewmodel.dart';

class ChatRoomScreen extends StatefulWidget {
  final String
  sellerId; // 🟢 Mengikuti request halaman Detail: Cukup oper sellerId

  const ChatRoomScreen({super.key, required this.sellerId});

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final TextEditingController controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late String roomId;

  @override
  void initState() {
    super.initState();
    // Generate roomId otomatis menggunakan ID Pembeli (current) dan ID Penjual
    final chatVm = Provider.of<ChatViewModel>(context, listen: false);
    roomId = chatVm.getRoomId(chatVm.currentUserId, widget.sellerId);

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _scrollToBottom(animated: false),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom({bool animated = true}) {
    if (_scrollController.hasClients) {
      if (animated) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      } else {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    }
  }

  void _sendMessage() {
    // 🟢 PASTIKAN KOSONG TANPA PARAMETER
    final text = controller.text.trim();
    if (text.isEmpty) return;

    // Mengambil chatVm langsung menggunakan context di dalam fungsi
    final chatVm = Provider.of<ChatViewModel>(context, listen: false);
    chatVm.sendMessage(roomId: roomId, text: text);

    controller.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

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
                  onTap: () => Navigator.pop(context),
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
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCustomOfferMessage(MessageModel message, ChatViewModel chatVm) {
    bool isPending = message.type == MessageType.offerPending;

    return Container(
      width: 255,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xffE8DFC7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            isPending ? "MENUNGGU PENAWARAN" : "PENAWARAN DITERIMA",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: const Color(0xffC45A1A),
            ),
          ),
          const SizedBox(height: 10),
          Row(
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
                      message.bookTitle ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
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
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (isPending && !message.isMe) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: 160,
              height: 34,
              child: ElevatedButton(
                onPressed: () {
                  if (message.id != null) {
                    chatVm.updateOfferStatus(
                      roomId: roomId,
                      messageId: message.id!,
                      newStatus: MessageType.offerAccepted,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffB64B1E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  "Terima Penawaran",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ] else if (!isPending) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: 180,
              height: 34,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
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
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final chatVm = Provider.of<ChatViewModel>(context, listen: false);

    return Scaffold(
      backgroundColor: const Color(0xffF9F6EE),
      appBar: AppBar(
        backgroundColor: const Color(0xff4A241B),
        foregroundColor: Colors.white,
        titleSpacing: 0, // Agar foto profil dekat dengan tombol back
        title: FutureBuilder<Map<String, dynamic>?>(
          // Kita panggil fungsi ambil data penjual dari ViewModel (akan dibuat di Langkah 2)
          future: chatVm.getSellerProfile(widget.sellerId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Memuat...");
            }

            // Ambil data nama dan foto, beri nilai default jika data di Firestore kosong
            final sellerData = snapshot.data;
            final sellerName =
                sellerData?['name'] ?? sellerData?['username'] ?? "Penjual";
            final sellerAvatar =
                sellerData?['avatarUrl'] ?? sellerData?['photoUrl'] ?? "";

            return Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.grey.shade300,
                  backgroundImage: sellerAvatar.isNotEmpty
                      ? NetworkImage(sellerAvatar)
                      : null,
                  child: sellerAvatar.isEmpty
                      ? const Icon(Icons.person, color: Colors.white, size: 20)
                      : null,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      sellerName,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "Online", // Opsional, bisa diganti status lain
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: Colors.greenAccent,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Expanded(
            child: StreamBuilder<List<MessageModel>>(
              stream: chatVm.streamMessages(roomId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("Belum ada pesan."));
                }

                final firebaseMessages = snapshot.data!;
                WidgetsBinding.instance.addPostFrameCallback(
                  (_) => _scrollToBottom(),
                );

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: firebaseMessages.length,
                  itemBuilder: (context, index) {
                    final message = firebaseMessages[index];
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
                          isOffer
                              ? _buildCustomOfferMessage(message, chatVm)
                              : Container(
                                  constraints: const BoxConstraints(
                                    maxWidth: 260,
                                  ),
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
                                    message.message,
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
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
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
                    onSubmitted: (_) =>
                        _sendMessage(), // 🟢 DIUBAH: Hapus (chatVm)
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
                InkWell(
                  onTap: () =>
                      _sendMessage(), // 🟢 DIGANTI: dari onPressed menjadi onTap
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Color(0xff4A241B),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.send,
                      size: 18,
                      color: Colors.white,
                    ),
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
