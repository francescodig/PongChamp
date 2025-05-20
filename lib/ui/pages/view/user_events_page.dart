import '/ui/pages/view/create_post_page.dart';
import '../widgets/custom_section_header.dart';
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
          final created = viewModel.userFutureEvents;
          final participates = viewModel.onlyParticipatedFutureEvents;
          final expired = viewModel.userExpiredEvents;
          if (created.isEmpty && participates.isEmpty && expired.isEmpty){
            return Center(child: Text('Nessun evento'));
          }
          final createdHeaderIndex = 0;
          final participatesHeaderIndex = created.length + 1;
          final expiredHeaderIndex = participatesHeaderIndex + participates.length + 1;
          final totalCount = created.length + participates.length + expired.length + 3;
          return ListView.builder(
            itemCount: totalCount,
            itemBuilder: (context, index) {
              if (index==createdHeaderIndex){
                final createdLength = created.length;
                return CustomSectionheader(title: "Eventi creati: $createdLength");
              } else if (index > createdHeaderIndex && index <= created.length) {
                final event = created[index -1];
                return CustomCard(
                  event: event,
                  onTap: (){
                    onTapDelete(context, event, viewModel);
                  },
                  buttonColor: Colors.redAccent,
                  buttonText: "Elimina Evento",
                );
              }  else if (index == participatesHeaderIndex) {
                final participatesLength = participates.length;
                return CustomSectionheader(title: "Eventi a cui parteciperai: $participatesLength");
              } else if (index > participatesHeaderIndex && index <= participatesHeaderIndex + participates.length){
                final event = participates[index-participatesHeaderIndex-1];
                return CustomCard(
                  event: event,
                  onTap: (){
                    onTapParticipate(context, event, viewModel);
                  },
                  buttonColor: Colors.redAccent,
                  buttonText: "Annulla Partecipazione",
                );
              } else if (index == expiredHeaderIndex){
                final expiredLength = expired.length;
                return CustomSectionheader(title: "Eventi scaduti: $expiredLength");
              } else {
                final event = expired[index - expiredHeaderIndex - 1];
                return CustomCard(
                  event: event,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => CreatePostPage(event: event)),
                    );
                  },
                  buttonText: "Crea Post", 
                  buttonColor: Color.fromARGB(255, 245, 192, 41),);
              }
            },);
        }
      ),
      bottomNavigationBar: CustomNavBar(
      ),
    );
  }

  void onTapParticipate(BuildContext context, Event event, EventViewModel viewModel) async {
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

  void onTapDelete(BuildContext context, Event event, EventViewModel viewModel) async {
    final userId = viewModel.userId!;
    if(event.creatorId != userId){
      return;
    }
    try{
      final success = await viewModel.deleteEvent(event,userId);
      setState(() {});
      if (success) {
        CustomSnackBar.show(
          context,
          message: "Evento eliminato con successo!",
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
    } catch (e){
      CustomSnackBar.show(
        context,
        message: "Errore durante l'operazione",
        backgroundColor: Colors.red,
        icon: Icons.mood_bad_sharp,);
      return;
    }
  }


}