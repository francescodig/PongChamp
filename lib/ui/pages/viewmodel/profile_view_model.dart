import 'package:PongChamp/data/services/repositories/profile_page_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '/domain/models/post_model.dart';
import 'package:PongChamp/domain/models/user_models.dart';
import 'package:PongChamp/data/services/auth_service.dart';

class ProfileViewModel extends ChangeNotifier {
  final ProfilePageRepository _userPostRepository;
  final AuthService _authService = AuthService();
  AppUser? _user;

  String? get profileImageUrl => _user?.profileImage;
  String? get userName => _user?.nickname;

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
      final doc = await _authService.fetchUserByIdAsDoc(userId);
      if (doc.exists) {
        _user = AppUser.fromFirestore(doc);
      } else {
        print("Utente non trovato.");
      }
    } catch (e) {
      print("Errore nel caricamento del profilo: $e");
    }

    isLoading = false;
    notifyListeners();
  }
}

  



