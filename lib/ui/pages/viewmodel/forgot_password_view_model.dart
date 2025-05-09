import 'package:cloud_firestore/cloud_firestore.dart';
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

  Future <bool> checkIfEmailExists(String email) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('User')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        _errorMessage = 'Nessun utente trovato con questa email.';
        notifyListeners();
        return false;
      } else {
        return true;
      }
    } catch (e) {
      _errorMessage = 'Errore durante la verifica dell\'email.';
      notifyListeners();
      return false;
    }
  }

    final emailChecker = await checkIfEmailExists(email);
    
    final result = await _authService.sendPasswordResetEmail(email);

    

    _isLoading = false;

 
    if (result == null && emailChecker == true) {
      return true;
    } else if  (emailChecker == false){
      _errorMessage ='user-not-found';
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
