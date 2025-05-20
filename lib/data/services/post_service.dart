import '/domain/models/post_model.dart';
import '/domain/models/user_models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';



// Questa classe gestisce le operazioni sui post che appaiono sulla homepage, come il recupero dei post e la gestione dei like
// e dei commenti. Utilizza Firestore per interagire con il database.

class PostService {
  final CollectionReference _postCollection = FirebaseFirestore.instance.collection("Post");

  Future<Post> addPost(Post post) async {
    final docRef = await _postCollection.add(post.toMap());
    final completePost = post.copyWith(id: docRef.id);
    return completePost;
  }

  // Recupera tutti i posti dalla collezione "Post" in Firestore
  Stream<List<Post>> getPostsStream() {
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

    //Funzione per mettere mi piace a un post 
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

  //Funzione per rimuovere mi piace a un post
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


  //Funzione per restituire gli utenti che hanno messo mi piace a un post
 Future<List<AppUser>> getUsersWhoLikedPost(String postId) async {
  final postDoc = await FirebaseFirestore.instance.collection('Post').doc(postId).get();

  if (!postDoc.exists) return [];

  final data = postDoc.data();
  final likedByIds = List<String>.from(data?['likedBy'] ?? []);

  List<AppUser> likedUsersList = [];

  for (final userId in likedByIds) {
    final userDoc = await FirebaseFirestore.instance.collection('User').doc(userId).get();
    if (userDoc.exists) {
      likedUsersList.add(AppUser.fromFirestore(userDoc));
    }
  }

  return likedUsersList;
}

  Future<String?> getCreatorProfileImageUrl(String idCreator) async {
  try {
    final doc = await FirebaseFirestore.instance.collection('User').doc(idCreator).get();
    if (doc.exists) {
      final data = doc.data();
      return data?['profileImage'];
    } else {
      return null; // Utente non trovato
    }
  } catch (e) {
    debugPrint('Errore nel recupero della propic: $e');
    return null;
  }

  }

  Future<AppUser?> getUserById(String userId) async {
  try {
    final doc = await FirebaseFirestore.instance.collection('User').doc(userId).get();
    if (doc.exists) {
      return AppUser.fromFirestore(doc);
    }
    return null;
  } catch (e) {
    print("Errore nel recupero utente: $e");
    return null;
  }
}

}

