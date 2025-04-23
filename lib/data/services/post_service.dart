import 'package:PongChamp/domain/models/post_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    final userId = FirebaseAuth.instance.currentUser!.uid;

    final docRef = FirebaseFirestore.instance.collection('Post').doc(postId);
    final docSnapshot = await docRef.get();

    if (!docSnapshot.exists) return;

    final data = docSnapshot.data()!;
    final likedBy = List<String>.from(data['likedBy'] ?? []);


        // Utente non ha messo like → aggiungi il like
      await docRef.update({
      'likes':  FieldValue.increment(1),
      'likedBy': FieldValue.arrayUnion([userId])
      });
 
  }

  Future<void> removeLikeFromPost(String postId, int likes) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    final docRef = FirebaseFirestore.instance.collection('Post').doc(postId);
    final docSnapshot = await docRef.get();

    if (!docSnapshot.exists) return;

    final data = docSnapshot.data()!;
    final likedBy = List<String>.from(data['likedBy'] ?? []);


        // Utente ha messo like → rimuovi il like
      await docRef.update({
      'likes':  FieldValue.increment(-1),
      'likedBy': FieldValue.arrayRemove([userId])
      });
 
  }
}

