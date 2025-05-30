import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String id;
  String title;
  String locationId;
  final String creatorId;
  int participants;
  int maxParticipants;
  List<String> participantIds;
  String eventType;
  final DateTime createdAt;
  DateTime dataEvento; 
  bool hasMatch;

  Event({
    required this.id,
    required this.title,
    required this.locationId,
    required this.creatorId,
    required this.participants,
    required this.maxParticipants,
    required this.participantIds,
    required this.eventType,
    required this.createdAt,
    required this.dataEvento,
    required this.hasMatch,
  });

  /// Converte una mappa di Firestore in un oggetto Event
  factory Event.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Event(
      id: data['id'] ?? doc.id,
      creatorId: data['creatorId'],
      title: data['title'] ?? '',
      locationId: data['locationId'] ?? '',
      participants: data['participants'] ?? 0,
      maxParticipants: data['maxParticipants'],
      participantIds: List<String>.from(data['participantIds'] ?? []),
      eventType: data['eventType'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      dataEvento: (data['dataEvento'] as Timestamp).toDate(),
      hasMatch: (data['hasMatch']) ?? false,
    );
  }

  /// Converte un oggetto Event in una mappa per Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'creatorId': creatorId,
      'title': title,
      'locationId': locationId,
      'participants': participants,
      'maxParticipants': maxParticipants,
      'participantIds': participantIds,
      'eventType': eventType,
      'createdAt': Timestamp.fromDate(createdAt),
      'dataEvento': Timestamp.fromDate(dataEvento),
      'hasMatch': hasMatch,
    };
  }

  ///Crea una copia modificabile
  Event copyWith({
    String? id,
    String? title,
    String? locationId,
    String? locationName,
    String? creatorId,
    String? creatorNickname,
    String? creatorProfileImage,
    int? participants,
    int? maxParticipants,
    List<String>? participantIds,
    String? eventType,
    DateTime? createdAt,
    bool? hasMatch,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      locationId: locationId ?? this.locationId,
      creatorId: creatorId ?? this.creatorId,
      participants: participants ?? this.participants,
      maxParticipants: maxParticipants ?? this.maxParticipants,
      participantIds: participantIds ?? this.participantIds,
      eventType: eventType ?? this.eventType,
      createdAt: createdAt ?? this.createdAt,
      dataEvento : dataEvento,
      hasMatch: hasMatch ?? this.hasMatch,
    );
  }
}