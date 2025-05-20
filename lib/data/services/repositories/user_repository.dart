import 'package:PongChamp/data/services/user_service.dart';
import 'package:PongChamp/domain/models/post_model.dart';
import 'package:PongChamp/domain/models/user_models.dart';
import 'package:firebase_auth/firebase_auth.dart';



class UserRepository {
  final UserService _service;

  UserRepository(this._service);

  Future<AppUser?> getUserById(String userId) async {
    return await _service.getUserById(userId);
  }
}