import 'package:cloud_firestore/cloud_firestore.dart';
import '/domain/models/event_model.dart';

class EventService {
  final CollectionReference _eventsCollection = FirebaseFirestore.instance.collection('Event');

  ///Salvataggio di un nuovo evento
  Future<Event> addEvent(Event event) async {
    // Se l'oggetto Event ha già un createdAt lo usa, altrimenti imposta l'orario attuale
    final completeEvent = event.copyWith(createdAt: event.createdAt ?? DateTime.now(),);
    // Salva il documento nel database (Firestore genera l'id)
    final docRef = await _eventsCollection.add(completeEvent.toFirestore());
    // Restituisce l'oggetto Event con id aggiornato
    return completeEvent.copyWith(id: docRef.id);
  }

  ///Recupero degli eventi non ancora scaduti

  Future<List<Event>> fetchUpcomingEvents() async {
    try {
      final now = Timestamp.fromDate(DateTime.now());
      final snapshot = await _eventsCollection
          .where('orario', isGreaterThan: now)
          .orderBy('orario') // opzionale ma utile
          .get();
      return snapshot.docs.map((doc) {
        return Event.fromFirestore(doc);
      }).toList();
    } catch (e) {
      print('Errore durante il fetch degli eventi futuri: $e');
      return [];
    }
  }

  /// Ottiene tutti gli eventi creati da un certo utente
  Future<List<Event>> fetchUserEvents(String creatorId) async {
    try {
      final snapshot = await _eventsCollection
        .where('creatorId', isEqualTo: creatorId)
        .get();
      return snapshot.docs.map((doc) {
       return Event.fromFirestore(doc);
      }).toList();
    } catch (e) {
      print('Errore durante il fetch degli eventi futuri: $e');
      return [];
    }
  }

  Future<Event> addParticipant(Event event, String userId) async {
    //eseguiamo anche qui un controllo per evitare errori (es: race conditions)
    if (event.participantIds.contains(userId)) {
      throw Exception('Utente già iscritto a questo evento.');
    }
    if (event.participantIds.length >= event.maxParticipants) {
      throw Exception('Numero massimo di partecipanti raggiunto.');
    }
    // Aggiunta dell'utente
    final updatedParticipantIds = [...event.participantIds, userId];
    final updatedParticipantsCount = updatedParticipantIds.length;
    final updatedEvent = event.copyWith(
      participantIds: updatedParticipantIds,
      participants: updatedParticipantsCount,
    );
    await _eventsCollection.doc(event.id).update(updatedEvent.toFirestore());
    return updatedEvent;
  }

}