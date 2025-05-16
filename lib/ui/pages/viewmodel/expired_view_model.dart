import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/domain/models/event_model.dart';


class ExpiredViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Event> _userParticipatedEvents = [];
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  

  /// Restituisce tutti gli eventi scaduti a cui l'utente ha partecipato
List<Event> get expiredUserParticipatedEvents {
  final now = DateTime.now();
  return _userParticipatedEvents
      .where((event) {
        final eventTime = event.dataEvento;  
        print('Event time: $eventTime');
        return eventTime.isBefore(now);  
      })
      .toList();
}

 Future<void> loadUserParticipatedEvents(String userId) async {
    try {
      // Recupera gli eventi a cui l'utente ha partecipato
      final eventQuerySnapshot = await _firestore
          .collection('Event')
          .where('participantIds', arrayContains: userId)
          .get();

      // Mappa i documenti di Firestore agli oggetti Event
      _userParticipatedEvents = eventQuerySnapshot.docs.map((doc) {
        return Event.fromFirestore(doc);
      }).toList();

      // Notifica che i dati sono stati caricati
      notifyListeners();
    } catch (e) {
      print("Errore nel caricare gli eventi dell'utente: $e");
    }
}

  
}

