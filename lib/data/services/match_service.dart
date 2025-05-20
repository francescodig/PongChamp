import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:PongChamp/domain/models/match_model.dart';

class MatchService {

  Future<PongMatch> fetchMatchById(String matchId) async {
    final doc = await FirebaseFirestore.instance.collection('Match').doc(matchId).get();
    return PongMatch.fromFirestore(doc);
}

}