import 'package:flutter/material.dart';
import '/data/services/auth_service.dart';

class RegisterViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  
  String? errorMessage;

  Future<bool> register(String email, String password) async {
    final result = await _authService.registerWithEmailAndPassword(email, password);

    if (result != null) {
      switch (result) {
        case 'email-already-in-use':
          errorMessage = "The email address is already in use.";
          break;
        case 'invalid-email':
          errorMessage = "The email address is not valid.";
          break;
        case 'operation-not-allowed':
          errorMessage = "Email/password accounts are not enabled.";
          break;
        case 'weak-password':
          errorMessage = "The password is too weak.";
          break;
        default:
          errorMessage = "Registration failed. Try again.";
      }
      notifyListeners();
      return false;
    }

    return true;
  }
}
