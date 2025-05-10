import 'package:PongChamp/data/services/search_service.dart';
import 'package:PongChamp/domain/models/user_models.dart';

class SearchRepository {

  final SearchService _service;
  SearchRepository(this._service);
  Future<List<AppUser>> searchUsers(String query) async {
    
    return await _service.searchUsers(query);

  }


}