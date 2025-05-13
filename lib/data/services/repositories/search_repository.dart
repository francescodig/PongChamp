import 'package:PongChamp/data/services/search_service.dart';
import 'package:PongChamp/domain/models/user_models.dart';

// Questa classe funge da repository per la ricerca degli utenti, gestendo le operazioni di ricerca.
// Utilizza il servizio SearchService per interagire con Firestore.
class SearchRepository {

  final SearchService _service;
  SearchRepository(this._service);
  Future<List<AppUser>> searchUsers(String query) async {
    
    return await _service.searchUsers(query);

  }


}