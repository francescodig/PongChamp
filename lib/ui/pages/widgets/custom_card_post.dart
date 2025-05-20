import '/domain/models/event_model.dart';
import '/domain/models/user_models.dart';
import '/ui/pages/viewmodel/post_view_model.dart';
import '/ui/pages/viewmodel/user_view_model.dart';
import 'package:flutter/material.dart';
import '/ui/pages/view/profile_page.dart';
import 'package:provider/provider.dart';
import '/ui/pages/view/participants_page.dart';

String formatDateTimeManually(DateTime dateTime) {
  String day = dateTime.day.toString().padLeft(2, '0');
  String month = dateTime.month.toString().padLeft(2, '0');
  String year = dateTime.year.toString();
  String hour = dateTime.hour.toString().padLeft(2, '0');
  String minute = dateTime.minute.toString().padLeft(2, '0');

  return '$day/$month/$year\n$hour:$minute';
}

class CustomCard extends StatelessWidget {
  final Event event;
  final VoidCallback onTap;
  final String buttonText;
  final Color? buttonColor;

  const CustomCard({
    Key? key,
    required this.event,
    required this.onTap,
    required this.buttonText,
    required this.buttonColor,
  }) : super(key: key);

@override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    final postViewModel = Provider.of<PostViewModel>(context, listen: false);

    final String eventTitle = event.title;
    final String location = event.locationId;
    final int participants = event.participants;
    final int maxParticipants = event.maxParticipants;
    final String matchType = event.eventType;
    final DateTime orario = event.dataEvento;

    final formattedTime = formatDateTimeManually(orario);

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Riga profilo + nickname
            Row(
              children: [
                FutureBuilder<String?>(
                    future: postViewModel.getCreatorProfileImageUrl(event.creatorId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircleAvatar(
                          radius: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        );
                      } else if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
                        return const CircleAvatar(
                          radius: 24,
                          child: Icon(Icons.person),
                        );
                      } else {
                        return CircleAvatar(
                          radius: 24,
                          backgroundImage: NetworkImage(snapshot.data!),
                        );
                      }
                    },
                  ),
                SizedBox(width: 12),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(userId: event.creatorId),
                      ),
                    );
                  },
                  child: FutureBuilder<AppUser?>(
                      future: userViewModel.getUserById(event.creatorId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator(); // o un placeholder
                        } else if (snapshot.hasError) {
                          return Text('Errore nel caricamento utente');
                        } else if (!snapshot.hasData || snapshot.data == null) {
                          return Text('Utente non trovato');
                        }
                        final user = snapshot.data!;
                        return Text(
                          user.nickname,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        );
                      },
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),

            /// Titolo evento
            Center(
              child: Text(
                eventTitle,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.red[700],
                ),
              ),
            ),
            SizedBox(height: 12),

            /// Info secondarie
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.location_on_outlined, size: 20),
                    SizedBox(width: 4),
                    Text('$location\n$formattedTime'),
                  ],
                ),
                Text(
                  matchType,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 8),

            /// Partecipanti e bottone
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.group),
                    SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ParticipantsPage(participants: event.participantIds),
                          ),
                        );
                      },
                      child:Text('$participants / $maxParticipants'),
                    ),
                  ],                
                ),
                ElevatedButton(
                  onPressed: onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: Text(buttonText),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
