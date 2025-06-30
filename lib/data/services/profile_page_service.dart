import 'package:PongChamp/domain/models/post_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePageService {
  
  // ottieni i post di un utente specifico
  

  /// Ottiene uno stream di post dell'utente specificato.
  /// I post sono ordinati per data di creazione, con i più recenti mostrati per primi.
  /// Per realizzare questa query, che combina where e orderBy, è necessario un indice composito in Firestore. 
  Stream<List<Post>> getUserPostsStream(String userId) {

    return FirebaseFirestore.instance
        .collection('Post')
        .where('idCreator', isEqualTo: userId)
        .orderBy('createdAt', descending: true) // ordina per data (più recenti prima)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Post.fromFirestore(doc))
            .toList());
  }

  Future<List<Post>> getUserPosts(String userId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('Post')
        .where('idCreator', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();
 
        
    return snapshot.docs.map((doc) => Post.fromFirestore(doc)).toList();
  }

}
