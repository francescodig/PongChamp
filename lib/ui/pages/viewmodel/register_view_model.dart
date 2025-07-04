import 'package:flutter/material.dart';
import '/data/services/auth_service.dart';

class RegisterViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool isLoading = false;

  
  
  String? errorMessage;

  Future<bool> register( 
    String email, 
    String password, 
    String name,
    String surname,
    String nickname,
    String phoneNumber,
    String sex,
    String birthday,
    String profileImage,
  ) async {



    if (email.isEmpty || password.isEmpty || name.isEmpty || surname.isEmpty) {
    errorMessage = "Please fill in all required fields.";
    notifyListeners();
    return false;
  }




    final result = await _authService.registerWithEmailAndPassword(
      email,
      password,
      name,
      surname,
      nickname,
      phoneNumber,
      sex,
      birthday,
      profileImage,
    );

    isLoading = true;


    if (result != null) {
      isLoading = false;
      errorMessage = "Registration failed. Try again.";
      notifyListeners();
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
          errorMessage = "Registration failed. Try again. ${result}";
      }
      notifyListeners();
      return false;
    }

    return true;
  }
}
