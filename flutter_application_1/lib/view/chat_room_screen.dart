import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../model/chat_model.dart';
import '../viewmodel/chat_viewmodel.dart';

class ChatRoomScreen extends StatefulWidget {
  final String sellerId;
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
    final text = controller.text.trim();
    if (text.isEmpty) return;

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

  // ==========================================
  // CARD CUSTOM PENAWARAN (Murni Nego Harga)
  // ==========================================
  Widget _buildCustomOfferMessage(MessageModel message, ChatViewModel chatVm) {
    bool isPending =
        message.type == MessageType.offerPending ||
        message.statusPesanan == "menunggu_konfirmasi" ||
        message.statusPesanan == null;
    bool isAccepted =
        message.type == MessageType.offerAccepted ||
        message.statusPesanan == "disetujui";
    bool isRejected =
        message.statusPesanan == "ditolak" ||
        message.statusPesanan == "dibatalkan";

    Color cardBg = const Color(0xffE8DFC7);
    Color textColor = const Color(0xffC45A1A);
    String labelText = "MENUNGGU PERSETUJUAN";
    if (isRejected) {
      cardBg = Colors.grey.shade200;
      textColor = Colors.grey.shade600;
      labelText = "PENAWARAN DITOLAK";
      isPending = false;
      isAccepted = false;
    } else if (isAccepted) {
      cardBg = const Color(0xffE2F0D9);
      textColor = const Color(0xff385723);
      labelText = "PENAWARAN DITERIMA";
      isPending = false;
    }

    return Container(
      width: 255,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        border: isRejected ? Border.all(color: Colors.black12) : null,
      ),
      child: Column(
        children: [
          Text(
            labelText,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: textColor,
            ),
          ),
          const SizedBox(height: 10),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderDetailScreen(
                    roomId: roomId,
                    messageId: message.id ?? '',
                    bookTitle: message.bookTitle ?? 'Judul Buku',
                    totalPrice: message.price ?? '0',
                    authorName: message.author ?? 'Penulis',
                    addressInfo: "",
                    coverImage: message.cover ?? '',
                    currentStatus: isRejected
                        ? "dibatalkan"
                        : (isAccepted ? "disetujui" : "menunggu_konfirmasi"),
                    isSeller: !message.isMe,
                    isOfferType: true,
                    chatVm: chatVm,
                  ),
                ),
              );
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: message.cover != null && message.cover!.isNotEmpty
                      ? Image.network(
                          message.cover!,
                          width: 55,
                          height: 75,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                width: 55,
                                height: 75,
                                color: Colors.black12,
                                child: const Icon(
                                  Icons.book,
                                  size: 30,
                                  color: Colors.grey,
                                ),
                              ),
                        )
                      : Container(
                          width: 55,
                          height: 75,
                          color: Colors.black12,
                          child: const Icon(
                            Icons.book,
                            size: 30,
                            color: Colors.grey,
                          ),
                        ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message.bookTitle ?? 'Judul Buku',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: isRejected ? Colors.grey : Colors.black,
                        ),
                      ),
                      Text(
                        "oleh ${message.author ?? 'Penulis'}",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Rp. ${message.price ?? '0'}",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: isRejected
                              ? Colors.grey
                              : const Color(0xff4A241B),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          if (isPending && !message.isMe) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 95,
                  height: 32,
                  child: OutlinedButton(
                    onPressed: () {
                      if (message.id != null) {
                        chatVm.updateInvoiceStatus(
                          roomId: roomId,
                          messageId: message.id!,
                          newStatus: "dibatalkan",
                        );
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.redAccent),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      "Tolak",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 95,
                  height: 32,
                  child: ElevatedButton(
                    onPressed: () {
                      if (message.id != null) {
                        chatVm.updateOfferStatus(
                          roomId: roomId,
                          messageId: message.id!,
                          newStatus: MessageType.offerAccepted.name,
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
                      "Terima",
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
          ] else if (isAccepted && message.isMe) ...[
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

  // ==========================================
  // CARD INVOICE/BELI REAL
  // ==========================================
  Widget _buildInvoiceMessage(MessageModel message, ChatViewModel chatVm) {
    final String title =
        (message.bookTitle != null && message.bookTitle!.trim().isNotEmpty)
        ? message.bookTitle!
        : "Buku Novel Booknity";
    final String price =
        (message.price != null && message.price!.trim().isNotEmpty)
        ? message.price!
        : "0";
    final String author =
        (message.author != null && message.author!.trim().isNotEmpty)
        ? message.author!
        : "Penulis";
    final String cover = message.cover ?? '';
    final String currentStatus = message.statusPesanan ?? "menunggu_konfirmasi";

    String addressText = "Jl. Kampus UPN Veteran, Jember (J&T Express)";
    if (message.message != null && message.message.trim().isNotEmpty) {
      addressText = message.message;
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      width: 275,
      decoration: BoxDecoration(
        color: currentStatus == "dibatalkan"
            ? Colors.grey.shade100
            : const Color(0xFFFFFDF9),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: currentStatus == "dibatalkan"
              ? Colors.black12
              : const Color(0xff4A241B).withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrderDetailScreen(
                  roomId: roomId,
                  messageId: message.id ?? '',
                  bookTitle: title,
                  totalPrice: price,
                  authorName: author,
                  addressInfo: addressText,
                  coverImage: cover,
                  currentStatus: currentStatus,
                  isSeller: !message.isMe,
                  isOfferType: false,
                  chatVm: chatVm,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      currentStatus == "dibatalkan"
                          ? Icons.cancel_outlined
                          : Icons.receipt_long_rounded,
                      color: currentStatus == "dibatalkan"
                          ? Colors.grey
                          : const Color(0xffB64B1E),
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _getStatusLabel(currentStatus),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: currentStatus == "dibatalkan"
                            ? Colors.grey
                            : const Color(0xffB64B1E),
                        letterSpacing: 0.3,
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 11,
                      color: Colors.black38,
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Divider(
                    color: Colors.black12,
                    thickness: 1,
                    height: 1,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: cover.isNotEmpty
                            ? Image.network(
                                cover,
                                width: 48,
                                height: 66,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                      width: 48,
                                      height: 66,
                                      color: Colors.black12,
                                      child: const Icon(
                                        Icons.book,
                                        size: 24,
                                        color: Colors.grey,
                                      ),
                                    ),
                              )
                            : Container(
                                width: 48,
                                height: 66,
                                color: Colors.black12,
                                child: const Icon(
                                  Icons.book,
                                  size: 24,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF1A1A1A),
                            ),
                          ),
                          Text(
                            "oleh $author",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              color: Colors.black45,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Total: Rp $price",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xff4A241B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Divider(color: Colors.black12, thickness: 0.5),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Icon(
                        Icons.local_shipping_outlined,
                        size: 14,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        addressText,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case "menunggu_konfirmasi":
        return "MENUNGGU KONFIRMASI";
      case "dikemas":
        return "PESANAN DIKEMAS";
      case "dikirim":
        return "DALAM PERJALANAN";
      case "selesai":
        return "PESANAN SELESAI";
      case "dibatalkan":
        return "PESANAN DIBATALKAN";
      default:
        return "PESANAN DIKONFIRMASI";
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatVm = Provider.of<ChatViewModel>(context, listen: false);
    return Scaffold(
      backgroundColor: const Color(0xffF9F6EE),
      appBar: AppBar(
        backgroundColor: const Color(0xff4A241B),
        foregroundColor: Colors.white,
        titleSpacing: 0,
        title: FutureBuilder<Map<String, dynamic>?>(
          future: chatVm.getSellerProfile(widget.sellerId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Memuat...");
            }

            final sellerData = snapshot.data;
            final sellerName =
                sellerData?['name'] ?? sellerData?['username'] ?? "Penjual";
            final sellerAvatar =
                sellerData?['avatarUrl'] ?? sellerData?['photoUrl'] ?? "";

            return Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.white24,
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
                      "Online",
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
                    bool isInvoice = message.type == MessageType.invoice;
                    bool isOffer =
                        !isInvoice &&
                        message.bookTitle != null &&
                        message.bookTitle!.isNotEmpty &&
                        message.price != null;
                    return Align(
                      alignment: message.isMe
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: message.isMe
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          if (isOffer)
                            _buildCustomOfferMessage(message, chatVm)
                          else if (isInvoice)
                            _buildInvoiceMessage(message, chatVm)
                          else
                            Container(
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
                    onSubmitted: (_) => _sendMessage(),
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
                  onTap: () => _sendMessage(),
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

// ==========================================
// SCREEN DETAIL TRANSAKSI & PENAWARAN (Hanya Ditambah Tombol Batal Sisi Pembeli)
// ==========================================
class OrderDetailScreen extends StatefulWidget {
  final String roomId;
  final String messageId;
  final String bookTitle;
  final String totalPrice;
  final String authorName;
  final String addressInfo;
  final String coverImage;
  final String currentStatus;
  final bool isSeller;
  final bool isOfferType;
  final ChatViewModel chatVm;

  const OrderDetailScreen({
    Key? key,
    required this.roomId,
    required this.messageId,
    required this.bookTitle,
    required this.totalPrice,
    required this.authorName,
    required this.addressInfo,
    required this.coverImage,
    required this.currentStatus,
    required this.isSeller,
    this.isOfferType = false,
    required this.chatVm,
  }) : super(key: key);

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  late String status;

  @override
  void initState() {
    super.initState();
    status = widget.currentStatus;
  }

  void _updateStatusBerurut() {
    if (widget.isOfferType) {
      setState(() {
        status = "disetujui";
      });
      widget.chatVm.updateOfferStatus(
        roomId: widget.roomId,
        messageId: widget.messageId,
        newStatus: MessageType.offerAccepted.name,
      );
    } else {
      String nextStatus = status;
      if (status == "menunggu_konfirmasi")
        nextStatus = "dikemas";
      else if (status == "dikemas")
        nextStatus = "dikirim";
      else if (status == "dikirim")
        nextStatus = "selesai";
      setState(() {
        status = nextStatus;
      });
      widget.chatVm.updateInvoiceStatus(
        roomId: widget.roomId,
        messageId: widget.messageId,
        newStatus: nextStatus,
      );
    }
  }

  void _rejectOffer() {
    // 1. Ubah state visual lokal agar tombol langsung hilang
    setState(() {
      status = "ditolak";
    });

    // 2. 🟢 SOLUSI UTAMA: Gunakan chatVm yang terbukti bekerja di database kamu!
    widget.chatVm.updateInvoiceStatus(
      roomId: widget.roomId,
      messageId: widget.messageId,
      newStatus:
          "ditolak", // Mengubah status menjadi ditolak di sub-koleksi messages
    );

    // 3. Tampilkan feedback ke pengguna
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Penawaran berhasil ditolak"),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  void _cancelOrder() {
    setState(() {
      status = "dibatalkan";
    });
    widget.chatVm.updateInvoiceStatus(
      roomId: widget.roomId,
      messageId: widget.messageId,
      newStatus: "dibatalkan",
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Pesanan berhasil dibatalkan")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String targetId = widget.messageId.isNotEmpty
        ? widget.messageId
        : 'TXT';
    final String idLabel = widget.isOfferType ? "ID Penawaran" : "ID Transaksi";
    final String transactionId =
        "BKN-${targetId.length > 5 ? targetId.substring(0, 5) : targetId}";

    int activeStep = 0;
    if (status == "dikemas" || status == "disetujui") activeStep = 1;
    if (status == "dikirim") activeStep = 2;
    if (status == "selesai") activeStep = 3;
    if (status == "dibatalkan") activeStep = -1;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F6EE),
      appBar: AppBar(
        backgroundColor: const Color(0xff4A241B),
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          widget.isOfferType ? "Detail Penawaran" : "Detail Transaksi",
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusCard(activeStep),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Detail Buku",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xff4A241B),
                        ),
                      ),
                      Text(
                        "$idLabel: $transactionId",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(height: 1, color: Colors.black12),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: widget.coverImage.isNotEmpty
                              ? Image.network(
                                  widget.coverImage,
                                  height: 90,
                                  width: 65,
                                  fit: BoxFit.cover,
                                  errorBuilder: (c, e, s) => Container(
                                    width: 65,
                                    height: 90,
                                    color: Colors.black12,
                                    child: const Icon(
                                      Icons.book,
                                      size: 35,
                                      color: Colors.grey,
                                    ),
                                  ),
                                )
                              : Container(
                                  width: 65,
                                  height: 90,
                                  color: Colors.black12,
                                  child: const Icon(
                                    Icons.book,
                                    size: 35,
                                    color: Colors.grey,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.bookTitle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF1A1A1A),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "oleh ${widget.authorName}",
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.isOfferType
                                  ? "Harga Ajuan: Rp ${widget.totalPrice}"
                                  : "Harga Buku: Rp ${widget.totalPrice}",
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xffB64B1E),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            if (!widget.isOfferType) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.local_shipping_outlined,
                          color: Color(0xff4A241B),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Informasi Pengiriman",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xff4A241B),
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Divider(height: 1, color: Colors.black12),
                    ),
                    Text(
                      widget.addressInfo,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: const Color(0xFF4A4A4A),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.isOfferType
                        ? "Nilai Penawaran"
                        : "Ringkasan Pembayaran",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xff4A241B),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildPriceRow(
                    widget.isOfferType
                        ? "Nominal yang Ditawarkan"
                        : "Harga Buku",
                    "Rp ${widget.totalPrice}",
                  ),
                  if (!widget.isOfferType) ...[
                    _buildPriceRow("Biaya Pengiriman", "Sudah Termasuk"),
                    _buildPriceRow("Biaya Layanan Sistem", "Rp 2.500"),
                  ],
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Divider(height: 1, color: Colors.black12),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.isOfferType
                            ? "Total Kesepakatan"
                            : "Total Bayar",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        status == "dibatalkan"
                            ? "Rp 0"
                            : "Rp ${widget.totalPrice}",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: status == "dibatalkan"
                              ? Colors.grey
                              : const Color(0xffB64B1E),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ==========================================
            // BLOK LOGIKA TOMBOL AKSI UTAMA & BATAL
            // ==========================================
            if (widget.isSeller) ...[
              // === SISI PENJUAL (Sesuai Kode Asli Kamu) ===
              if (status == "menunggu_konfirmasi") ...[
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: OutlinedButton(
                          onPressed: () {
                            if (widget.isOfferType) {
                              _rejectOffer(); // 🟢 SEKARANG HAPUS await di sini karena fungsinya sudah jadi void biasa
                            } else {
                              _cancelOrder(); // Ini juga tetap void biasa tanpa await
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: Colors.redAccent,
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            widget.isOfferType
                                ? "Tolak Penawaran"
                                : "Tolak Pesanan",
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (widget.isOfferType) ...[
                      const SizedBox(width: 12),
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _updateStatusBerurut,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff4A241B),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Text(
                              "Terima Penawaran",
                              style: GoogleFonts.plusJakartaSans(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ] else if (!widget.isOfferType &&
                  status != "selesai" &&
                  status != "dibatalkan") ...[
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _updateStatusBerurut,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff4A241B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      status == "dikemas"
                          ? "Konfirmasi Siap Dikirim"
                          : "Selesaikan Pesanan",
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ] else ...[
              // === SISI PEMBELI (Ditambah Tombol Batalkan Pesanan Tanpa Ubah Desain) ===
              if (!widget.isOfferType &&
                  (status == "menunggu_konfirmasi" || status == "dikemas")) ...[
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton(
                    onPressed: _cancelOrder,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: Colors.redAccent,
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      "Batalkan Pesanan",
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(int activeStep) {
    if (status == "dibatalkan") {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.red.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.cancel, color: Colors.redAccent, size: 24),
            const SizedBox(width: 12),
            Text(
              widget.isOfferType ? "Penawaran ditolak." : "Pesanan dibatalkan.",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
              ),
            ),
          ],
        ),
      );
    }

    if (status == "disetujui") {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.green.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 24),
            const SizedBox(width: 12),
            Text(
              "Penawaran disetujui penjual.",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
      );
    }

    String textHeadline = widget.isOfferType
        ? "MENUNGGU PERSETUJUAN"
        : "MENUNGGU KONFIRMASI";
    if (activeStep == 1) textHeadline = "PESANAN DIKEMAS";
    if (activeStep == 2) textHeadline = "DALAM PERJALANAN";
    if (activeStep == 3) textHeadline = "PESANAN SELESAI";

    final List<String> statusSteps = widget.isOfferType
        ? ["Diajukan", "Selesai"]
        : ["Konfirmasi", "Kemas", "Perjalanan", "Selesai"];
    final List<IconData> statusIcons = widget.isOfferType
        ? [Icons.edit_note_rounded, Icons.check_circle_rounded]
        : [
            Icons.assignment_turned_in_rounded,
            Icons.inventory_2_rounded,
            Icons.local_shipping_rounded,
            Icons.check_circle_rounded,
          ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Status",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xffB64B1E).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    textHeadline,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xffB64B1E),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(statusSteps.length, (index) {
              bool isPassed = index <= activeStep;
              bool isCurrent = index == activeStep;

              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isPassed
                              ? const Color(0xff4A241B)
                              : Colors.grey.shade300,
                          border: isCurrent
                              ? Border.all(
                                  color: const Color(0xffB64B1E),
                                  width: 2,
                                )
                              : null,
                        ),
                        child: Center(
                          child: Icon(
                            statusIcons[index],
                            size: 15,
                            color: isPassed
                                ? Colors.white
                                : Colors.grey.shade600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        statusSteps[index],
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: isCurrent
                              ? FontWeight.bold
                              : FontWeight.w500,
                          color: isCurrent
                              ? const Color(0xff4A241B)
                              : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  if (index < statusSteps.length - 1)
                    Container(
                      width:
                          MediaQuery.of(context).size.width *
                          (widget.isOfferType ? 0.35 : 0.12),
                      height: 3,
                      margin: const EdgeInsets.only(
                        bottom: 16,
                        left: 4,
                        right: 4,
                      ),
                      color: index < activeStep
                          ? const Color(0xff4A241B)
                          : Colors.grey.shade300,
                    ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
