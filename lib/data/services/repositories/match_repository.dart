import '/data/services/repositories/event_repository.dart';
import '/domain/models/match_model.dart';
import '/data/services/match_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class MatchRepository {
  final MatchService service;
  final EventRepository _eventRepository;
  MatchRepository(this.service, this._eventRepository);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
 
  Future<PongMatch> fetchMatchById(String matchId) async{
    final match = await MatchService().fetchMatchById(matchId);
    return match;
  }

  Future<PongMatch> addMatch(PongMatch match) async {
    return await service.addMatch(match);
  }

  Future<void> createMatchWithEventUpdate(PongMatch match) async {
    await _firestore.runTransaction((transaction) async {
      final event = await _eventRepository.getEventWithTransaction(match.idEvento, transaction);
      if (event.hasMatch) throw Error();
      await service.createMatchWithTransaction(match, transaction);
      await _eventRepository.markEventWithMatchTransaction(match.idEvento, transaction);
    });
  }

    Future<bool> removeMatch(PongMatch event) async {
    try {
      await service.removeMatch(event);
      return true;
    } catch (e) {
      debugPrint("Errore: $e");
      return false;
    }
  }

  Future<List<PongMatch>> fetchUserMatches(String creatorId) async {
    return service.fetchUserMatches(creatorId);
  }

  Stream<List<PongMatch>> getUserMatchStream(String creatorId) {
    return service.getUserMatchStream(creatorId);
  }

  Future<PongMatch> getMatchWithTransaction(String matchId, Transaction transaction) async {
    try {
      final event = await service.getMatchWithTransaction(matchId, transaction);
      return event;
    } catch (e) {
      debugPrint("Errore: $e");
      rethrow;
    }
  }

  Future<void> markMatchWithPostTransaction(String eventId, Transaction transaction) async {
    try {
      await service.markMatchWithPostTransaction(eventId, transaction);
    } catch (e) {
      debugPrint("Errore: $e");
      rethrow;
    }
  }

}