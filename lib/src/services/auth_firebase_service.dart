import 'dart:io';
import 'dart:async';
import 'package:firebase_storage/firebase_storage.dart';

class ImageService {
  Future<void> saveImage(File? image, String productName) async {
    final imageName = '$productName.jpg';
    final imageURL = await _uploadUserImage(image, imageName);
    // return imageURL;
  }

  Future<String?> _uploadUserImage(File? image, String imageName) async {
    if (image == null) return null;

    final storage = FirebaseStorage.instance;
    final imageRef = storage.ref().child('rm_products').child(imageName);
    await imageRef.putFile(image).whenComplete(() {});
    return await imageRef.getDownloadURL();
  }
}
