import 'package:cloud_firestore/cloud_firestore.dart';


//**DA RIVEDERE**
// Gli attributi username, parzialmente risolto con creatorId, e location dovrebbero prendere oggetti particolari e non stringhe 

class Event {
  final String id;
  final String title;
  final String location;
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
    required this.location,
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

  /// Factory per costruire un Event da JSON, es. da un'API
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] as String,
      creatorId: json['creatorId'] as String,
      creatorNickname: json['creatorNickname'] as String,
      creatorProfileImage: json['creatorProfileImage'] as String,
      title: json['title'] as String,
      location: json['location'] as String,
      participants: json['participants'] as int,
      maxParticipants: json['maxParticipants'] as int,
      participantIds: json['participantIds'] as List<String>,
      matchType: json['matchType'] as String,
      createdAt: json['createdAt'] as DateTime,
      orario : json['orario'] as DateTime,
    );
  }

  /// Metodo per convertire un Event in JSON, es. per salvarlo nel DB
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'creatorId': creatorId,
      'creatorNickname': creatorNickname,
      'creatorProfileImage': creatorProfileImage,
      'title': title,
      'location': location,
      'participants': participants,
      'maxParticipants': maxParticipants,
      'participantIds': participantIds,
      'matchType': matchType,
      'orario' : orario,
    };
  }

  /// Converte una mappa di Firestore in un oggetto Event
  factory Event.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Event(
      id: doc.id,
      creatorId: data['creatorId'] ?? "",
      creatorNickname: data['creatorNickname'] ?? "",
      creatorProfileImage: data['creatorProfileImage'] ?? "",
      title: data['title'] ?? '',
      location: data['location'] ?? '',
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
      'location': location,
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
    String? location,
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
      location: location ?? this.location,
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