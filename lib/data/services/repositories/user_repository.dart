import 'package:PongChamp/data/services/user_service.dart';
import 'package:PongChamp/domain/models/post_model.dart';
import 'package:PongChamp/domain/models/user_models.dart';
import 'package:firebase_auth/firebase_auth.dart';



class UserRepository {
  final UserService _service;

  UserRepository(this._service);

  Stream<AppUser?> getUserStreamById(String userId)  {
    return  _service.getUserStreamById(userId);
  }
}