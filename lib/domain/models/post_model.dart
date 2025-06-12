import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class Post  {
  final String id;
  int likes;
  String? image; // URL dell'immagine
  List<String> likedBy;
  String idCreator;
  String idMatch;
  Timestamp? createdAt; 



  Post({
    required this.likes,
    required this.image,
    required this.id,
    required this.likedBy,
    required this.idCreator,
    required this.idMatch,
    required this.createdAt,
  });

  factory Post.fromFirestore(DocumentSnapshot doc) {
  final data = doc.data() as Map<String, dynamic>;

  return Post(
    id: data['id'] ?? doc.id, // Usa l'ID del documento se non è presente

    // Conversione sicura dell'utente: controlla che sia una mappa
    idCreator: data['idCreator'],

    // Conversione sicura del match
    idMatch: data['idMatch'],

    // Protezione nel caso 'likes' non esista o sia null
    likes: (data['likes'] ) ?? 0,

    // Se è presente l'immagine, la carica da URL, altrimenti null
    image: data['image'],

    likedBy: (data['likedBy'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [], // Converte la lista di likedBy in una lista di stringhe

    createdAt: data['createdAt'] as Timestamp? ?? Timestamp.now(), // Imposta la data di creazione, se non presente usa l'ora attuale
  );
}

   /// Converte una mappa di Firestore in un oggetto Post
  factory Post.fromMap(Map<String, dynamic> map, String docId) {
     return Post(
    id: map['id'] ?? docId,
    idCreator: map['idCreator'],
    idMatch: map['idMatch'],
    likes: (map['likes'] as int?) ?? 0,
    image: map['image'],
    likedBy: (map['likedBy'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [], // Converte la lista di likedBy in una lista di stringhe
    createdAt: map['createdAt'] as Timestamp? ?? Timestamp.now(), // Imposta la data di creazione, se non presente usa l'ora attuale

  );
  }

  /// Converte un oggetto Post in una mappa per Firestore
  Map<String, dynamic> toMap() {
    return {
      'idCreator': idCreator,
      'idMatch': idMatch,
      'likes': likes,
      'image': image, // se non c'è immagine, metti null, altrimenti converti in un URL
      'likedBy': likedBy, // Lista di utenti che hanno messo like
      'createdAt': createdAt ?? Timestamp.now(), // Data di creazione, se non c'è, usa l'ora attuale
    };
  


  }

  Post copyWith ({
    String? id,
    int? likes,
    String? image,
    List<String>? likedBy,
    String? idCreator,
    String? idMatch,
  }) {
    return Post(
      likes: likes ?? this.likes, 
      image: image ?? this.image, 
      id: id ?? this.id, 
      likedBy: likedBy ?? this.likedBy, 
      idCreator: idCreator ?? this.idCreator, 
      idMatch: idMatch ?? this.idMatch,
      createdAt: createdAt ?? createdAt,
      );
  }
   /// Getter utile per usare facilmente l'immagine profilo
  ImageProvider get postImage => image != null
      ? NetworkImage(image!)
      : const AssetImage('');


  
}