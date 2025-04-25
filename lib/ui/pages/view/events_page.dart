import '/ui/pages/view/create_event_page.dart';
import '/ui/pages/viewmodel/events_view_model.dart';
import 'package:provider/provider.dart';
import '/ui/pages/widgets/app_bar.dart';
import '/ui/pages/widgets/bottom_navbar.dart';
import '/ui/pages/widgets/custom_card_post.dart';
import 'package:flutter/material.dart';

class EventsPage extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) { 
    final viewModel = context.watch<EventViewModel>();

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
                TextButton.icon(
                  style: ButtonStyle(
                    foregroundColor: WidgetStateProperty.all(Colors.black),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)
                      ),
                    ),
                  ),
                  onPressed: () {},
                  icon: Icon(Icons.filter_list,color: Colors.black,),
                  label: Text("Filtri"),
                  ),
                TextButton(
                  style: ButtonStyle(
                    foregroundColor: WidgetStateProperty.all(Colors.white),
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
            
            viewModel.isLoading ? Center(child: CircularProgressIndicator())
            : viewModel.events.isEmpty ? Center(child: Text('Nessun evento disponibile'))
            : ListView.builder(
                shrinkWrap: true,
                itemCount: viewModel.events.length,
                itemBuilder: (context, index) {
                  final event = viewModel.events[index];
                  return CustomCard(
                    username: event.username,
                    eventTitle: event.title,
                    location: event.location,
                    participants: event.participants,
                    maxParticipants: event.maxParticipants,
                    matchType: event.matchType,
                    onTapPartecipate: () {
                        // Per ora lasciamo il pulsante come non operativo
                    },
                  );
                },
              ),

          ],),
      ),
      bottomNavigationBar: CustomNavBar(
      ),
    );
  }
}
