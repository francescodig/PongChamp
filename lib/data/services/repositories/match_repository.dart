import 'package:PongChamp/domain/models/match_model.dart';
import 'package:PongChamp/data/services/match_service.dart';

class MatchRepository {

  Future<PongMatch> fetchMatchById(String matchId) async{
    final match = await MatchService().fetchMatchById(matchId);
    return match;
  }



}