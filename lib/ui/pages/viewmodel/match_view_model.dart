import 'package:PongChamp/domain/models/match_model.dart';
import 'package:PongChamp/data/services/match_service.dart';
import 'package:PongChamp/data/services/repositories/match_repository.dart';

import 'package:flutter/material.dart';

class MatchViewModel  extends ChangeNotifier{

  final MatchRepository repository;
  MatchViewModel(this.repository);

  Future<PongMatch> fetchMatchById(String matchId) async {
    return await repository.fetchMatchById(matchId);
  }

  






}