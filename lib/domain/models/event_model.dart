class Event {
  final String id;
  final String title;
  final String location;
  final String username;
  final int participants;
  final int maxParticipants;
  final String matchType;

  Event({
    required this.id,
    required this.title,
    required this.location,
    required this.username,
    required this.participants,
    required this.maxParticipants,
    required this.matchType,
  });

  /// Factory per costruire un Event da JSON (es. da un'API)
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] as String,
      username: json['username'] as String,
      title: json['title'] as String,
      location: json['location'] as String,
      participants: json['participants'] as int,
      maxParticipants: json['maxParticipants'] as int,
      matchType: json['matchType'] as String,
    );
  }

  /// Metodo per convertire un Event in JSON (es. per salvarlo nel DB)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'title': title,
      'location': location,
      'participants': participants,
      'maxParticipants': maxParticipants,
      'matchType': matchType,
    };
  }

}