import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'; // For checking web or mobile platform

class FirebaseConfig {
  static Future<void> initialize() async {
    if (kIsWeb) {
      // For Web platform: Initialize with web-specific configuration
      await Firebase.initializeApp(
        options: FirebaseOptions(
          apiKey: 'your-api-key',
          authDomain: 'your-auth-domain',
          projectId: 'your-project-id',
          storageBucket: 'your-storage-bucket',
          messagingSenderId: 'your-sender-id',
          appId: 'your-app-id',
          measurementId: 'your-measurement-id',
        ),
      );
    } else {
      // For mobile platform (Android/iOS)
      await Firebase.initializeApp();
    }
  }
}
