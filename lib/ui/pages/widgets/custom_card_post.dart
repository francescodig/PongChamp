import '/domain/models/event_model.dart';
import 'package:flutter/material.dart';

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
    final String creatorNickname = event.creatorNickname;
    final String creatorProfileImage = event.creatorProfileImage;
    final String eventTitle = event.title;
    final String location = event.locationName;
    final int participants = event.participants;
    final int maxParticipants = event.maxParticipants;
    final String matchType = event.matchType;
    final DateTime orario = event.orario;

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
                CircleAvatar(
                  backgroundImage: NetworkImage(creatorProfileImage),
                  radius: 24,
                ),
                SizedBox(width: 12),
                Text(
                  creatorNickname,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
                    Text('$participants / $maxParticipants'),
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