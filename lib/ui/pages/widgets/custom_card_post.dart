import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:PongChamp/ui/pages/view/profile_page.dart';
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
  final String eventId;
  final VoidCallback onTap;
  final String buttonText;
  final Color? buttonColor;

  const CustomCard({
    Key? key,
    required this.eventId,
    required this.onTap,
    required this.buttonText,
    required this.buttonColor,
  }) : super(key: key);

  Future<DocumentSnapshot> fetchEvent() async {
    return await FirebaseFirestore.instance.collection('Event').doc(eventId).get();
  }

  Future<DocumentSnapshot> fetchUser(String userId) async {
    return await FirebaseFirestore.instance.collection('User').doc(userId).get();
  }

  Future<DocumentSnapshot> fetchLocation(String locationId) async {
    return await FirebaseFirestore.instance.collection('Location').doc(locationId).get();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: fetchEvent(),
      builder: (context, eventSnapshot) {
        if (eventSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!eventSnapshot.hasData || !eventSnapshot.data!.exists) {
          return const Center(child: Text('Evento non trovato'));
        }

        final eventData = eventSnapshot.data!.data()! as Map<String, dynamic>;

        final String creatorId = eventData['creatorId'];
        final String title = eventData['title'] ?? '';
        final int maxParticipants = eventData['maxParticipants'] ?? 0;
        final List<dynamic> participantIds = eventData['participantIds'] ?? [];
        final int participants = participantIds.length;
        final String eventType = eventData['eventType'] ?? '';
        final Timestamp dataEventoTimestamp = eventData['dataEvento'] as Timestamp;
        final DateTime dataEvento = dataEventoTimestamp.toDate();
        final String locationId = eventData['locationId'] ?? '';

        final formattedTime = formatDateTimeManually(dataEvento);

        return FutureBuilder<DocumentSnapshot>(
          future: fetchUser(creatorId),
          builder: (context, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
              return const Center(child: Text('Creatore non trovato'));
            }
            final userData = userSnapshot.data!.data()! as Map<String, dynamic>;

            final String creatorNickname = userData['nickname'] ?? 'Anonimo';
            final String creatorProfileImage = userData['proPic'] ?? '';

            return FutureBuilder<DocumentSnapshot>(
              future: fetchLocation(locationId),
              builder: (context, locationSnapshot) {
                if (locationSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                String locationName = 'Nessuna location';
                if (locationSnapshot.hasData && locationSnapshot.data!.exists) {
                  final locData = locationSnapshot.data!.data()! as Map<String, dynamic>;
                  locationName = locData['name'] ?? locationName;
                }

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Riga profilo + nickname
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: creatorProfileImage.isNotEmpty
                                  ? NetworkImage(creatorProfileImage)
                                  : const AssetImage('assets/images/default_avatar.png') as ImageProvider,
                              radius: 24,
                            ),
                            const SizedBox(width: 12),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProfilePage(userId: creatorId),
                                  ),
                                );
                              },
                              child: Text(
                                creatorNickname,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Titolo evento
                        Center(
                          child: Text(
                            title,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.red[700],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Info secondarie
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.location_on_outlined, size: 20),
                                const SizedBox(width: 4),
                                Text('$locationName\n$formattedTime'),
                              ],
                            ),
                            Text(
                              eventType,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Partecipanti e bottone
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.group),
                                const SizedBox(width: 4),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ParticipantsPage(participants: participantIds.cast<String>()),
                                      ),
                                    );
                                  },
                                  child: Text('$participants / $maxParticipants'),
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
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              ),
                              child: Text(buttonText),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
