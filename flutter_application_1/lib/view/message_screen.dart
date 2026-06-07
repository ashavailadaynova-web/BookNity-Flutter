import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'chat_room_screen.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 🟢 PERBAIKAN: Menambahkan properti sellerId ke data dummy agar sinkron dengan ChatRoomScreen
    final List<ChatModel> chats = [
      ChatModel(
        sellerId: "Sabian Adam",
        name: "Sabian Adam",
        message: "I'll take that deh kak",
        time: "2m ago",
        image: "https://i.pravatar.cc/150?img=1",
        unread: true,
      ),
      ChatModel(
        sellerId: "Toko Buku Aceng",
        name: "Toko Buku Aceng",
        message: "Baik kak, terima kasih. Bukunya...",
        time: "2m ago",
        image: "https://i.pravatar.cc/150?img=2",
        unread: true,
      ),
      ChatModel(
        sellerId: "Vintage Book Find",
        name: "Vintage Book Find",
        message: "Thanks for the recommendation...",
        time: "2m ago",
        image: "https://i.pravatar.cc/150?img=3",
        unread: false,
      ),
      ChatModel(
        sellerId: "Helena",
        name: "Helena",
        message: "Yah, yaudah deh kak next time aja",
        time: "2m ago",
        image: "https://i.pravatar.cc/150?img=4",
        unread: false,
      ),
      ChatModel(
        sellerId: "Juno Malik",
        name: "Juno Malik",
        message: "Engga jadi deh, kakaknya galak",
        time: "2m ago",
        image: "https://i.pravatar.cc/150?img=5",
        unread: false,
      ),
      ChatModel(
        sellerId: "Humpty Hamster",
        name: "Humpty Hamster",
        message: "Okay kak Terimakasih",
        time: "2m ago",
        image: "https://i.pravatar.cc/150?img=6",
        unread: true,
      ),
      ChatModel(
        sellerId: "Salma",
        name: "Salma",
        message: "Thanks a lot kak",
        time: "2m ago",
        image: "https://i.pravatar.cc/150?img=7",
        unread: false,
      ),
      ChatModel(
        sellerId: "Calista Jajan Buku",
        name: "Calista Jajan Buku",
        message: "MAKACI KAK",
        time: "2m ago",
        image: "https://i.pravatar.cc/150?img=8",
        unread: false,
      ),
      ChatModel(
        sellerId: "Baskara Keenan",
        name: "Baskara Keenan",
        message: "Finally my istri pulang, ditunggu barangnya",
        time: "2m ago",
        image: "https://i.pravatar.cc/150?img=9",
        unread: false,
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xffF8F6F4),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Color(0xff4A342E),
                    ),
                  ),

                  Expanded(
                    child: Center(
                      child: Text(
                        "Kotak Pesan",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xff4A342E),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 48),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xff4A241B),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 22,
                    ),
                    hintText: "Telusuri obrolan . . .",
                    hintStyle: GoogleFonts.plusJakartaSans(
                      color: Colors.white70,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.separated(
                itemCount: chats.length,
                separatorBuilder: (_, __) =>
                    Divider(height: 1, color: Colors.grey.shade200),
                itemBuilder: (context, index) {
                  final chat = chats[index];

                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    onTap: () {
                      // 🟢 PERBAIKAN UTAMA: Mengubah parameter roomId menjadi sellerId sesuai konstruktor ChatRoomScreen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ChatRoomScreen(sellerId: chat.sellerId),
                        ),
                      );
                    },
                    leading: Stack(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundImage: NetworkImage(chat.image),
                        ),
                        if (chat.unread)
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              width: 14,
                              height: 14,
                              decoration: BoxDecoration(
                                color: const Color(0xffC64A0F),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    title: Text(
                      chat.name,
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: const Color(0xff3B2824),
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        chat.message,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          color: const Color(0xff777777),
                        ),
                      ),
                    ),
                    trailing: Text(
                      chat.time,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: const Color(0xff8D8D8D),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatModel {
  // 🟢 PERBAIKAN: Menambahkan parameter properti sellerId ke dalam objek model chat
  final String sellerId;
  final String name;
  final String message;
  final String time;
  final String image;
  final bool unread;

  ChatModel({
    required this.sellerId,
    required this.name,
    required this.message,
    required this.time,
    required this.image,
    required this.unread,
  });
}
