import 'package:flutter/material.dart';
import '/ui/pages/view/events_page.dart';
import '/ui/pages/view/profile_page.dart';
import '/ui/pages/view/map_page.dart';
import '/ui/pages/view/home_page.dart';
import '/ui/pages/view/settings_page.dart';


class CustomNavBar extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
            color: Colors.yellowAccent,
            padding: EdgeInsets.symmetric(vertical: 10),
            child:
              Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(Icons.home),
                  color: Colors.black,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.list),
                  color: Colors.black,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EventsPage()),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.map),
                  color: Colors.black,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MapPage()),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.person),
                  color: Colors.black,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfilePage()),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.settings),
                  color: Colors.black,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingsPage()),
                    );
                  },
                ),
              ],
            ),
      );
  }
}