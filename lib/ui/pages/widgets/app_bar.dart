import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget{
  @override
  Size get preferredSize => Size.fromHeight(80);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      actionsPadding: EdgeInsets.all(10),
      toolbarHeight: 80,
      centerTitle: true,
      backgroundColor: Colors.yellowAccent,
      title: Text("PongChamp", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)
      ),
      leading: 
        IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      actions: [
        Row(
          spacing: 10,
          children: [
            IconButton(
              iconSize: 30,
              icon: Icon(Icons.account_circle_outlined, color: Colors.black),
              onPressed: () {},
            ),
            IconButton(
              iconSize: 30,
              icon: Icon(Icons.chat_outlined, color: Colors.black),
              onPressed: () {},
            ),
      ]),        
      ],
    );
  }
}