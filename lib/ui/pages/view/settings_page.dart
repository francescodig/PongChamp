import 'package:PongChamp/ui/pages/view/edit_profile.dart';
import 'package:PongChamp/ui/pages/view/informazioni_page.dart';
import 'package:PongChamp/ui/pages/view/legal_notes_page.dart';
import 'package:PongChamp/ui/pages/view/login_page.dart';
import 'package:PongChamp/ui/pages/view/privacy_page.dart';
import 'package:PongChamp/ui/pages/viewmodel/edit_profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/ui/pages/view/profile_page.dart';
import '/ui/pages/widgets/bottom_navbar.dart';
import '/ui/pages/widgets/app_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: CustomAppBar(),
      body: 
        Container(
          margin: EdgeInsets.all(12),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.black),
          ),
          child: Column(
            spacing: 20,
            children: [
              Text("Impostazioni",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold
                ),            
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                spacing: 7,
                children: [
                  Container( 
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    margin: EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black), // colore del contorno
                      borderRadius: BorderRadius.circular(8),  // bordi arrotondati
                      color: Colors.white, // colore sfondo (opzionale)
                    ),
                    child:
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Informazioni App"),
                          IconButton(onPressed: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => PrivacyPage()),
                            );                            
                          },
                            icon: Icon(Icons.arrow_right,size: 35,))
                        ],
                      ),
                      ),
                  Container( 
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    margin: EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black), // colore del contorno
                      borderRadius: BorderRadius.circular(8),  // bordi arrotondati
                      color: Colors.white, // colore sfondo (opzionale)
                    ),
                    child:
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Modifica Profilo"),
                          IconButton(
                            onPressed: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ChangeNotifierProvider(
                                    create: (_) => EditProfileViewModel(),
                                    child: EditProfilePage(),
                                  ),
                                ),
                              );

                            },icon: Icon(Icons.arrow_right,size: 35,)
                          ),
                        ],
                      ),
                      ),
                  Container( 
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    margin: EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black), // colore del contorno
                      borderRadius: BorderRadius.circular(8),  // bordi arrotondati
                      color: Colors.white, // colore sfondo (opzionale)
                    ),
                    child:
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Lingua"),
                          IconButton(onPressed: (){}, icon: Icon(Icons.arrow_right,size: 35,))
                        ],
                      ),
                      ),
                  Container( 
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    margin: EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black), // colore del contorno
                      borderRadius: BorderRadius.circular(8),  // bordi arrotondati
                      color: Colors.white, // colore sfondo (opzionale)
                    ),
                    child:
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Note Legali"),
                          IconButton(onPressed: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LegalNotesPage()),
                            );                            
                          }, icon: Icon(Icons.arrow_right,size: 35,))
                        ],
                      ),
                      ),
                  Container( 
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    margin: EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black), // colore del contorno
                      borderRadius: BorderRadius.circular(8),  // bordi arrotondati
                      color: Colors.white, // colore sfondo (opzionale)
                    ),
                    child:
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Privacy"),
                          IconButton(onPressed: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => InformazioniPage()),
                            );
                          }, icon: Icon(Icons.arrow_right,size: 35,))
                        ],
                      ),
                      ),
                ],
              ),
              SizedBox(
                width: 100,
                height: 50,
                child: ElevatedButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut().then((value) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  }).catchError((e) {
                    print(e);
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('Log out'),
              ),)
            ],
          ),
        ),
      bottomNavigationBar: CustomNavBar()
);
  }
}
