import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '/data/services/repositories/user_post_repository.dart';
import '/domain/models/post_model.dart';
import 'package:PongChamp/domain/models/user_models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileViewModel extends ChangeNotifier {
  final UserPostRepository _userPostRepository;
  AppUser? _user;

  String? get profileImageUrl => _user?.profileImage;
  String? get userName => _user?.surname;

  final userId = FirebaseAuth.instance.currentUser!.uid;
  bool isLoading = true;

  Stream<List<Post>>? postStream;

  ProfileViewModel(this._userPostRepository);

  Future<void> loadProfile(String userId) async {
    isLoading = true;
    notifyListeners();

    try {
      // Carica i post
      postStream = _userPostRepository.getUserPostsStream(userId);

      // Carica i dati utente da Firestore
      final doc = await FirebaseFirestore.instance.collection('User').doc(userId).get();
      if (doc.exists) {
        _user = AppUser.fromFirestore(doc);
      } else {
        print("Utente non trovato.");
      }
    } catch (e) {
      print("Errore nel loadProfile: $e");
    }

    isLoading = false;
    notifyListeners();
  }
}

  



