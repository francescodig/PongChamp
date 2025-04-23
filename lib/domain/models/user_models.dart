import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class AppUser {
  
  
  final String id;
  String name;
  String surname;
  String phoneNumber;
  String email;
  String password;
  String profileImage;
  DateTime birthDay;
  String sex;
  String nickname;


  AppUser({
  required this.id,
  required this.name, 
  required this.surname, 
  required this.phoneNumber, 
  required this.email, 
  required this.password,
  required this.profileImage,
  required this.birthDay,
  required this.sex,
  required this.nickname,
  });

  factory AppUser.fromFirestore(DocumentSnapshot doc){
    final data = doc.data() as Map<String, dynamic>;
    return AppUser(
      id: doc.id,
      name: data['name'],
      surname: data['surname'],
      phoneNumber: data['phoneNumber'],
      email: data['email'],
      password: data['password'],
      profileImage: data['profileImage'],
      birthDay: (data['birthDay'] as Timestamp).toDate(),
      sex: data['sex'],
      nickname: data['nickname'],
    );
  }

  factory AppUser.fromMap(Map<String, dynamic> map, String docId) {
    return AppUser(
      id: docId,
      name: map['name'],
      surname: map['surname'],
      phoneNumber: map['phoneNumber'],
      email: map['email'],
      password: map['password'],
      profileImage: map['profileImage'],
      birthDay: (map['birthDay'] as Timestamp).toDate(),
      sex: map['sex'] ?? '',
      nickname: map['nickname'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'surname': surname,
      'phoneNumber': phoneNumber,
      'email': email,
      'password': password,
      'profileImage':  profileImage, // lo gestirai separatamente quando salvi l'immagine
      'birthDay': birthDay,
      'sex': sex,
      'nickname': nickname,
    };
  }

  ImageProvider get proPic => profileImage != null
      ? NetworkImage(profileImage)
      : const AssetImage('');
  
}


