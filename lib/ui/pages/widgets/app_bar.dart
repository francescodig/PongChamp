import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget{
  @override
  Size get preferredSize => Size.fromHeight(80);
  @override
  Widget build(BuildContext context) {
   return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 120,
      backgroundColor: Color.fromARGB(255, 245, 192, 41),
      title: Row(
        children: [
          SizedBox(
            height: 70,
            child: Image.asset(
              'assets/logo.png',
              fit: BoxFit.contain,
            ),
          ),
          // Se vuoi lasciare un po' di spazio dopo il logo:
          SizedBox(width: 10),
        ],
      ),
      actionsPadding: EdgeInsets.all(10),
      actions: [
        IconButton(
          iconSize: 30,
          icon: Icon(Icons.chat_outlined, color: Colors.black),
          onPressed: () {},
        ),
        IconButton(
          iconSize: 30,
          icon: Icon(Icons.notifications_none, color: Colors.black),
          onPressed: () {},
        ),
      ],
    );
  }
}