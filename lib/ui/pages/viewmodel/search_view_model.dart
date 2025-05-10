import 'package:PongChamp/data/services/repositories/search_repository.dart';
import 'package:PongChamp/domain/models/user_models.dart';
import 'package:flutter/material.dart';

class SearchViewModel  extends ChangeNotifier{

  final SearchRepository _repository;

  SearchViewModel(this._repository);

  List<AppUser> _results = [];
  List<AppUser> get results => _results;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> search(String query) async {
    if (query.isEmpty) {
      _results = [];
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    _results = await _repository.searchUsers(query);

    _isLoading = false;
    notifyListeners();
  }

  
}

  









