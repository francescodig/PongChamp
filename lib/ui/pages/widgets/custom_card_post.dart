import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String creatorNickname;
  final String creatorProfileImage;
  final String eventTitle;
  final String location;
  final int participants;
  final int maxParticipants;
  final String matchType;
  final VoidCallback onTapPartecipate;

  const CustomCard({
    Key? key,
    required this.creatorNickname,
    required this.creatorProfileImage,
    required this.eventTitle,
    required this.location,
    required this.participants,
    required this.maxParticipants,
    required this.matchType,
    required this.onTapPartecipate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// RIGA 1: Avatar + nome + titolo + partecipanti
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  CircleAvatar(foregroundImage: NetworkImage(creatorProfileImage),
                    radius: 20,
                    child: Icon(Icons.person),
                  ),
                  Text(creatorNickname, style: TextStyle(fontSize: 14)),
                ],
              ),
              Text(
                eventTitle,
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Column(
                children: [
                  Icon(Icons.group),
                  Text('$participants/$maxParticipants'),
                ],
              ),
            ],
          ),

          /// RIGA 2: posizione + bottone + tipo match
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                onPressed: (){},
                label: Text(
                  location,
                  style: TextStyle(
                    color: Colors.black
                  ),
                ),
                icon: Icon(Icons.location_on_outlined,color: Colors.black,),
              ),
              ElevatedButton(
                onPressed: onTapPartecipate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('Partecipa'),
              ),
              Text(matchType, style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}
