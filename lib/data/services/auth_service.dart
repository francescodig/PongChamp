import '/domain/models/user_models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Questa classe gestisce l'autenticazione degli utenti e le operazioni correlate.
// Utilizza Firebase Authentication per gestire la registrazione, il login e il recupero della password.
// Inoltre, gestisce anche le operazioni di salvataggio e recupero degli utenti da Firestore.
// La classe AuthService fornisce metodi per registrare un nuovo utente, effettuare il login, inviare email di reset della password,
// controllare se un'email esiste già e recuperare informazioni sugli utenti.
// Inoltre, fornisce metodi per il logout e per recuperare l'ID dell'utente corrente.
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
    ) async {
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

Future <bool> checkIfEmailExists(String email) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('User')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      return false;
    }
  }



//Singolo utente
Future<AppUser> fetchUserById(String userId) async {
  final doc = await FirebaseFirestore.instance.collection('User').doc(userId).get();
  return AppUser.fromFirestore(doc);
}

//Funzione per recuperare un utente da Firestore 
// e restituire un DocumentSnapshot
Future<DocumentSnapshot<Map<String, dynamic>>> fetchUserByIdAsDoc(String userId) {
  return FirebaseFirestore.instance.collection('User').doc(userId).get();
}

//Lista di utenti
Future<List<AppUser>> fetchUsersByIds(List<String> ids) async {
  final List<AppUser> users = [];

  for (final id in ids) {
    final user = await fetchUserById(id); 
    users.add(user);
  }

  return users;
}

//Funzione per aggiornare i dati dell'utente
Future<void> updateUserData(
  String userId,
  String name,
  String surname,
  String nickname,
  String phoneNumber,
  String email,
  String password,
  String profileImage,
) async {
  try {
    await FirebaseFirestore.instance.collection('User').doc(userId).update({
      'Name': name,
      'Surname': surname,
      'nickname': nickname,
      'phoneNumber': phoneNumber,
      'email': email,
      'password': password,
      'profileImage': profileImage,
    });
  } catch (e) {
    throw Exception('Errore durante l\'aggiornamento dei dati: $e');
  }
}

Future<void> signOut() async {
  await _auth.signOut();
}


}
