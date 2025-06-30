import 'package:PongChamp/domain/functions/utility.dart';
import 'package:PongChamp/ui/pages/view/home_page.dart';
import 'package:PongChamp/ui/pages/view/notifications_page.dart';
import 'package:PongChamp/ui/pages/view/search_page.dart';
import 'package:badges/badges.dart' as badges; // Import del pacchetto badges
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:PongChamp/data/services/auth_service.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  final AuthService _authService = AuthService();
  late final String currentUserId;

  @override
  void initState() {
    super.initState();
    currentUserId = _authService.currentUserId!;
  }

  @override
  Widget build(BuildContext context) {
    final CollectionReference notificationsCollection =
        FirebaseFirestore.instance.collection("UserNotifications");

    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 120,
      backgroundColor: const Color.fromARGB(255, 245, 192, 41),
      title: GestureDetector(
        onTap: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => HomePage(currentUserId: currentUserId)),
            (route) => false,
          );
        },
        child: SizedBox(
          height: 70,
          child: Image.asset(
            'assets/logo.png',
            fit: BoxFit.contain,
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.all(10),
      actions: [
        IconButton(
          iconSize: 30,
          icon: const Icon(Icons.search, color: Colors.black),
          onPressed: () {
            navigateTo(context, SearchPage(), '/search');
          },
        ),
        StreamBuilder<QuerySnapshot>(
          stream: notificationsCollection
              .where('userId', isEqualTo: currentUserId)
              .where('read', isEqualTo: false)
              .snapshots(),
          builder: (context, snapshot) {
            int unreadCount = 0;
            if (snapshot.hasData) {
              unreadCount = snapshot.data!.docs.length;
            }
            
            return badges.Badge(
              position: badges.BadgePosition.topEnd(top: -5, end: -5),
              badgeContent: Text(
                unreadCount > 0 ? unreadCount.toString() : '',
                style: const TextStyle(color: Colors.white, fontSize: 10),
              ),
              showBadge: unreadCount > 0,
              badgeColor: Colors.red,
              padding: EdgeInsets.all(5),
              child: IconButton(
                iconSize: 30,
                icon: const Icon(Icons.notifications_none, color: Colors.black),
                onPressed: () {
                  navigateTo(context, NotificationsPage(), '/notifications');
                },
              ),
            );
          },
        ),
      ],
    );
  }
}