import '/data/services/post_service.dart';
import '/domain/models/post_model.dart';

class PostRepository {
  final PostService service;
  PostRepository(this.service);

  Stream<List<Post>> getPostsStream() {
    return service.getPostsStream();
  }
  
  Future<void> addLikeToPost(String postId, int likes) async {
    await service.addLikeToPost(postId, likes);
  }
  Future<void> removeLikeFromPost(String postId, int likes) async {
    await service.removeLikeFromPost(postId, likes);
  }

}