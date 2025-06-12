import 'package:firebase_core/firebase_core.dart';

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

  Future<void> createPostWithTransaction(Post post, Transaction transaction) async {
    final matchRef = _postCollection.doc();
    transaction.set(matchRef, post.toMap());
  }

  // Recupera tutti i posti dalla collezione "Post" in Firestore
  Stream<List<Post>> getPostsStream() {
    // Restituisci uno Stream di una lista di Post
    return FirebaseFirestore.instance
        .collection('Post')
        .orderBy('createdAt', descending: true) // Ordina per data di creazione
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) {
               return Post.fromFirestore(doc);
            })
            .toList());  
    } 




  Stream<List<Post>> getFeed(String currentUserId){
    // Restituisci uno Stream di una lista di Post
    return FirebaseFirestore.instance
        .collection('Post')
        .snapshots()
        .map((snapshot)  {
         // Converto tutti i documenti in oggetti Post
        final allPosts = snapshot.docs.map((doc) => Post.fromFirestore(doc)).toList();

        // Filtra i post per escludere quelli dell'utente corrente
        final posts = allPosts.where((post) => post.idCreator != currentUserId).toList();

        // Calcola un punteggio per ciascun post (più alto = più in alto nel feed)
        // - Post recenti ottengono più punteggio
        // - Più like aumentano il punteggio
        // - Normalizziamo e ponderiamo i valori per bilanciare i fattori

        // Troviamo il timestamp minimo e massimo per la normalizzazione
        final now = DateTime.now();
        final timestamps = posts.map((p) => p.createdAt?.millisecondsSinceEpoch).toList();
        final maxTimestamp = timestamps.isNotEmpty ? timestamps.reduce((a,b) => a! > b! ? a : b) : now.millisecondsSinceEpoch;
        final minTimestamp = timestamps.isNotEmpty ? timestamps.reduce((a,b) => a! < b! ? a : b) : now.millisecondsSinceEpoch;

        // Troviamo max like per normalizzare
        final maxLikes = posts.isNotEmpty ? posts.map((p) => p.likes).reduce((a, b) => a > b ? a : b) : 1;

        double calculateScore(Post post) {
          // Normalizza data: più recente -> valore vicino a 1
          double normalizedRecency = 0;
          if (maxTimestamp != minTimestamp) {
            normalizedRecency = (post.createdAt!.millisecondsSinceEpoch - minTimestamp!) / (maxTimestamp! - minTimestamp);
          } else {
            normalizedRecency = 1; // tutti i post hanno stessa data
          }

          // Normalizza like (evitiamo divisione per zero)
          double normalizedLikes = maxLikes > 0 ? post.likes / maxLikes : 0;

          // Ponderazioni personalizzabili
          const double recencyWeight = 0.7;
          const double likesWeight = 0.3;

          // Calcola punteggio combinato (esempio: somma pesata)
          return recencyWeight * normalizedRecency + likesWeight * normalizedLikes;
        }

        posts.sort((a, b) {
          final scoreA = calculateScore(a);
          final scoreB = calculateScore(b);
          return scoreB.compareTo(scoreA); // decrescente
        });

        return posts;
      });



    }

    // Funzione per mettere mi piace a un post usando una transazione
    Future<void> addLikeToPost(String postId, int likes) async {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final docRef = FirebaseFirestore.instance.collection('Post').doc(postId);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final docSnapshot = await transaction.get(docRef);

        if (!docSnapshot.exists) return;

        final data = docSnapshot.data() as Map<String, dynamic>;
        final likedBy = List<String>.from(data['likedBy'] ?? []);

        // Utente non ha messo like → aggiungi il like
        if (!likedBy.contains(userId)) {
          transaction.update(docRef, {
            'likes': FieldValue.increment(1),
            'likedBy': FieldValue.arrayUnion([userId])
          });
        }
      });
    }

  //Funzione per rimuovere mi piace a un post
  Future<void> removeLikeFromPost(String postId, int likes) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    final docRef = FirebaseFirestore.instance.collection('Post').doc(postId);
    await FirebaseFirestore.instance.runTransaction((transaction) async {

    final docSnapshot = await transaction.get(docRef);

    if (!docSnapshot.exists) return;

    final data = docSnapshot.data()!;
    final likedBy = List<String>.from(data['likedBy'] ?? []);


        // Utente ha messo like → rimuovi il like
      if(likedBy.contains(userId)){
  transaction.update(docRef, {
    'likes': FieldValue.increment(-1),
    'likedBy': FieldValue.arrayRemove([userId])
  });
  }
  // Close the transaction function
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
Future<void> refreshPosts() async {
    // Implementa la logica per ricaricare i post
    

     try {
    // Questo serve per forzare la lettura attuale dei dati dalla collezione.
    // Anche se lo StreamBuilder continua a lavorare, questa lettura singola è utile per forzare il "refresh"
    final snapshot = await _postCollection.get(const GetOptions(source: Source.server));
    
    // Debug
    debugPrint("Post aggiornati: ${snapshot.docs.length} documenti ricevuti dal server.");
    
  } catch (e) {
    debugPrint("Errore durante il refresh dei post: $e");
  }
    
  }

  Future<void> deletePost(String postId) async {
    try {
      await _postCollection.doc(postId).delete();
      debugPrint("Post $postId eliminato con successo.");
    } catch (e) {
      debugPrint("Errore durante l'eliminazione del post: $e");
    }

}

}


