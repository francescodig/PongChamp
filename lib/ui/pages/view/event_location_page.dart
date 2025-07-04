import '/domain/models/event_model.dart';
import '/ui/pages/viewmodel/events_view_model.dart';
import 'package:provider/provider.dart';
import '/ui/pages/widgets/app_bar.dart';
import '/ui/pages/widgets/bottom_navbar.dart';
import '/ui/pages/widgets/custom_card_post.dart';
import 'package:flutter/material.dart';

class EventLocationPage extends StatelessWidget {

  final String location;

  const EventLocationPage({required this.location});
  
  void onTapPartecipate(BuildContext context, Event event, EventViewModel viewModel) async {
    final userId = viewModel.userId;
    if (event.participantIds.contains(userId)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Row(
          children: [
          Icon(Icons.check_circle, color: Colors.white),
          SizedBox(width: 8),
          Text("Stai già partecipando all'evento!", style: TextStyle(color: Colors.white),),
          ],
        ),
        backgroundColor: Colors.black,
        duration: Duration(seconds: 1)),
      );
      return;
    }
    if (event.participantIds.length >= event.maxParticipants) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Row(
          children: [
          Icon(Icons.close_rounded, color: Colors.white),
          SizedBox(width: 8),
          Text("L'evento è al completo!", style: TextStyle(color: Colors.white),),
          ],
        ),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 1)),
      );
      return;
    }
    try {
      await viewModel.partecipateToEvent(event);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Row(
          children: [
          Icon(Icons.check_circle, color: Colors.white),
          SizedBox(width: 8),
          Text("Iscrizione completata con successo!", style: TextStyle(color: Colors.white),),
          ],
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 1)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Row(
          children: [
          Icon(Icons.mood_bad_sharp, color: Colors.white),
          SizedBox(width: 8),
          Text("Errore durante la partecipazione!", style: TextStyle(color: Colors.white),),
          ],
        ),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 1)),
      );
    }
  }


  @override
  Widget build(BuildContext context) { 
    final viewModel = context.watch<EventViewModel>();
    final events = viewModel.getEventsByLocation(location);



    return Scaffold(
      appBar: CustomAppBar(
      ),
      body: 
        Container(
        padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
        child: 
          Column(
            children: [
            viewModel.isLoading ? Center(child: CircularProgressIndicator(color: Colors.black,))
            : events.isEmpty ? Center(child: Text('Nessun evento disponibile'))
            : Expanded( 
                child: 
                ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return CustomCard(
                      event: event,
                      onTap: (){
                        onTapPartecipate(context,event,viewModel);
                        },
                      buttonColor: Colors.green,
                      buttonText: "Partecipa",
                    );
                  },
                ),
              ),
          ],),
      ),
      bottomNavigationBar: CustomNavBar(
      ),
    );
  }
}

