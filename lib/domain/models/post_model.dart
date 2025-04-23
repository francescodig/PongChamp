import '/domain/models/match_model.dart';
import '/domain/models/user_models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Post {
  final String id;
  AppUser user;
  PongMatch match;
  int likes;
  String? image; // URL dell'immagine



  Post({
    required this.user,
    required this.match,
    required this.likes,
    required this.image,
    required this.id,
  });

  factory Post.fromFirestore(DocumentSnapshot doc) {
  final data = doc.data() as Map<String, dynamic>;

  return Post(
    id: doc.id,

    // Conversione sicura dell'utente: controlla che sia una mappa
    user: AppUser.fromMap(data['user'] as Map<String, dynamic>, doc.id),

    // Conversione sicura del match
    match: PongMatch.fromMap(data['match'] as Map<String, dynamic>, doc.id),

    // Protezione nel caso 'likes' non esista o sia null
    likes: (data['likes'] as int?) ?? 0,

    // Se è presente l'immagine, la carica da URL, altrimenti null
    image: data['image'],
  );
}

   /// Converte una mappa di Firestore in un oggetto Post
  factory Post.fromMap(Map<String, dynamic> map, String docId) {
     return Post(
    id: docId,
    user: AppUser.fromMap(map['user'] as Map<String, dynamic>, docId),
    match: PongMatch.fromMap(map['match'] as Map<String, dynamic>, docId),
    likes: (map['likes'] as int?) ?? 0,
    image: map['image'],
  );
  }

  /// Converte un oggetto Post in una mappa per Firestore
  Map<String, dynamic> toMap() {
    return {
      'user': user.toMap(),
      'match': match.toMap(),
      'likes': likes,
      'image': image, // se non c'è immagine, metti null, altrimenti converti in un URL
    };
  


  }

   /// Getter utile per usare facilmente l'immagine profilo
  ImageProvider get postImage => image != null
      ? NetworkImage(image!)
      : const AssetImage('');
}