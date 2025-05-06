import 'package:cloud_firestore/cloud_firestore.dart';


//**DA RIVEDERE**
// Gli attributi username, parzialmente risolto con creatorId, e location dovrebbero prendere oggetti particolari e non stringhe 

class Event {
  final String id;
  final String title;
  final String locationId;
  final String locationName;
  final String creatorId;
  final String creatorNickname;
  final String creatorProfileImage;
  int participants;
  final int maxParticipants;
  final List<String> participantIds;
  final String matchType;
  final DateTime? createdAt;
  final DateTime orario; 

  Event({
    required this.id,
    required this.title,
    required this.locationId,
    required this.locationName,
    required this.creatorId,
    required this.creatorNickname,
    required this.creatorProfileImage,    
    required this.participants,
    required this.maxParticipants,
    required this.participantIds,
    required this.matchType,
    required this.createdAt,
    required this.orario,
  });

  /// Converte una mappa di Firestore in un oggetto Event
  factory Event.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Event(
      id: doc.id,
      creatorId: data['creatorId'] ?? "",
      creatorNickname: data['creatorNickname'] ?? "",
      creatorProfileImage: data['creatorProfileImage'] ?? "",
      title: data['title'] ?? '',
      locationId: data['locationId'] ?? '',
      locationName: data['locationName'] ?? '',
      participants: data['participants'] ?? 0,
      maxParticipants: data['maxParticipants'] ?? 0,
      participantIds: List<String>.from(data['participantIds'] ?? []),
      matchType: data['matchType'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      orario: (data['orario'] as Timestamp).toDate(),
    );
  }

  /// Converte un oggetto Event in una mappa per Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'creatorId': creatorId,
      'creatorNickname': creatorNickname,
      'creatorProfileImage': creatorProfileImage,
      'title': title,
      'locationId': locationId,
      'locationName': locationName,
      'participants': participants,
      'maxParticipants': maxParticipants,
      'participantIds': participantIds,
      'matchType': matchType,
      'createdAt': Timestamp.fromDate(createdAt ?? DateTime.now()),
      'orario': Timestamp.fromDate(orario),
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
    String? matchType,
    DateTime? createdAt,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      locationId: locationId ?? this.locationId,
      locationName: locationName ?? this.locationName,
      creatorId: creatorId ?? this.creatorId,
      creatorNickname: creatorNickname ?? this.creatorNickname,
      creatorProfileImage: creatorProfileImage ?? this.creatorProfileImage,
      participants: participants ?? this.participants,
      maxParticipants: maxParticipants ?? this.maxParticipants,
      participantIds: participantIds ?? this.participantIds,
      matchType: matchType ?? this.matchType,
      createdAt: createdAt ?? this.createdAt,
      orario : orario /*?? this.orario*/,
    );
  }
}