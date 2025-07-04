import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import '/data/services/notification_service.dart';
import '/domain/models/notification_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class NotificationViewModel extends ChangeNotifier{
  final _notificationService = NotificationService();

  List<NotificationModel> _notifications = [];
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  List<NotificationModel> get notifications => _notifications;
  List<NotificationModel> get unreadNotifications =>
    _notifications.where((n) => !n.read).toList();

  Future<void> fetchUserNotifications() async {
    _isLoading = true;
    notifyListeners();
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid==null) {
      debugPrint("Errore: $e");
      return;
    }
    _notifications = await _notificationService.fetchUserNotification(uid);
    print("Notifiche caricate: ${_notifications.length}");
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> createNotification({
    required String title,
    required String message,
    required String idEvento,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        throw Exception("Nessun utente loggato.");
      }
      final newNotification = NotificationModel(
        idNotifica: '', //verrà assegnato dal service, una volta generato da Firestore
        title: title,
        message: message, 
        userId: userId, 
        idEvento: idEvento, 
        timestamp: Timestamp.now(), 
        read: false);
      final savedNotification = await _notificationService.addNotification(newNotification);
      _notifications.add(savedNotification);
      return true;
    } catch (e) {
      debugPrint ("$e");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> markAsRead(NotificationModel notification) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId!=notification.userId) return false;
    try {
      final updated = await _notificationService.markAsRead(notification);
      final index = _notifications.indexWhere((n) => n.idNotifica == updated.idNotifica);
      if (index != -1) {
        _notifications[index] = updated;
        notifyListeners();
      }
      return true;
    } catch (e) {
      debugPrint("$e");
      return false;
    }   
  }

  Future<bool> removeNotification(NotificationModel notification) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != notification.userId) {
      throw Exception("Utente non loggato o non proprietario della notifica.");
    }
    _isLoading=true;
    notifyListeners();
    final success = await _notificationService.removeNotification(notification);
    if (success) _notifications.remove(notification);
    _isLoading = false;
    notifyListeners();
    return success;
  }

  Future<bool> markAllAsRead() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) throw Exception("Utente non loggato");
    try {
      for (var notification in _notifications.where((n) => !n.read)) {
        await markAsRead(notification);
      }
      return true;
    } catch (e) {
      debugPrint("$e");
      return false;
    }
  }

  Future<bool> clearNotifications() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) throw Exception("Utente non loggato");
    _isLoading=true;
    notifyListeners();
    try {
      final success = await _notificationService.clearNotifications(userId);
      if (success) _notifications.clear();
      return success;
    } catch (e) {
      debugPrint("$e");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
      
}