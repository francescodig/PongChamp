import 'package:flutter/material.dart';
import 'package:PongChamp/ui/pages/view/organises_page.dart';
import 'package:PongChamp/ui/pages/view/profile_page.dart';
import 'package:PongChamp/ui/pages/view/map_page.dart';
import 'package:PongChamp/ui/pages/widgets/home_page.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
        title: Text("PongChamp", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.yellowAccent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        toolbarHeight: 100,
        centerTitle: true,
      ),
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
                          IconButton(onPressed: (){},
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
                          IconButton(onPressed: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ProfilePage()),
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
                          Text("Privacy"),
                          IconButton(onPressed: (){}, icon: Icon(Icons.arrow_right,size: 35,))
                        ],
                      ),
                      ),
                ],
              ),
              SizedBox(
                width: 100,
                height: 50,
                child: ElevatedButton(
                onPressed: () {},
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
      bottomNavigationBar: Container(
            color: Colors.yellow,
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
                      MaterialPageRoute(builder: (context) => OrganisesPage()),
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
                  color: Colors.grey[700],
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingsPage()),
                    );
                  },
                ),
              ],
            ),
      ),
    );
  }
}
