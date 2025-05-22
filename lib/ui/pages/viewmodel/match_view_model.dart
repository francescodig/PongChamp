import 'package:firebase_auth/firebase_auth.dart';
import '/domain/models/event_model.dart';
import '/domain/models/match_model.dart';
import '/data/services/repositories/match_repository.dart';
import 'package:flutter/material.dart';

class MatchViewModel  extends ChangeNotifier{
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  List<PongMatch> _matches = [];
  List<PongMatch> get matches => _matches;

  final MatchRepository repository;
  MatchViewModel(this.repository);

  Future<PongMatch> fetchMatchById(String matchId) async {
    return await repository.fetchMatchById(matchId);
  }

  Future<void> createMatch({
    required int score1,
    required int score2,
    required Event event,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final newMatch = PongMatch(
        id: "", //viene aggiunto dal service una volta generato da Firestore
        creatorId: userId,
        score1: score1,
        score2: score2,
        date: event.dataEvento,
        idEvento: event.id,
        type: event.eventType,
        matchPlayers: [],
      );
      if (event.eventType == "1 vs 1"){
        final matchSaved = await repository.addMatch(newMatch.copyWith(matchPlayers: event.participantIds));
        _matches.add(matchSaved);
      } else {
        final matchSaved = await repository.addMatch(newMatch.copyWith(matchPlayers: []));
        _matches.add(matchSaved);
      }
    } catch(e) {
      debugPrint("$e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchUserMatches() async {
    _isLoading = true;
    notifyListeners();
    final uid = FirebaseAuth.instance.currentUser!.uid;
    _matches = await repository.fetchUserMatches(uid);
    _isLoading = false;
    notifyListeners();
  }

  Stream<List<PongMatch>> getUserMatchStream() {
    final creatorId = FirebaseAuth.instance.currentUser!.uid;
    return repository.getUserMatchStream(creatorId);
  }






}