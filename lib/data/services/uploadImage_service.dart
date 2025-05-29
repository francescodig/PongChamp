import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart'; // Per ottenere il nome del file

class ImageService {
  //Valutare l'utilizzo di Path contenenti almeno l'id dell'utente per mantenere lo Storage più "pulito"
  Future<String?> uploadImage(File image) async {
    try {
      // Ottieni il nome del file (ad esempio "profile.jpg")
      String fileName = basename(image.path);
      // Crea una reference per l'immagine su Firebase Storage
      Reference storageRef = FirebaseStorage.instance.ref().child("$fileName");

      // Carica il file
      UploadTask uploadTask = storageRef.putFile(image);
      TaskSnapshot snapshot = await uploadTask;

      // Ottieni l'URL pubblico dell'immagine
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print("Error uploading image: $e");
      return null; // Se si verifica un errore, ritorna null
    }
  }
}
