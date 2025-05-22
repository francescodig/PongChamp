import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:PongChamp/domain/models/match_model.dart';

class MatchService {
  final CollectionReference _matchCollection = FirebaseFirestore.instance.collection("Match");

  Future<PongMatch> fetchMatchById(String matchId) async {
    final doc = await FirebaseFirestore.instance.collection('Match').doc(matchId).get();
    return PongMatch.fromFirestore(doc);
  }
  
  Future<List<PongMatch>> fetchUserMatches(String creatorId) async {
    final snapshot = await _matchCollection
      .where('creatorId', isEqualTo: creatorId)
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
    final completePost = match.copyWith(id: docRef.id);
    return completePost;
  }

}