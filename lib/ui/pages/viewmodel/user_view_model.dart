import 'package:PongChamp/data/services/repositories/user_repository.dart';
import 'package:PongChamp/domain/models/user_models.dart';
import 'package:flutter/material.dart';


class UserViewModel extends ChangeNotifier{

  final UserRepository repository;
  UserViewModel(this.repository);

  Stream<AppUser?> getUserStreamById(String userId){
    return  repository.getUserStreamById(userId);
  }

  Future<AppUser?> getUserById(String userId) async {
    return repository.getUserById(userId);
  }




}