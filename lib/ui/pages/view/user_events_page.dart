import 'package:provider/provider.dart';
import '/ui/pages/viewmodel/events_view_model.dart';
import '/ui/pages/widgets/app_bar.dart';
import '/ui/pages/widgets/bottom_navbar.dart';
import '/ui/pages/widgets/custom_card_post.dart';
import 'package:flutter/material.dart';

class UserEventsPage extends StatelessWidget{  
  
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<EventViewModel>(context, listen: false);    
    return Scaffold(
      appBar: CustomAppBar(
      ),
      body: FutureBuilder(
        future: viewModel.fetchUserEvents(), 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          final userEvents = viewModel.userEvents;
          if (userEvents.isEmpty){
            return Center(child: Text('Nessun evento creato'));
          }
          return ListView.builder(
            itemCount: userEvents.length,
            itemBuilder: (context, index) {
              final event = userEvents[index];
              return CustomCard(
                creatorNickname: event.creatorNickname,
                creatorProfileImage: event.creatorProfileImage,
                eventTitle: event.title,
                location: event.location,
                participants: event.participants,
                maxParticipants: event.maxParticipants,
                matchType: event.matchType,
                orario: event.orario,
                onTapPartecipate: (){}
              );
            },);
        }
      ),
      bottomNavigationBar: CustomNavBar(
      ),
    );
  }
}