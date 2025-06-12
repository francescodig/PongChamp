import 'package:cloud_firestore/cloud_firestore.dart';
import '/data/services/event_service.dart';
import '/domain/models/event_model.dart';
import 'package:flutter/cupertino.dart';

class EventRepository {

  final EventService _eventService;
  EventRepository(this._eventService);

  Future<Event> addEvent(Event event) async {
    try {
      final newEvent = await _eventService.addEvent(event);
      return newEvent;
    } catch (e) {
      debugPrint("Errore: $e");
      rethrow;
    }
  }

  Future<bool> removeEvent(Event event, String userId) async {
    try {
      await _eventService.removeEvent(event, userId);
      return true;
    } catch (e) {
      debugPrint("Errore: $e");
      return false;
    }
  }

  Future<List<Event>> fetchUpcomingEvents() async {
    try {
      final newEvents = await _eventService.fetchUpcomingEvents();
      return newEvents;
    } catch (e) {
      debugPrint("Errore: $e");
      return [];
    }
  }

  Future<List<Event>> fetchUserEvents(String creatorId) async {
    try {
      final userEvents = await _eventService.fetchUserEvents(creatorId);
      return userEvents;
    } catch (e) {
      debugPrint("Errore: $e");
      return [];
    }
  }

  Future<List<Event>> fetchEventsUserParticipates(String userId) async {
    try {
      final userPartecipates = await _eventService.fetchEventsUserParticipates(userId);
      return userPartecipates;
    } catch (e) {
      debugPrint("Errore: $e");
      return [];
    }
  }

  Future<Event> addParticipant(Event event, String userId) async {
    try {
      final updateEvent = await _eventService.addParticipant(event, userId);
      return updateEvent;
    } catch (e) {
      debugPrint("Errore: $e");
      rethrow;
    }
  }

  Future<Event> removeParticipant(Event event, String? userId) async {
    try {
      final updateEvent = await _eventService.removeParticipant(event, userId);
      return updateEvent;
    } catch(e) {
      debugPrint("Errore: $e");
      rethrow;
    }
  }

  Future<bool> markEventWithMatch(String idEvento) async {
    try {
      await _eventService.markEventWithMatch(idEvento);
      return true;
    } catch(e) {
      debugPrint("Errore: $e");
      return false;
    }
  }

  Future<Event> getEventWithTransaction(String idEvento, Transaction transaction) async {
    try {
      final event = await _eventService.getEventWithTransaction(idEvento, transaction);
      return event;
    } catch (e) {
      debugPrint("Errore: $e");
      rethrow;
    }
  }

  Future<void> markEventWithMatchTransaction(String idEvento, Transaction transaction) async {
    try {
      await _eventService.markEventWithMatchTransaction(idEvento, transaction);
    } catch (e) {
      debugPrint("Errore: $e");
      rethrow;
    }
  }


}