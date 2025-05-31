import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '/domain/models/event_model.dart';

class EventService {
  final CollectionReference _eventsCollection = FirebaseFirestore.instance.collection('Event');

  ///Salvataggio di un nuovo evento
  Future<Event> addEvent(Event event) async {
    // Se l'oggetto Event ha già un createdAt lo usa, altrimenti imposta l'orario attuale
    final completeEvent = event.copyWith(createdAt: event.createdAt);
    // Salva il documento nel database, Firestore genera l'id
    final docRef = await _eventsCollection.add(completeEvent.toFirestore());
    // Restituisce l'oggetto Event con id aggiornato
    return completeEvent.copyWith(id: docRef.id);
  }

  Future<bool> removeEvent(Event event, String userId) async{
    final eventId = event.id;
    if (event.creatorId!=userId){
      throw Exception("Non sei il creatore dell'evento, operazione non autorizzata");
    }
    try {
      await _eventsCollection.doc(eventId).delete();
      return true;
    } catch (e) {
      throw Exception("Errore durante l'eliminazione dell'evento: $e");
    }
  }

  ///Recupero degli eventi non ancora scaduti
  Future<List<Event>> fetchUpcomingEvents() async {
    try {
      final now = Timestamp.fromDate(DateTime.now());
      final snapshot = await _eventsCollection
          .where('dataEvento', isGreaterThan: now)
          .orderBy('dataEvento')
          .get();
      return snapshot.docs.map((doc) {
        return Event.fromFirestore(doc);
      }).toList();
    } catch (e) {
      debugPrint('Errore durante il fetch degli eventi futuri: $e');
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
      debugPrint('Errore durante il fetch degli eventi creati: $e');
      return [];
    }
  }

  ///Ottiene tutti gli eventi a cui partecipa un certo utente
  Future<List<Event>> fetchEventsUserParticipates(String userId) async {
    try {
      final snapshot = await _eventsCollection
          .where('participantIds', arrayContains: userId)
          .get();
      return snapshot.docs.map((doc) { 
        return Event.fromFirestore(doc);
      }).toList();
    } catch (e) {
      debugPrint('Errore nel recupero eventi partecipati: $e');
      return [];
    }
  }

  ///Aggiunge un partecipante ad un evento esistente
  Future<Event> addParticipant(Event event, String userId) async {
    ///eseguiamo anche qui un controllo per evitare errori, es: race conditions
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

  ///Rimuove un partecipante da un evento esistente
  Future<Event> removeParticipant(Event event, String? userId) async {
    final doc = await _eventsCollection.doc(event.id).get();
    final freshEvent = Event.fromFirestore(doc);
    ///eseguiamo anche qui un controllo per evitare errori, es: race conditions
    if (!freshEvent.participantIds.contains(userId)) {
      throw Exception('Utente non iscritto a questo evento.');
    }
    // Rimovione dell'utente
    final updatedParticipantIds = List<String>.from(event.participantIds)..remove(userId);
    final updatedParticipantsCount = updatedParticipantIds.length;
    final updatedEvent = event.copyWith(
      participantIds: updatedParticipantIds,
      participants: updatedParticipantsCount,
    );
    await _eventsCollection.doc(event.id).update(updatedEvent.toFirestore());
    return updatedEvent;
  }

  //Aggiorna il valore hasMatch di un evento a true 
  Future<void> markEventWithMatch(String eventId) async {
    await _eventsCollection.doc(eventId).update({
      'hasMatch': true,
    });
  }

}