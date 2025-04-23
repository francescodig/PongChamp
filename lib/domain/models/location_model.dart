import 'package:cloud_firestore/cloud_firestore.dart';

class Location{
  final String id;
  String name;
  String nation;
  String region;
  String city;
  String address;
  double latitude;
  double longitude;

  Location({
    required this.id,
    required this.name,
    required this.address,
    required this.nation,
    required this.region,
    required this.city,
    required this.latitude,
    required this.longitude,
  });

  factory Location.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Location(
      id: doc.id,
      name: data['name'],
      address: data['address'],
      nation: data['nation'],
      region: data['region'],
      city: data['city'],
      latitude: data['latitude'],
      longitude: data['longitude'],
    );
  }

  /// Converte una mappa di Firestore in un oggetto Location
  factory Location.fromMap(Map<String, dynamic> map, String docId) {
    return Location(
      id: docId,
      name: map['name'],
      address: map['address'],
      nation: map['nation'],
      region: map['region'],
      city: map['city'],
      latitude: map['latitude'],
      longitude: map['longitude'],
    );
  }

  /// Converte un oggetto Location in una mappa per Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'nation': nation,
      'region': region,
      'city': city,
      'latitude': latitude,
      'longitude': longitude,
    };
  }



}