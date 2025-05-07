import '/ui/pages/widgets/custom_snackBar.dart';
import '/domain/models/event_model.dart';
import 'package:provider/provider.dart';
import '/ui/pages/viewmodel/events_view_model.dart';
import '/ui/pages/widgets/app_bar.dart';
import '/ui/pages/widgets/bottom_navbar.dart';
import '/ui/pages/widgets/custom_card_post.dart';
import 'package:flutter/material.dart';

class UserEventsPage extends StatefulWidget{
  const UserEventsPage({Key? key}) : super(key: key);

  @override
  State<UserEventsPage> createState() => _UserEventsPage();
}

class _UserEventsPage extends State<UserEventsPage> {
   
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
                  event: event,
                  onTap: (){
                    onTap(context, event, viewModel);
                  },
                  buttonColor: Colors.redAccent,
                  buttonText: "Elimina Evento",
                );
              }  else if (index == created.length + 1) {
                return _sectionHeader("Eventi a cui parteciperai");
              } else {
                final event = participates[index-created.length-2];
                return CustomCard(
                  event: event,
                  onTap: (){
                    onTap(context, event, viewModel);
                  },
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

  void onTap(BuildContext context, Event event, EventViewModel viewModel) async {
    final userId = viewModel.userId;
    if (!event.participantIds.contains(userId)) {
      CustomSnackBar.show(
        context,
        message: "Non stai partecipando all'evento!",
        backgroundColor: Colors.black,
        icon: Icons.check_circle,);
      return;
    }
    try {
      final success = await viewModel.removeParticipant(event, userId);
      setState(() {}); // 🔄 Forza il rebuild della UI
      if (success) {
        CustomSnackBar.show(
          context,
          message: "Iscrizione annullata con successo!",
          backgroundColor: Colors.green,
          icon: Icons.check_circle,);
        return;
      }
      else {
        CustomSnackBar.show(
          context,
          message: "Errore durante l'operazione",
          backgroundColor: Colors.red,
          icon: Icons.mood_bad_sharp,);
        return;
      }
    } catch (e) {
      CustomSnackBar.show(
          context,
          message: "Errore durante l'operazione",
          backgroundColor: Colors.red,
          icon: Icons.mood_bad_sharp,);
        return;
    }
  }

}