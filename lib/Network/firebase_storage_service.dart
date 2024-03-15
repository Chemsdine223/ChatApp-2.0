import 'dart:io';

import 'package:chat_app/Constants/constants.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  static Future<String> uploadImageToFirebase(
      File imageFile, String imageName) async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final uploadTask =
          storageRef.child("Images/$imageName").putFile(imageFile);

      await uploadTask;

      // Get the download URL
      final downloadURL =
          await storageRef.child("Images/$imageName").getDownloadURL();

      return downloadURL;
    } catch (e) {
      logger.d("Error uploading image: $e");
      // Handle the error as needed
      return ''; // or throw an exception
    }
  }
}
