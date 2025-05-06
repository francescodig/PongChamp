import '/ui/pages/view/user_events_page.dart';
import '/domain/models/event_model.dart';
import '/ui/pages/view/create_event_page.dart';
import '/ui/pages/viewmodel/events_view_model.dart';
import 'package:provider/provider.dart';
import '/ui/pages/widgets/app_bar.dart';
import '/ui/pages/widgets/bottom_navbar.dart';
import '/ui/pages/widgets/custom_card_post.dart';
import 'package:flutter/material.dart';

class EventsPage extends StatelessWidget {
  
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

    String currentRoute = ModalRoute.of(context)?.settings.name ?? '';
    void navigateTo(Widget page, String routeName) {
      if (currentRoute != routeName) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => page,
            settings: RouteSettings(name: routeName),
          ),
          (route) => route.isFirst, ///Prende la route e ne conserva solo la prima, presumibilmente Home
        );
      }
    }

    return Scaffold(
      appBar: CustomAppBar(
      ),
      body: 
        Container(
        padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
        child: 
          Column(
            children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  style: ButtonStyle(
                    foregroundColor: WidgetStateProperty.all(Colors.black),
                    backgroundColor: WidgetStateProperty.all(Color.fromARGB(255, 245, 192, 41)),                    
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)
                      ),
                    ),
                  ),
                  onPressed: () {
                    navigateTo(UserEventsPage(), '/userEvents');;
                  },
                  child: Text("Miei Eventi")
                  ),
                TextButton(
                  style: ButtonStyle(
                    foregroundColor: WidgetStateProperty.all(Colors.black),
                    backgroundColor: WidgetStateProperty.all(Colors.red),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => CreateEventPage()),
                      );
                  },
                  child: Text("Organizza")
                  ),
              ],
            ),
            
            viewModel.isLoading ? Center(child: CircularProgressIndicator(color: Colors.black,))
            : viewModel.events.isEmpty ? Center(child: Text('Nessun evento disponibile'))
            : Expanded( //serve ad evitare problemi nello scroll della ListView
                child: 
                ListView.builder(
                  itemCount: viewModel.events.length,
                  itemBuilder: (context, index) {
                    final event = viewModel.events[index];
                    return CustomCard(
                      creatorNickname: event.creatorNickname,
                      creatorProfileImage: event.creatorProfileImage,
                      eventTitle: event.title,
                      location: event.location,
                      participants: event.participants,
                      maxParticipants: event.maxParticipants,
                      matchType: event.matchType,
                      orario: event.orario,
                      onTap: (){
                        onTapPartecipate(context,event,viewModel);
                        }
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
