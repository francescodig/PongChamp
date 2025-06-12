import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  
  final String idNotifica;
  final String title;
  final String message;
  final String userId;
  final String idEvento;
  final Timestamp timestamp;
  bool read;

  NotificationModel({
    required this.idNotifica,
    required this.title,
    required this.message,
    required this.userId,
    required this.idEvento,
    required this.timestamp,
    required this.read,
  });

  //Costruttore da Firestore
  factory NotificationModel.fromFirestore(DocumentSnapshot doc){
    final data = doc.data() as Map<String, dynamic>;
    return NotificationModel(
      idNotifica: doc.id,
      userId: data['userId'],
      idEvento: data['idEvento'],
      title: data['title'] ?? 'No Title',
      message: data['message'] ?? 'No Message',
      timestamp: (data['timestamp'] as Timestamp?) ?? Timestamp.now(),
      read: data['read'] ?? false,
    );
  }

  //Scrittura su Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'idNotifica': idNotifica,
      'userId': userId,
      'idEvento': idEvento,
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
    String? idEvento,
    String? title,
    String? message,
    Timestamp? timestamp,
    bool? read,
  }) {
    return NotificationModel(
      idNotifica: idNotifica ?? this.idNotifica,
      userId: userId ?? this.userId,
      idEvento: idEvento ?? this.idEvento,
      title: title ?? this.title,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      read: read ?? this.read,
    );
  }  
}