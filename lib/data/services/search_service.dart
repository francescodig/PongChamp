

import 'package:PongChamp/domain/models/user_models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchService {

 
    // Implementa la logica per cercare gli utenti in base al nome utente
    // Puoi utilizzare Firestore o qualsiasi altro database che stai utilizzando
    // Restituisci uno stream di lista di AppUser

   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<AppUser>> searchUsers(String query) async {
    final snapshot = await _firestore
        .collection('User')
        .where('nickname', isGreaterThanOrEqualTo: query)
        .where('nickname', isLessThanOrEqualTo: query + '\uf8ff')
        .get();

    return snapshot.docs
        .map((doc) => AppUser.fromMap(doc.data(), doc.id))
        .toList();
  }


  
} 



