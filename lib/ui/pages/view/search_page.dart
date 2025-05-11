import 'package:PongChamp/domain/models/user_models.dart';
import 'package:PongChamp/ui/pages/view/profile_page.dart';
import 'package:PongChamp/ui/pages/viewmodel/search_view_model.dart';
import 'package:PongChamp/ui/pages/widgets/app_bar.dart';
import 'package:PongChamp/ui/pages/widgets/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage  extends StatefulWidget{

  



  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {


  @override
  @override
Widget build(BuildContext context) {
  final searchViewModel = Provider.of<SearchViewModel>(context);

  return Scaffold(
    appBar: CustomAppBar(),
    body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            onChanged: searchViewModel.search,
            decoration: const InputDecoration(
              hintText: 'Cerca utenti...',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Builder(
            builder: (_) {
              if (searchViewModel.isLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (searchViewModel.results.isEmpty) {
                return Center(child: Text('Nessun utente trovato.'));
              } else {
                return ListView.builder(
                  itemCount: searchViewModel.results.length,
                  itemBuilder: (context, index) {
                    AppUser user = searchViewModel.results[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfilePage(userId: user.id),
                          ),
                        );
                      }, // Naviga alla pagina del profilo dell'utente
                      child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(user.profileImage),
                      ),
                      title: Text(user.nickname),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ],
    ),
    bottomNavigationBar: CustomNavBar(),
  );
}
}