import 'package:PongChamp/domain/models/match_model.dart';
import 'package:PongChamp/data/services/match_service.dart';

class MatchRepository {
  final MatchService service;
  MatchRepository(this.service);
 
  Future<PongMatch> fetchMatchById(String matchId) async{
    final match = await MatchService().fetchMatchById(matchId);
    return match;
  }

  Future<PongMatch> addMatch(PongMatch match) async {
    return await service.addMatch(match);
  }

  Future<List<PongMatch>> fetchUserMatches(String creatorId) async {
    return service.fetchUserMatches(creatorId);
  }

  Stream<List<PongMatch>> getUserMatchStream(String creatorId) {
    return service.getUserMatchStream(creatorId);
  }
}