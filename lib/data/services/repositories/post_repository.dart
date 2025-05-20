import 'package:PongChamp/domain/models/user_models.dart';

import '/data/services/post_service.dart';
import '/domain/models/post_model.dart';

// Questa classe funge da repository per tutti i post, gestendo le operazioni di recupero e aggiornamento dei post.
// Utilizza il servizio PostService per interagire con Firestore.
class PostRepository {
  final PostService service;
  PostRepository(this.service);

  Stream<List<Post>> getPostsStream() {
    return service.getPostsStream();
  }
  
  Future<Post> addPost(Post post) async {
    return await service.addPost(post);
  }
  Future<void> addLikeToPost(String postId, int likes) async {
    await service.addLikeToPost(postId, likes);
  }
  Future<void> removeLikeFromPost(String postId, int likes) async {
    await service.removeLikeFromPost(postId, likes);
  }
  Future<List<AppUser>> getUsersWhoLikedPost(String postId) async {
    return await service.getUsersWhoLikedPost(postId);
  }
  Future<String?> getCreatorProfileImageUrl(String userId) async {
    return await service.getCreatorProfileImageUrl(userId);
  }
  Future<AppUser?> getUserById(String userId) async{
    return await service.getUserById(userId);
  }


}