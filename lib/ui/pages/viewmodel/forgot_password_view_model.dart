import 'package:flutter/material.dart';
import '/data/services/auth_service.dart';

class ForgotPasswordViewModel extends ChangeNotifier {
  final AuthService _authService;

  ForgotPasswordViewModel(this._authService);

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> sendResetEmail(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

  

    
    
    final result = await _authService.sendPasswordResetEmail(email);

    final emailChecker = await _authService.checkIfEmailExists(email);

    /* print('Email exists: $emailChecker');
    print('Result: $result');
    print('1.Error message: $_errorMessage');
    */

    

    _isLoading = false;

 
    if (result == null && emailChecker == true) {
      return true;
    } else if  (emailChecker == false){
      _errorMessage =_mapError('user-not-found');
      notifyListeners();
      return false;
    }
    else {
      _errorMessage = _mapError(result!);
      notifyListeners();
      return false;
    }
  }

  String _mapError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'Nessun utente trovato con questa email.';
      case 'invalid-email':
        return 'Formato email non valido.';
      default:
        return 'Si è verificato un errore. Riprova.';
    }
  }
}
