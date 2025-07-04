import 'package:PongChamp/domain/models/user_models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';






class UserService {


  Stream<AppUser?> getUserStreamById(String id) {
  return FirebaseFirestore.instance
    .collection('User')
    .doc(id)
    .snapshots()
    .map((snapshot) => snapshot.exists ? AppUser.fromSnapshot(snapshot) : null);
}
  Future<AppUser?> getUserById(String userId) async {
    try {
      final doc = await FirebaseFirestore.instance.collection('User').doc(userId).get();
      if (doc.exists) {
        return AppUser.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

}

