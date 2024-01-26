import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

Future<String> uploadImage(XFile image) async {
  // Create a reference to Firebase Storage
  FirebaseStorage storage = FirebaseStorage.instance;
  Reference ref =
      storage.ref().child('images/${DateTime.now().millisecondsSinceEpoch}');

  // Upload the file
  UploadTask uploadTask = ref.putFile(File(image.path));

  // Await the completion of the upload task
  final TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
  // Get the download URL of the uploaded file
  final String downloadUrl = await snapshot.ref.getDownloadURL();

  return downloadUrl;
}
