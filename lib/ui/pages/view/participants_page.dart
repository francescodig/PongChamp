import 'package:PongChamp/domain/models/user_models.dart';
import 'package:PongChamp/ui/pages/view/profile_page.dart';
import 'package:PongChamp/ui/pages/viewmodel/participants_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ParticipantsPage extends StatelessWidget {
  final List<String> participants;

  const ParticipantsPage({super.key, required this.participants});

  @override
  Widget build(BuildContext context) {
    final participantsViewModel = Provider.of<ParticipantsViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("Partecipanti"),
        backgroundColor: Color.fromARGB(255, 245, 192, 41),
        toolbarHeight: 120
      ),
      body: FutureBuilder<List<AppUser>>(
        future: participantsViewModel.loadParticipants(participants),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Errore nel caricamento. ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nessun partecipante per questo evento.'));
          }

          final users = snapshot.data!;
          return ListView.builder(
            padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: user.proPic,
                ),
                title: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(userId: user.id),
                      ),
                    );
                  },
                  child: Text(user.nickname),
                ),
              );
            },
          );
        },
      ),
    );
  }
}