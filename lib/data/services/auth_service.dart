import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> registerWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return null; // success
    } on FirebaseAuthException catch (e) {
      return e.code;
    } catch (e) {
      return "unknown-error";
    }
  }

  Future<String?> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null; // success
    } on FirebaseAuthException catch (e) {
      return e.code;
    } catch (e) {
      return "unknown-error";
    }
  }

  Future<String?> sendPasswordResetEmail(String email) async {
  try {
    await _auth.sendPasswordResetEmail(email: email);
    return null;
  } on FirebaseAuthException catch (e) {
    return e.code;
  } catch (e) {
    return "unknown-error";
  }
}


Future<void> signOut() async {
  await _auth.signOut();
}

}
