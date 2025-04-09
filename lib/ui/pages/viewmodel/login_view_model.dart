import 'package:flutter/material.dart';
import '/data/services/auth_service.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthService _authService;

  LoginViewModel(this._authService);

  String errorMessage = "";

  Future<bool> login(String email, String password) async {
    final errorCode = await _authService.signInWithEmailAndPassword(email, password);

    if (errorCode != null) {
      errorMessage = _getErrorMessage(errorCode);
      notifyListeners();
      return false;
    }

    return true;
  }

  String _getErrorMessage(String code) {
    switch (code) {
      case 'invalid-email':
        return "L'email inserita non è valida.";
      case 'user-disabled':
        return "L'utente è stato disabilitato.";
      case 'user-not-found':
        return "Nessun utente trovato con questa email.";
      case 'wrong-password':
        return "Password errata.";
      case 'invalid-credential':
        return "Credenziali errate o scadute.";
      default:
        return "Errore di accesso. Riprova.";
    }
  }
}
