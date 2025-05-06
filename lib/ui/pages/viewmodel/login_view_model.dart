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
      return "The email address is not valid.";
    case 'user-disabled':
      return "This user account has been disabled.";
    case 'user-not-found':
      return "No user found with this email address.";
    case 'wrong-password':
      return "Incorrect password.";
    case 'invalid-credential':
      return "Invalid credentials.";
    default:
      return "Login error. Please try again.";
  }

  }
}
