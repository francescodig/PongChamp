import '/domain/models/event_model.dart';
import 'package:provider/provider.dart';
import '/ui/pages/viewmodel/events_view_model.dart';
import '/ui/pages/widgets/app_bar.dart';
import '/ui/pages/widgets/bottom_navbar.dart';
import '/ui/pages/widgets/custom_card_post.dart';
import 'package:flutter/material.dart';

class UserEventsPage extends StatelessWidget{  

   void onTap(BuildContext context, Event event, EventViewModel viewModel) async {
    final userId = viewModel.userId;
    if (!event.participantIds.contains(userId)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Row(
          children: [
          Icon(Icons.check_circle, color: Colors.white),
          SizedBox(width: 8),
          Text("Non stai partecipando all'evento!", style: TextStyle(color: Colors.white),),
          ],
        ),
        backgroundColor: Colors.black,
        duration: Duration(seconds: 1)),
      );
      return;
    }
    try {
      final success = await viewModel.removeParticipant(event, userId);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Row(
            children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text("Iscrizione annullata con successo!", style: TextStyle(color: Colors.white),),
            ],
          ),
          backgroundColor: Colors.black,
          duration: Duration(seconds: 1)),
        );
      }
      else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Row(
            children: [
            Icon(Icons.mood_bad, color: Colors.white),
            SizedBox(width: 8),
            Text("Errore durante l'operazione", style: TextStyle(color: Colors.white),),
            ],
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 1)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Row(
          children: [
          Icon(Icons.mood_bad_sharp, color: Colors.white),
          SizedBox(width: 8),
          Text("Errore durante l'operazione!", style: TextStyle(color: Colors.white),),
          ],
        ),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 1)),
      );
    }
  }

  
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<EventViewModel>(context, listen: false);    
    return Scaffold(
      appBar: CustomAppBar(
      ),
      body: FutureBuilder(
        future: Future.wait([
          viewModel.fetchUserEvents(),
          viewModel.fetchPartecipateEvents()
        ]), 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          final created = viewModel.userEvents;
          final participates = viewModel.userOnlyParticipatedEvents;
          if (created.isEmpty && participates.isEmpty){
            return Center(child: Text('Nessun evento'));
          }
          final count = created.length+participates.length+2 /*le due intestazioni*/;
          return ListView.builder(
            itemCount: count,
            itemBuilder: (context, index) {
              if (index==0){
                return _sectionHeader("Eventi creati");
              } else if (index > 0 && index <= created.length) {
                final event = created[index -1];
                return CustomCard(
                  creatorNickname: event.creatorNickname,
                  creatorProfileImage: event.creatorProfileImage,
                  eventTitle: event.title,
                  location: event.locationName,
                  participants: event.participants,
                  maxParticipants: event.maxParticipants,
                  matchType: event.matchType,
                  orario: event.orario,
                  onTap: (){onTap(context, event, viewModel);
                    viewModel.fetchEvents();
                    viewModel.fetchUserEvents();},
                  buttonColor: Colors.redAccent,
                  buttonText: "Annulla Partecipazione",
                );
              }  else if (index == created.length + 1) {
                return _sectionHeader("Eventi a cui parteciperai");
              } else {
                final event = participates[index-created.length-2];
                return CustomCard(
                  creatorNickname: event.creatorNickname,
                  creatorProfileImage: event.creatorProfileImage,
                  eventTitle: event.title,
                  location: event.locationName,
                  participants: event.participants,
                  maxParticipants: event.maxParticipants,
                  matchType: event.matchType,
                  orario: event.orario,
                  onTap: (){onTap(context, event, viewModel);},
                  buttonColor: Colors.redAccent,
                  buttonText: "Annulla Partecipazione",
                );
              }
            },);
        }
      ),
      bottomNavigationBar: CustomNavBar(
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const Divider(thickness: 1.2, color: Colors.grey),
        ],
      ),
    );
  }
}