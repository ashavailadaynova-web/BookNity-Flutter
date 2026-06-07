// Ganti seluruh notifikasi_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../viewmodel/notification_viewmodel.dart';
import '../../model/notification_model.dart';
import '../chat_room_screen.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NotificationViewModel(),
      child: const _NotificationView(),
    );
  }
}

class _NotificationView extends StatelessWidget {
  const _NotificationView();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<NotificationViewModel>();

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
          actions: [
            if (vm.unreadCount > 0)
              TextButton(
                onPressed: () => vm.markAllAsRead(),
                child: const Text(
                  'Baca Semua',
                  style: TextStyle(
                    color: Color(0xFF9E3422),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
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
        body: vm.isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xFF9E3422)),
              )
            : TabBarView(
                children: [
                  _NotifList(filter: 'all'),
                  _NotifList(filter: 'unread'),
                  _NotifList(filter: 'read'),
                ],
              ),
      ),
    );
  }
}

class _NotifList extends StatelessWidget {
  final String filter;
  const _NotifList({required this.filter});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<NotificationViewModel>();
    final list = vm.getNotifications(filter);

    if (list.isEmpty) {
      return const Center(
        child: Text(
          'Tidak ada notifikasi',
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
      );
    }

    String currentSection = '';
    List<Widget> items = [];

    for (final notif in list) {
      if (notif.section != currentSection) {
        currentSection = notif.section;
        items.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 8, top: 4),
            child: Text(
              currentSection,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                fontSize: 14,
              ),
            ),
          ),
        );
      }
      items.add(_NotifCard(notif: notif));
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
      children: items,
    );
  }
}

class _NotifCard extends StatelessWidget {
  final NotificationModel notif;
  const _NotifCard({required this.notif});

  @override
  Widget build(BuildContext context) {
    final vm = context.read<NotificationViewModel>();

    return GestureDetector(
      onTap: () {
        vm.markAsRead(notif.id);
        if ((notif.type == 'message' ||
                notif.type == 'offer_accepted' ||
                notif.type == 'offer_rejected') &&
            notif.sellerId != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChatRoomScreen(sellerId: notif.sellerId!),
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: notif.isUnread ? const Color(0xFFFFF8F5) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: notif.isUnread
              ? Border.all(color: const Color(0xFF9E3422).withOpacity(0.2))
              : null,
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
              decoration: BoxDecoration(
                color: _iconBgColor(notif.type),
                shape: BoxShape.circle,
              ),
              child: Icon(notif.icon, color: _iconColor(notif.type), size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          notif.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: notif.isUnread
                                ? const Color(0xFF3E2723)
                                : Colors.black87,
                          ),
                        ),
                      ),
                      Text(
                        notif.timeAgo,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notif.text,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            if (notif.isUnread)
              Container(
                margin: const EdgeInsets.only(left: 8, top: 4),
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFF9E3422),
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _iconBgColor(String type) {
    switch (type) {
      case 'offer_accepted':
        return const Color(0xFFE8F5E9);
      case 'offer_rejected':
        return const Color(0xFFFFEBEE);
      case 'order_status':
        return const Color(0xFFE3F2FD);
      default:
        return const Color(0xFFF5EFE6);
    }
  }

  Color _iconColor(String type) {
    switch (type) {
      case 'offer_accepted':
        return Colors.green;
      case 'offer_rejected':
        return Colors.redAccent;
      case 'order_status':
        return Colors.blue;
      default:
        return const Color(0xFF4E342E);
    }
  }
}
