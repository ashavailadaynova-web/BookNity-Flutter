import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_room_screen.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return "";
    final DateTime dateTime = timestamp.toDate();
    final DateTime now = DateTime.now();
    final Duration difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return "Baru saja";
    } else if (difference.inHours < 1) {
      return "${difference.inMinutes}m lalu";
    } else if (difference.inDays < 1) {
      return "${difference.inHours}j lalu";
    } else {
      return "${dateTime.day}/${dateTime.month}";
    }
  }

  @override
  Widget build(BuildContext context) {
    final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? "";

    return Scaffold(
      backgroundColor: const Color(0xffF8F6F4),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),

            // Top Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Color(0xff4A342E)),
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

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xff4A241B),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextField(
                  controller: _searchController,
                  style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 15),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    prefixIcon: const Icon(Icons.search, color: Colors.white, size: 22),
                    hintText: "Telusuri obrolan . . .",
                    hintStyle: GoogleFonts.plusJakartaSans(color: Colors.white70, fontSize: 15),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // List Chat Utama
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('chat_rooms')
                    .where('participants', arrayContains: currentUserId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: Color(0xff4A342E)));
                  }

                  // 🟢 JIKA KOSONG DI SINI, MAKA DATABASENYA MEMANG BELUM MENYIMPAN FIELD 'participants'
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.chat_bubble_outline, size: 48, color: Colors.grey),
                          const SizedBox(height: 12),
                          Text(
                            "Belum ada obrolan masuk.",
                            style: GoogleFonts.plusJakartaSans(color: Colors.grey, fontSize: 14),
                          ),
                        ],
                      ),
                    );
                  }

                  final roomDocs = snapshot.data!.docs;

                  return ListView.separated(
                    itemCount: roomDocs.length,
                    separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey.shade200),
                    itemBuilder: (context, index) {
                      final data = roomDocs[index].data() as Map<String, dynamic>;
                      final List<dynamic> participants = data['participants'] ?? [];
                      
                      // Cari ID lawan bicara secara dinamis
                      final String targetId = participants.firstWhere(
                        (id) => id != currentUserId,
                        orElse: () => '',
                      );

                      final String lastMessage = data['lastMessage'] ?? "Mengirim lampiran...";
                      final String chatTime = _formatTimestamp(data['lastTime'] as Timestamp?);
                      final bool isUnread = data['unread'] ?? false;

                      return FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance.collection('users').doc(targetId).get(),
                        builder: (context, userSnapshot) {
                          String roomTitle = "Pengguna Booknity";
                          String profileImg = "";

                          // SINKRONISASI DATA PROFIL USER JIKA ADA
                          if (userSnapshot.hasData && userSnapshot.data!.exists) {
                            final userData = userSnapshot.data!.data() as Map<String, dynamic>;
                            roomTitle = userData['name'] ?? userData['username'] ?? "Pengguna Booknity";
                            profileImg = userData['photoUrl'] ?? userData['profileImage'] ?? userData['image'] ?? "";
                          }

                          // Filter Search Bar
                          if (_searchQuery.isNotEmpty && !roomTitle.toLowerCase().contains(_searchQuery)) {
                            return const SizedBox.shrink();
                          }

                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ChatRoomScreen(sellerId: targetId),
                                ),
                              );
                            },
                            leading: Stack(
                              children: [
                                Container(
                                  width: 56,
                                  height: 56,
                                  decoration: const BoxDecoration(
                                    color: Color(0xffEFECE1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(28),
                                    child: profileImg.isNotEmpty
                                        ? Image.network(
                                            profileImg,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) => 
                                                const Icon(Icons.person, color: Color(0xff4A342E), size: 28),
                                          )
                                        : const Icon(Icons.person, color: Color(0xff4A342E), size: 28),
                                  ),
                                ),
                                if (isUnread)
                                  Positioned(
                                    right: 0,
                                    bottom: 0,
                                    child: Container(
                                      width: 14,
                                      height: 14,
                                      decoration: BoxDecoration(
                                        color: const Color(0xffC64A0F),
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.white, width: 2),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            title: Text(
                              roomTitle,
                              style: GoogleFonts.plusJakartaSans(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: const Color(0xff3B2824),
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                lastMessage,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  color: const Color(0xff777777),
                                ),
                              ),
                            ),
                            trailing: Text(
                              chatTime,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                color: const Color(0xff8D8D8D),
                              ),
                            ),
                          );
                        },
                      );
                    },
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