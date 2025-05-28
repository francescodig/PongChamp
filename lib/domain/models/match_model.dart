import 'package:cloud_firestore/cloud_firestore.dart';

class PongMatch {

  final String id;
  final String creatorId;
  int? score1;
  int? score2;
  DateTime date;
  String type;
  String idEvento;
  String matchTitle;
  List<String> matchPlayers;
  String winnerId;


  PongMatch({
    required this.id,
    required this.creatorId,
    required this.score1,
    required this.score2,
    required this.date,
    required this.type,
    required this.idEvento,
    required this.matchTitle,
    required this.matchPlayers,
    required this.winnerId,
  });

  factory PongMatch.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PongMatch(
      id: doc.id,
      creatorId: data["creatorId"],
      score1: data['score1'],
      score2: data['score2'],
      date: (data['date'] as Timestamp).toDate(),
      idEvento: data['idEvento'],
      matchTitle: data['matchTitle'],
      type: data['type'],
      matchPlayers: List<String>.from(data['matchPlayers'] ?? []),
      winnerId: data['winnerId'],
    );
  }

  /// Converte una mappa di Firestore in un oggetto Match
  factory PongMatch.fromMap(Map<String, dynamic> map, String docId) {
    return PongMatch(
      id: map['id'] ?? docId,
      creatorId: map["creatorId"],
      score1: map['score1'],
      score2: map['score2'],
      date: (map['date'] as Timestamp).toDate(),
      idEvento: map['idEvento'],
      matchTitle: map['matchTitle'],
      type: map['type'],
      matchPlayers: List<String>.from(map['matchPlayers'] ?? []),
      winnerId: map['winnerId']
    );
  }

  /// Converte un oggetto Match in una mappa per Firestore
  Map<String, dynamic> toMap() {
    return {
      'creatorId': creatorId,
      'score1': score1,
      'score2': score2,
      'date': date,
      'idEvento': idEvento,
      'type': type,
      'matchTitle': matchTitle,
      'matchPlayers': matchPlayers,
      'winnerId': winnerId,
    };  
  }

  PongMatch copyWith ({
    String? id,
    String? creatorId,
    int? score1,
    int? score2,
    DateTime? date,
    List<String>? matchPlayers,
    String? type,
    String? idEvento,
    String? matchTitle,
    String? winnerId,
  }) {
    return PongMatch( 
      id: id ?? this.id,
      creatorId: creatorId ?? this.creatorId,
      score1: score1 ?? this.score1,
      score2: score2 ?? this.score2,
      date: date ?? this.date,
      idEvento: idEvento ?? this.idEvento,
      type: type ?? this.type,
      matchTitle: matchTitle ?? this.matchTitle,
      matchPlayers: matchPlayers ?? this.matchPlayers,
      winnerId: winnerId ?? this.winnerId,
    );
  }
  




}