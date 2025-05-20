import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:PongChamp/domain/models/match_model.dart';

class MatchService {
  final CollectionReference _matchCollection = FirebaseFirestore.instance.collection("Match");

  Future<PongMatch> fetchMatchById(String matchId) async {
    final doc = await FirebaseFirestore.instance.collection('Match').doc(matchId).get();
    return PongMatch.fromFirestore(doc);
}
  Future<PongMatch> addMatch(PongMatch match) async {
    final docRef = await _matchCollection.add(match.toMap());
    final completePost = match.copyWith(id: docRef.id);
    return completePost;
  }

}