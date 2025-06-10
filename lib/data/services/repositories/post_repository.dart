import 'package:PongChamp/data/services/repositories/match_repository.dart';
import 'package:PongChamp/domain/models/user_models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '/data/services/post_service.dart';
import '/domain/models/post_model.dart';

// Questa classe funge da repository per tutti i post, gestendo le operazioni di recupero e aggiornamento dei post.
// Utilizza il servizio PostService per interagire con Firestore.
class PostRepository {
  final PostService service;
  final MatchRepository _matchRepository;
  PostRepository(this.service, this._matchRepository);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Post>> getPostsStream() {
    return service.getPostsStream();
  }
  
  Future<Post> addPost(Post post) async {
    return await service.addPost(post);
  }

  Future<void> createPostWithMatchUpdate(Post post) async {
    await _firestore.runTransaction((transaction) async {
      final match = await _matchRepository.getMatchWithTransaction(post.idMatch, transaction);
      if (match.hasPost) throw Error();
      await service.createPostWithTransaction(post, transaction);
      await _matchRepository.markMatchWithPostTransaction(post.idMatch, transaction);
    });
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
  Future<void> refreshPosts() async{
    return await service.refreshPosts();
  }
  Future<void> deletePost(String postId) async {
    return await service.deletePost(postId);
  }
}