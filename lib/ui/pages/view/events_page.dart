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

    if (viewModel.isLoading){
      return Center(child: CircularProgressIndicator());
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
                  onPressed: () {},
                  child: Text("Organizza")
                  ),
              ],
            ),
            Column(
              children: [
                CustomCard(
                  username: 'lavan_dino60',
                  eventTitle: 'More Tacci',
                  location: 'Pin Palace',
                  participants: 1,
                  maxParticipants: 2,
                  matchType: '1 VS 1',
                  onTapPartecipate: () {
                    print('Partecipazione inviata!');
                  },
                ),
                CustomCard(
                  username: 'lavan_dino60',
                  eventTitle: 'TORNEONE',
                  location: 'Pin Palace',
                  participants: 1,
                  maxParticipants: 4,
                  matchType: 'Torneo',
                  onTapPartecipate: () {
                    print('Partecipazione inviata!');
                  },
                ),
              ],
            ),
          ],),
      ),
      bottomNavigationBar: CustomNavBar(
      ),
    );
  }
}
