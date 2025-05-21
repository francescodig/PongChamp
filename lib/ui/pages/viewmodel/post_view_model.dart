import '/domain/models/user_models.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '/data/services/repositories/post_repository.dart';
import '/domain/models/post_model.dart';

class PostViewModel extends ChangeNotifier {

  final PostRepository repository;
  PostViewModel(this.repository);
  bool _isLoading = false;

  Future<void> createPost({
    required String idMatch,
    required String image,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final newPost = Post(
        likes: 0,
        image: image,
        id: "", //verrà assegnato dal service una volta generato da Firestore
        likedBy: [], 
        idCreator: userId, 
        idMatch: idMatch
      );
    final postSaved = await repository.addPost(newPost);
    } catch(e) {
      debugPrint("$e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Stream<List<Post>> getPostsStream() {
    return repository.getPostsStream();
  }
  Future<void> addLikeToPost(String id, int likes) async{
    // Implementa la logica per aggiungere un like al post
    // Puoi usare il repository per interagire con il servizio
    await repository.addLikeToPost(id, likes);
    notifyListeners(); // Notifica i listener dopo aver aggiornato il post
  }
  Future<void> removeLikeFromPost(String id, int likes) async {
    // Implementa la logica per rimuovere un like dal post
    // Puoi usare il repository per interagire con il servizio
    await repository.removeLikeFromPost(id, likes);
    notifyListeners(); // Notifica i listener dopo aver aggiornato il post
  }
  Future<List<AppUser>> getUsersWhoLikedPost(String postId) async {
    return await repository.getUsersWhoLikedPost(postId);
  }
  Future<String?> getCreatorProfileImageUrl(String userId) async {
    return await repository.getCreatorProfileImageUrl(userId);
  }
  Future<AppUser?> getUserById(String userId) async {
    return await repository.getUserById(userId);
  }
}