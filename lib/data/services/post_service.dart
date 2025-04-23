import 'package:PongChamp/domain/models/post_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostService {

  Stream<List<Post>> getPostsStream() {
    // Implementa la logica per ottenere i post da Firestore
    // Restituisci uno Stream di una lista di Post
    return FirebaseFirestore.instance
        .collection('Post')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) {
               return Post.fromFirestore(doc);
            })
            .toList());  
    }
    Future<void> addLikeToPost(String postId, int likes) async {

    await FirebaseFirestore.instance
        .collection('Post')
        .doc(postId)
        .update({'likes': likes + 1});
  }

}