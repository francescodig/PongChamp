import 'package:PongChamp/domain/models/location_model.dart';
import 'package:PongChamp/domain/models/user_models.dart';

class PongMatch {

  late final String id;
  AppUser user1;
  AppUser user2;
  int score1;
  int score2;
  DateTime date;
  Location location;
  String type;


  PongMatch({
    required this.user1,
    required this.user2,
    required this.score1,
    required this.score2,
    required this.date,
    required this.location,
    required this.type,
  });




}