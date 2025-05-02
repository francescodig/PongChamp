import '/domain/models/user_models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get currentUserId => FirebaseAuth.instance.currentUser?.uid;

  Future<String?> registerWithEmailAndPassword(
    String email, 
    String password,
    String name,
    String surname,
    String nickname,
    String phoneNumber,
    String sex,
    String birthDay,
    String profileImage,
    )  async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      final user = result.user; // success


      if (user != null) {
      // Salva anche su Firestore
      await FirebaseFirestore.instance.collection('User').doc(user.uid).set({
        'id': user.uid,
        'Name': name,
        'Surname': surname,
        'email': email,
        'phoneNumber': phoneNumber,
        'nickname': nickname,
        'birthday': Timestamp.fromDate(DateTime.parse(birthDay)),
        'profileImage': profileImage,
        'sex': sex,
        'password': password,
        // 'createdAt': FieldValue.serverTimestamp(),
      });
    }

    return null;
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



// da implementare 
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

Future<AppUser> fetchUserById(String userId) async {
  final doc = await FirebaseFirestore.instance.collection('User').doc(userId).get();
  return AppUser.fromFirestore(doc);
}

Future<void> signOut() async {
  await _auth.signOut();
}

}
