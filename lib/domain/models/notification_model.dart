import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  
  final String idNotifica;
  final String title;
  final String message;
  final String userId;
  final String eventId;
  final DateTime? timestamp;
  bool read;

  NotificationModel({
    required this.idNotifica,
    required this.title,
    required this.message,
    required this.userId,
    required this.eventId,
    required this.timestamp,
    required this.read,
  });

  //Costruttore da Firestore
  factory NotificationModel.fromFirestore(DocumentSnapshot doc){
    final data = doc.data() as Map<String, dynamic>;
    return NotificationModel(
      idNotifica: data['idNotifica'] ?? doc.id,
      userId: data['userId'],
      eventId: data['eventId'],
      title: data['title'],
      message: data['message'],
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      read: data['read'] ?? false,
    );
  }

  //Scrittura su Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'idNotifica': idNotifica,
      'userId': userId,
      'eventId': eventId,
      'title': title,
      'message': message,
      'timestamp': timestamp,
      'read': read,
    };
  }

  //Metodo per copiare una notifica cambiando certi attributi
  NotificationModel copyWith({
    String? idNotifica,
    String? userId,
    String? eventId,
    String? title,
    String? message,
    DateTime? timestamp,
    bool? read,
  }) {
    return NotificationModel(
      idNotifica: idNotifica ?? this.idNotifica,
      userId: userId ?? this.userId,
      eventId: eventId ?? this.eventId,
      title: title ?? this.title,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      read: read ?? this.read,
    );
  }  
}