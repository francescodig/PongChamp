import 'package:PongChamp/ui/pages/view/home_page.dart';
import 'package:PongChamp/ui/pages/view/search_page.dart';
import 'package:flutter/material.dart';
import 'package:PongChamp/domain/functions/utility.dart';


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
        GestureDetector(
          onTap: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
              (Route<dynamic> route) => false, // Rimuove tutte le pagine
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
        const SizedBox(width: 10),
      ],

      ),
      actionsPadding: EdgeInsets.all(10),
      actions: [
        IconButton(
          iconSize: 30,
          icon: Icon(Icons.search, color: Colors.black),
          onPressed: () {
            navigateTo(context, SearchPage(), '/search'); // Naviga alla SearchPage
          },
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