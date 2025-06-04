import 'package:cloud_firestore/cloud_firestore.dart';
import '/domain/models/match_model.dart';

class MatchService {
  final CollectionReference _matchCollection = FirebaseFirestore.instance.collection("Match");

  Future<PongMatch> fetchMatchById(String matchId) async {
    final doc = await _matchCollection.doc(matchId).get();
    return PongMatch.fromFirestore(doc);
  }
  
  Future<List<PongMatch>> fetchUserMatches(String creatorId) async {
    final snapshot = await _matchCollection
      .where('creatorId', isEqualTo: creatorId)
      .where('hasPost', isEqualTo: false)
      .get();
    return snapshot.docs.map((doc) {
        return PongMatch.fromFirestore(doc);
      }).toList();
  }

  Stream<List<PongMatch>> getUserMatchStream(String creatorId) {
    return _matchCollection.where("creatorId", isEqualTo: creatorId).snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) {
               return PongMatch.fromFirestore(doc);
            })
            .toList());  
  }
  
  Future<PongMatch> addMatch(PongMatch match) async {
    final docRef = await _matchCollection.add(match.toMap());
    final completeMatch = match.copyWith(id: docRef.id);
    return completeMatch;
  }

  Future<void> createMatchWithTransaction(PongMatch match, Transaction transaction) async {
    final matchRef = _matchCollection.doc();
    transaction.set(matchRef, match.toMap());
  }

  Future<bool> removeMatch(PongMatch match) async{
    try {
      await _matchCollection.doc(match.id).delete();
      return true;
    } catch (e) {
      throw Exception("Errore durante l'eliminazione del match: $e");
    }
  }

  Future<PongMatch> getMatchWithTransaction(String matchId, Transaction transaction) async {
    final doc = await transaction.get(_matchCollection.doc(matchId));
    return PongMatch.fromFirestore(doc);
  }

  Future<void> markMatchWithPostTransaction(String matchId, Transaction transaction) async {
    transaction.update(_matchCollection.doc(matchId), {
      'hasPost': true,
    });
  }
}