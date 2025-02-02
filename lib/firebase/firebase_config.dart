// ignore_for_file: avoid_print

import 'package:firebase_core/firebase_core.dart';

class FirebaseConfig {
  // Initialize Firebase in your app
  static Future<void> initializeFirebase() async {
    try {
      // Ensure that Firebase is initialized before using any Firebase features
      await Firebase.initializeApp();
      print("Firebase initialized successfully!");
    } catch (e) {
      print("Error initializing Firebase: $e");
    }
  }
}
