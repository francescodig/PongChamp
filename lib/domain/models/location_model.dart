import 'package:cloud_firestore/cloud_firestore.dart';

class Location{
  final String id;
  String name;

  Location({
    required this.id,
    required this.name,
  });

  factory Location.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Location(
      id: doc.id,
      name: data['name'],
    );
  }

  /// Converte una mappa di Firestore in un oggetto Location
  factory Location.fromMap(Map<String, dynamic> map, String docId) {
    return Location(
      id: map['locationId'],
      name: map['locationName'],
    );
  }

  /// Converte un oggetto Location in una mappa per Firestore
  Map<String, dynamic> toMap() {
    return {
      'locationName': name,
      'locationId': id,
    };
  }



}