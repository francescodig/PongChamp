import 'package:PongChamp/ui/pages/view/events_page.dart';
import 'package:flutter/material.dart';
import '/ui/pages/view/profile_page.dart';
import '/ui/pages/view/map_page.dart';
import '/ui/pages/view/home_page.dart';
import '/ui/pages/view/settings_page.dart';
import 'package:firebase_auth/firebase_auth.dart';


class CustomNavBar extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    String currentRoute = ModalRoute.of(context)?.settings.name ?? '';

    // Funzione per navigare a una nuova pagina e rimuovere le precedenti
    // Questa funzione viene chiamata quando si preme un'icona nella barra di navigazione
    // e controlla se la rotta corrente è diversa dalla nuova rotta
    // Se è diversa, naviga alla nuova pagina e rimuove le precedenti
    // Se è la stessa, non fa nulla
    // per evitare di ricreare la pagina corrente
   void navigateTo(Widget page, String routeName) {
      if (currentRoute != routeName) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => page,
            settings: RouteSettings(name: routeName),
          ),
          (route) => route.isFirst, //Prende la route e ne conserva solo la prima (presumibilmente Home)
        );
      }
    }


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
                    navigateTo(HomePage(), '/home'); // Naviga alla HomePage
                  },
                ),
                IconButton(
                  icon: Icon(Icons.list),
                  color: Colors.black,
                  onPressed: () {
                    navigateTo(EventsPage(), '/events'); // Naviga alla EventsPage
                  },
                ),
                IconButton(
                  icon: Icon(Icons.map),
                  color: Colors.black,
                  onPressed: () {
                    navigateTo(MapPage(), '/map'); // Naviga alla MapPage
                  },
                ),
                IconButton(
                  icon: Icon(Icons.person),
                  color: Colors.black,
                  onPressed: () async {
                    String userId = FirebaseAuth.instance.currentUser!.uid;
                    // naviga passando l'userId alla ProfilePage
                    navigateTo(ProfilePage(userId: userId), '/profile');
                  },
                ),
                IconButton(
                  icon: Icon(Icons.settings),
                  color: Colors.black,
                  onPressed: () {
                    navigateTo(SettingsPage(), '/settings'); // Naviga alla SettingsPage
                  },
                ),
              ],
            ),
      );
  }
}