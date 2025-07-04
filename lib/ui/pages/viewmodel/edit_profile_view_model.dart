import 'package:PongChamp/data/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';


class EditProfileViewModel extends ChangeNotifier {

  final AuthService _authService = AuthService();

    Future<Map<String, dynamic>> getDataFromUserDoc(String userId) async {

    DocumentSnapshot<Map<String, dynamic>> doc =
        await _authService.fetchUserByIdAsDoc(userId);

    final data = doc.data();
    if (data == null) {
      throw Exception('Nessun dato trovato per l\'utente con ID: $userId');
    }

    return {
      'name': data['Name'],
      'surname': data['Surname'],
      'phoneNumber': data['phoneNumber'],
      'email': data['email'],
      'password': data['password'],
      'nickname': data['nickname'],
      'profileImage': data['profileImage'],
    };




    
  }

  Future<bool> updateUserData(
    String userId,
    String name,
    String surname,
    String nickname,
    String phoneNumber,
    String email,
    String profileImage,
  ) async {
    try {
      await _authService.updateUserData(
        userId,
        name,
        surname,
        nickname,
        phoneNumber,
        email,
        profileImage,
      );
      return true;
    } catch (e) {
      return false;
    }
  }







}