import 'package:PongChamp/domain/models/post_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePageService {
  
  // ottieni i post di un utente specifico
  
  Stream<List<Post>> getUserPostsStream(String userId) {

    return FirebaseFirestore.instance
        .collection('Post')
        .where('idCreator', isEqualTo: userId)
        //.orderBy('timestamp', descending: true) // ordina per data (più recenti prima)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Post.fromFirestore(doc))
            .toList());
  }

  Future<List<Post>> getUserPosts(String userId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('Post')
        .where('idCreator', isEqualTo: userId)
        //.orderBy('timestamp', descending: true)
        .get();
        print("Post trovati: ${snapshot.docs.length}"); 
        
    return snapshot.docs.map((doc) => Post.fromFirestore(doc)).toList();
  }

}
