import 'package:PongChamp/data/services/user_service.dart';
import 'package:PongChamp/domain/models/user_models.dart';




class UserRepository {
  final UserService _service;

  UserRepository(this._service);

  Stream<AppUser?> getUserStreamById(String userId)  {
    return  _service.getUserStreamById(userId);
  }

  Future<AppUser?> getUserById(String userId) async {
    return _service.getUserById(userId);
  }
}