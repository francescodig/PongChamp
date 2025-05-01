import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '/data/services/repositories/user_post_repository.dart';
import '/domain/models/post_model.dart';

class ProfileViewModel extends ChangeNotifier {
  final UserPostRepository _userPostRepository;

  final userId = FirebaseAuth.instance.currentUser!.uid;
  bool isLoading = true;

  // Stream per ottenere i post dell'utente
  Stream<List<Post>>? postStream;
  bool isLoadingPosts = true;

  ProfileViewModel(this._userPostRepository);

  Future<void> loadProfile(String userId) async {
    isLoading = true;
    notifyListeners();
      postStream = _userPostRepository.getUserPostsStream(userId);
      isLoading = false;
      notifyListeners();
    }
  }



