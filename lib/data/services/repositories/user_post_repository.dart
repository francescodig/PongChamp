import 'package:PongChamp/domain/models/post_model.dart';
import 'package:PongChamp/data/services/user_post_service.dart';

// Questa classe funge da repository per i post dell'utente, gestendo le operazioni di recupero dei post.
class UserPostRepository {
  final UserPostService _service;

  UserPostRepository(this._service);

  Stream<List<Post>> getUserPostsStream(String userId) {
    return _service.getUserPostsStream(userId);
  }

  Future<List<Post>> getUserPosts(String userId) async {
    return await _service.getUserPosts(userId);
  }
}