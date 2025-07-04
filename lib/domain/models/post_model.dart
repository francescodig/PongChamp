import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class Post  {
  final String id;
  int likes;
  String? image; 
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
    id: data['id'] ?? doc.id, 

    idCreator: data['idCreator'],

    idMatch: data['idMatch'],

    likes: (data['likes'] ) ?? 0,

    
    image: data['image'],

    likedBy: (data['likedBy'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],

    createdAt: data['createdAt'] as Timestamp? ?? Timestamp.now(), 
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
    likedBy: (map['likedBy'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [], 
    createdAt: map['createdAt'] as Timestamp? ?? Timestamp.now(),
  );
  }

  /// Converte un oggetto Post in una mappa per Firestore
  Map<String, dynamic> toMap() {
    return {
      'idCreator': idCreator,
      'idMatch': idMatch,
      'likes': likes,
      'image': image, 
      'likedBy': likedBy, 
      'createdAt': createdAt ?? Timestamp.now(), 
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

  ImageProvider get postImage => image != null
      ? NetworkImage(image!)
      : const AssetImage('');


  
}