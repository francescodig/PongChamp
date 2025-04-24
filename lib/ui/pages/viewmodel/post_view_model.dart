import 'package:PongChamp/domain/models/user_models.dart';
import 'package:flutter/foundation.dart';

import '/data/services/repositories/post_repository.dart';
import '/domain/models/post_model.dart';

class PostViewModel extends ChangeNotifier {

  final PostRepository repository;
  PostViewModel(this.repository);
  Stream<List<Post>> getPostsStream() {
    return repository.getPostsStream();
  }
  Future<void> addLikeToPost(Post post) async{
    // Implementa la logica per aggiungere un like al post
    // Puoi usare il repository per interagire con il servizio
    await repository.addLikeToPost(post.id, post.likes);
    notifyListeners(); // Notifica i listener dopo aver aggiornato il post
  }
  Future<void> removeLikeFromPost(Post post) async {
    // Implementa la logica per rimuovere un like dal post
    // Puoi usare il repository per interagire con il servizio
    await repository.removeLikeFromPost(post.id, post.likes);
    notifyListeners(); // Notifica i listener dopo aver aggiornato il post
  }
  Future<List<AppUser>> getUsersWhoLikedPost(String postId) async {
    return await repository.getUsersWhoLikedPost(postId);
  }
}