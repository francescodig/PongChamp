import 'package:PongChamp/data/services/auth_service.dart';
import 'package:PongChamp/ui/pages/view/events_page.dart';
import 'package:flutter/material.dart';
import '/ui/pages/view/profile_page.dart';
import '/ui/pages/view/map_page.dart';
import '/ui/pages/view/home_page.dart';
import '/ui/pages/view/settings_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:PongChamp/domain/functions/utility.dart';


class CustomNavBar extends StatelessWidget{

  late final String currentUserId;
  final AuthService _authService = AuthService();



  @override
  Widget build(BuildContext context) {

    // Funzione per navigare a una nuova pagina e rimuovere le precedenti
    // Questa funzione viene chiamata quando si preme un'icona nella barra di navigazione
    // e controlla se la rotta corrente è diversa dalla nuova rotta
    // Se è diversa, naviga alla nuova pagina e rimuove le precedenti
    // Se è la stessa, non fa nulla
    // per evitare di ricreare la pagina corrente


    return Container(
            color: Color.fromARGB(255, 245, 192, 41),
            padding: EdgeInsets.symmetric(vertical: 10),
            child:
              Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(Icons.home),
                  color: Colors.black,
                  onPressed: () {
                    currentUserId = _authService.currentUserId!;
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) =>  HomePage(currentUserId: currentUserId)),
                      (Route<dynamic> route) => false,
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.list),
                  color: Colors.black,
                  onPressed: () {
                    navigateTo(context ,EventsPage(), '/events'); // Naviga alla EventsPage
                  },
                ),
                IconButton(
                  icon: Icon(Icons.map),
                  color: Colors.black,
                  onPressed: () {
                    navigateTo(context, MapPage(), '/map'); // Naviga alla MapPage
                  },
                ),
                IconButton(
                  icon: Icon(Icons.person),
                  color: Colors.black,
                  onPressed: () async {
                    String userId = FirebaseAuth.instance.currentUser!.uid;
                    // naviga passando l'userId alla ProfilePage
                    navigateTo(context, ProfilePage(userId: userId), '/profile_$userId'); // Naviga alla ProfilePage
                  },
                ),
                IconButton(
                  icon: Icon(Icons.settings),
                  color: Colors.black,
                  onPressed: () {
                    navigateTo(context, SettingsPage(), '/settings'); // Naviga alla SettingsPage
                  },
                ),
              ],
            ),
      );
  }
}