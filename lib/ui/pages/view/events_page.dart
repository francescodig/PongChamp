import '../widgets/custom_section_header.dart';
import '/ui/pages/widgets/custom_snackBar.dart';
import '/ui/pages/view/user_events_page.dart';
import '/domain/models/event_model.dart';
import '/ui/pages/view/create_event_page.dart';
import '/ui/pages/viewmodel/events_view_model.dart';
import 'package:provider/provider.dart';
import '/ui/pages/widgets/app_bar.dart';
import '/ui/pages/widgets/bottom_navbar.dart';
import '/ui/pages/widgets/custom_card_post.dart';
import 'package:flutter/material.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({Key? key}) : super(key: key);

  @override
  State<EventsPage> createState() => _EventsPageState();

}

class _EventsPageState extends State<EventsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<EventViewModel>().fetchEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<EventViewModel>();
    final eventsLength = viewModel.events.length;
    return Scaffold(
      appBar: CustomAppBar(),
      body: 
        Container(
          padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
          child: Column(
            spacing: 5,
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
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (_) => UserEventsPage()));
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
                      context.read<EventViewModel>().fetchMarkers();
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => CreateEventPage()),
                        );
                    },
                    child: Text("Organizza")
                    ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                CustomSectionheader(title: "Eventi in programma: $eventsLength"
                ),
              ]),
              
              viewModel.isLoading ? Center(child: CircularProgressIndicator(color: Colors.black,))
              : viewModel.events.isEmpty ? Center(child: Text('Nessun evento disponibile'))
              : Expanded( //serve ad evitare problemi nello scroll della ListView
                  child: 
                  ListView.builder(
                    itemCount: viewModel.events.length,
                    itemBuilder: (context, index) {
                      final event = viewModel.events[index];
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
      bottomNavigationBar: CustomNavBar(),
    );
  }

  void onTapPartecipate(BuildContext context, Event event, EventViewModel viewModel) async {
    final userId = viewModel.userId;
    if (event.participantIds.contains(userId)) {
      CustomSnackBar.show(
        context, 
        message: "Stai già partecipando all'evento!",
        backgroundColor:  Colors.black, 
        icon: Icons.check_circle);
      return; 
    }
    if (event.participantIds.length >= event.maxParticipants) {
      CustomSnackBar.show(
        context,
        message: "L'evento è al completo!", 
        backgroundColor: Colors.red,
        icon: Icons.close_rounded);
      return;
    }
    try {
      await viewModel.partecipateToEvent(event);
      setState(() {}); // 🔄 Forza il rebuild della UI
      CustomSnackBar.show(
        context,
        message: "Iscrizione completata con successo!",
        backgroundColor: Colors.green,
        icon: Icons.check_circle);
    } catch (e) {
      CustomSnackBar.show(
        context,
        message: "Errore durante la partecipazione!",
        backgroundColor: Colors.red,
        icon: Icons.mood_bad_sharp);
    }
  }
}