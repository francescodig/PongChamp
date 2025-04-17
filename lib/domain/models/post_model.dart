import 'package:PongChamp/domain/models/match_model.dart';
import 'package:PongChamp/domain/models/user_models.dart';
import 'package:flutter/material.dart';

class Post {
  late final String id;
  AppUser user;
  PongMatch match;
  late int likes;
  Image image;



  Post({
    required this.user,
    required this.match,
    required this.image,
  });
  


}