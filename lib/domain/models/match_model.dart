import '/domain/models/location_model.dart';
import '/domain/models/user_models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PongMatch {

  final String id;
  AppUser user1;
  AppUser user2;
  int score1;
  int score2;
  DateTime date;
  Location location;
  String type;


  PongMatch({
    required this.id,
    required this.user1,
    required this.user2,
    required this.score1,
    required this.score2,
    required this.date,
    required this.location,
    required this.type,
  });

  factory PongMatch.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PongMatch(
      id: doc.id,
      user1: AppUser.fromMap(data['user1'], data['user1']['id']),
      user2: AppUser.fromMap(data['user2'], data['user2']['id']),
      score1: data['score1'],
      score2: data['score2'],
      date: (data['date'] as Timestamp).toDate(),
      location: Location.fromMap(data['location'], doc.id),
      type: data['type'],
    );
  }

  /// Converte una mappa di Firestore in un oggetto Match
  factory PongMatch.fromMap(Map<String, dynamic> map, String docId) {
    return PongMatch(
      id: docId,
      user1: AppUser.fromMap(map['user1'], map['user1']['id']),
      user2: AppUser.fromMap(map['user2'], map['user2']['id']),
      score1: map['score1'],
      score2: map['score2'],
      date: (map['date'] as Timestamp).toDate(),
      location: Location.fromMap(map['location'], docId),
      type: map['type'],
    );
  }

  /// Converte un oggetto Match in una mappa per Firestore
  Map<String, dynamic> toMap() {
    return {
      'user1': user1.toMap(),
      'user2': user2.toMap(),
      'score1': score1,
      'score2': score2,
      'date': date,
      'location': location.toMap(),
      'type': type,
    };
  }
  




}