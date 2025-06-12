import 'package:firebase_auth/firebase_auth.dart';

import '/domain/models/notification_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationService {
  final CollectionReference _notificationCollection = FirebaseFirestore.instance.collection("UserNotifications");

  //Recupera tutte le notifiche di un determinato utente

   Future<List<NotificationModel>> fetchUserNotification(String userId) async {
  print("⏳ [DEBUG] Inizio fetch per UID: $userId");
  try {
    final QuerySnapshot snapshot = await _notificationCollection
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .get();

    print("✅ [DEBUG] Documenti trovati: ${snapshot.docs.length}");
    
    if (snapshot.docs.isEmpty) {
      print("⚠️ [DEBUG] Nessun documento trovato per UID: $userId");
      print("ℹ️ Verifica:");
      print("- Collection name: 'UserNotifications'");
      print("- Campo 'userId' nei documenti");
      print("- UID reale: ${FirebaseAuth.instance.currentUser?.uid}");
    } else {
      print("📄 Primo documento: ${snapshot.docs.first.data()}");
    }

    return snapshot.docs.map((doc) => NotificationModel.fromFirestore(doc)).toList();
  } catch (e, stack) {
    print("❌ [ERRORE] fetchUserNotification fallito:");
    print(e);
    print(stack);
    return [];
  }
}

  //Recupera solo le notifiche non lette
  Future<List<NotificationModel>> fetchUnreadUserNotification(String userId) async {
    final snapshot = await _notificationCollection
        .where('userId', isEqualTo: userId)
        .where('read', isEqualTo: false)
        .orderBy('timestamp', descending: true)
        .get();
    return snapshot.docs.map((doc) {
      return NotificationModel.fromFirestore(doc);
    }).toList();
  }

  //Aggiunge una nuova notifica a Firestore
  Future<NotificationModel> addNotification(NotificationModel notification) async {
    final completeNotification = notification.copyWith(timestamp: Timestamp.now());
    final docRef = await _notificationCollection.add(completeNotification.toFirestore());
    return completeNotification.copyWith(idNotifica: docRef.id);
  }

  //Cancella una notifica
  Future<bool> removeNotification (NotificationModel notification) async {
    await _notificationCollection.doc(notification.idNotifica).delete();
    return true;
  }

  //Rimuove tutte le notifiche dell’utente
  Future<bool> clearNotifications(String userId) async {
    final querySnapshot = await _notificationCollection
      .where('userId', isEqualTo: userId)
      .get();
    for (final doc in querySnapshot.docs){
      final notification = NotificationModel.fromFirestore(doc);
      await removeNotification(notification);
    }
    return true;
  }

  //Segna come letta una singola notifica
  Future<NotificationModel> markAsRead(NotificationModel notification) async {
    if (notification.read) {return notification;}
    final updatedNotification = notification.copyWith(read: true);
    await _notificationCollection.doc(notification.idNotifica).update(updatedNotification.toFirestore());
    return updatedNotification;
  }
  
  //Segna tutte le notifiche di un utente come lette
  Future<List<NotificationModel>> markAllAsRead(String userId) async {
    final List<NotificationModel> updatedNotifications = [];
    final querySnapshot = await _notificationCollection
      .where('userId', isEqualTo: userId)
      .where('read', isEqualTo: false)
      .get();
      for (final doc in querySnapshot.docs){
      final notification = NotificationModel.fromFirestore(doc);
      await markAsRead(notification);
      updatedNotifications.add(notification);
    }
    return updatedNotifications;
  }

}