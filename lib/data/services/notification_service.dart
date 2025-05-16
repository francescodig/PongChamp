import 'package:flutter/material.dart';
import '/domain/models/notification_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationService {
  final CollectionReference _notificationCollection = FirebaseFirestore.instance.collection("Notification");

  //Recupera tutte le notifiche di un determinato utente
  Future<List<NotificationModel>> fetchUserNotification(String userId) async {
    try {
      final snapshot = await _notificationCollection
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .get();
      return snapshot.docs.map((doc) {
        return NotificationModel.fromFirestore(doc);
      }).toList();
    } catch (e) {
      debugPrint("Errore: $e");
      return [];
    }
  }

  //Recupera solo le notifiche non lette
  Future<List<NotificationModel>> fetchUnreadUserNotification(String userId) async {
    try {
      final snapshot = await _notificationCollection
          .where('userId', isEqualTo: userId)
          .where('read', isEqualTo: false)
          .orderBy('timestamp', descending: true)
          .get();
      return snapshot.docs.map((doc) {
        return NotificationModel.fromFirestore(doc);
      }).toList();
    } catch (e) {
      debugPrint("Errore: $e");
      return [];
    }
  }

  //Aggiunge una nuova notifica a Firestore
  Future<NotificationModel> addNotification(NotificationModel notification) async {
    try {
      final completeNotification = notification.copyWith(timestamp: DateTime.now());
      final docRef = await _notificationCollection.add(completeNotification.toFirestore());
      return completeNotification.copyWith(idNotifica:  docRef.id);
    } catch (e) {
      debugPrint("Errore durante l'aggiunta della notifica: $e");
      return notification;
    }
  }

  //Cancella una notifica
  Future<bool> removeNotification (NotificationModel notification) async {
    try {
      await _notificationCollection.doc(notification.idNotifica).delete();
      return true;
    } catch (e) {
      debugPrint("Errore nell'eliminazione della notifica: $e");
      return false;
    }
  }

  //Rimuove tutte le notifiche dell’utente
  Future<bool> clearNotifications(String userId) async {
    try {
      final querySnapshot = await _notificationCollection
        .where('userId', isEqualTo: userId)
        .get();
      for (final doc in querySnapshot.docs){
        final notification = NotificationModel.fromFirestore(doc);
        await removeNotification(notification);
      }
      return true;
    } catch (e) {
      debugPrint("Errore nell'operazione: $e");
      return false;
    }
  }

  //Segna come letta una singola notifica
  Future<NotificationModel> markAsRead(NotificationModel notification) async {
    if (notification.read) {return notification;}
    try {
      final updatedNotification = notification.copyWith(read: true);
      await _notificationCollection.doc(notification.idNotifica).update(updatedNotification.toFirestore());
      return updatedNotification;
    } catch (e) {
      debugPrint("Errore nell'aggiornamento della notifica: $e");
      return notification;
    }
  }
  
  //Segna tutte le notifiche di un utente come lette
  Future<List<NotificationModel>> markAllAsRead(String userId) async {
    final List<NotificationModel> updatedNotifications = [];
    try {
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
    } catch (e) {
      debugPrint("Errore nell'operazione: $e");
      return [];
    }
  }

}