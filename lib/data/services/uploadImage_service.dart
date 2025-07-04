import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart'; // Per ottenere il nome del file

class ImageService {

  Future<String?> uploadImage(File image) async {
    try {

      String fileName = basename(image.path);

      Reference storageRef = FirebaseStorage.instance.ref().child("$fileName");

      // Carica il file
      UploadTask uploadTask = storageRef.putFile(image);
      TaskSnapshot snapshot = await uploadTask;

      // Ottieni l'URL pubblico dell'immagine
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      return null; 
    }
  }
}
