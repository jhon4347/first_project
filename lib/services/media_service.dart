import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MediaService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  get path => null;

  // Upload media (images, videos, etc.) to Firebase Storage
  Future<String?> uploadMedia(String filePath) async {
    try {
      // Get the file from the local device
      File file = File(filePath);

      // Get the file name and create a reference in Firebase Storage
      String fileName = path.basename(file.path);
      UploadTask uploadTask =
          _storage.ref().child('media/$fileName').putFile(file);

      // Wait for the upload to complete and get the media URL
      TaskSnapshot taskSnapshot = await uploadTask;
      String mediaUrl = await taskSnapshot.ref.getDownloadURL();

      return mediaUrl;
    } catch (e) {
      debugPrint('Error uploading media: $e');
      return null;
    }
  }

  // Pick an image or video from the gallery or camera
  Future<File?> pickMedia(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } catch (e) {
      debugPrint('Error picking media: $e');
      return null;
    }
  }

  // Upload an image picked by the user
  Future<String?> uploadImage(ImageSource source) async {
    try {
      // Pick an image from the gallery or camera
      File? imageFile = await pickMedia(source);

      if (imageFile != null) {
        // Upload the image to Firebase Storage
        return await uploadMedia(imageFile.path);
      }
      return null;
    } catch (e) {
      debugPrint('Error uploading image: $e');
      return null;
    }
  }

  // Download media from Firebase Storage (e.g., image or video)
  Future<File?> downloadMedia(String mediaUrl) async {
    try {
      // Create a reference to the media file in Firebase Storage
      Reference ref = _storage.refFromURL(mediaUrl);

      // Get the local path where the file will be downloaded
      String localPath = '/path/to/local/directory/${path.basename(ref.name)}';

      // Download the file
      File file = File(localPath);
      await ref.writeToFile(file);

      return file;
    } catch (e) {
      debugPrint('Error downloading media: $e');
      return null;
    }
  }

  // Delete media from Firebase Storage
  Future<void> deleteMedia(String mediaUrl) async {
    try {
      // Create a reference to the media file in Firebase Storage
      Reference ref = _storage.refFromURL(mediaUrl);

      // Delete the file from Firebase Storage
      await ref.delete();
      debugPrint('Media deleted successfully');
    } catch (e) {
      debugPrint('Error deleting media: $e');
    }
  }

  // Display a preview of the media (image/video)
  Widget getMediaPreview(String mediaUrl) {
    return Image.network(mediaUrl);
  }
}
