

import 'package:PongChamp/domain/models/user_models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchService {

 


   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<AppUser>> searchUsers(String query) async {
    final snapshot = await _firestore
        .collection('User')
        .where('nickname', isGreaterThanOrEqualTo: query)
        .where('nickname', isLessThanOrEqualTo: '$query\uf8ff')
        .get();

    return snapshot.docs
        .map((doc) => AppUser.fromMap(doc.data(), doc.id))
        .toList();
  }


  
} 



