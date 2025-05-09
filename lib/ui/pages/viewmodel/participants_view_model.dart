import '/data/services/auth_service.dart';
import '/domain/models/user_models.dart';
import 'package:flutter/foundation.dart';

class ParticipantsViewModel extends ChangeNotifier {
  final _authService= AuthService();

  List<AppUser> _participants = [];
  List<AppUser> get participants => _participants;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<List<AppUser>> loadParticipants(List<String> userIds) async {
    _isLoading = true;
    notifyListeners();
    _participants = await _authService.fetchUsersByIds(userIds);
    _isLoading = false;
    notifyListeners();
    return _participants;
  }
}
