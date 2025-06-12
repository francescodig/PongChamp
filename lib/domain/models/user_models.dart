import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class AppUser {
  
  
  final String id;
  String name;
  String surname;
  String phoneNumber;
  String email;
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
  required this.profileImage,
  required this.birthDay,
  required this.sex,
  required this.nickname,
  });

  factory AppUser.fromFirestore(DocumentSnapshot doc){
    final data = doc.data() as Map<String, dynamic>;
    return AppUser(
      id: doc.id,
      name: data['Name'],
      surname: data['Surname'],
      phoneNumber: data['phoneNumber'],
      email: data['email'],
      profileImage: data['profileImage'],
      birthDay: (data['birthday'] as Timestamp).toDate(),
      sex: data['sex'],
      nickname: data['nickname'],
    );
  }

  factory AppUser.fromMap(Map<String, dynamic> map, String docId) {
    return AppUser(
      id: docId,
      name: map['Name'],
      surname: map['Surname'],
      phoneNumber: map['phoneNumber'],
      email: map['email'],
      profileImage: map['profileImage'],
      birthDay: (map['birthday'] as Timestamp).toDate(),
      sex: map['sex'] ?? '',
      nickname: map['nickname'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'Name': name,
      'Surname': surname,
      'phoneNumber': phoneNumber,
      'email': email,
      'profileImage':  profileImage, // lo gestirai separatamente quando salvi l'immagine
      'birthday': birthDay,
      'sex': sex,
      'nickname': nickname,
    };
  }


  factory AppUser.fromSnapshot(DocumentSnapshot snapshot) {
  final data = snapshot.data() as Map<String, dynamic>;
  return AppUser(
    id: snapshot.id,
    name: data['Name'],
    surname: data['Surname'],
    phoneNumber: data['phoneNumber'],
    email: data['email'],
    profileImage: data['profileImage'],
    birthDay: (data['birthday'] as Timestamp).toDate(),
    sex: data['sex'] ?? '',
    nickname: data['nickname'] ?? '',
  );
}


  ImageProvider get proPic => profileImage != null
      ? NetworkImage(profileImage)
      : const AssetImage('');
  
}




