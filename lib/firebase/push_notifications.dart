// ignore_for_file: avoid_print

import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_config.dart';

class PushNotifications {
  // FirebaseMessaging instance to handle push notifications
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  // Initialize push notifications
  static Future<void> initialize() async {
    // Ensure Firebase is initialized
    await FirebaseConfig.initializeFirebase();

    // Request notification permissions on iOS (iOS only)
    await _firebaseMessaging.requestPermission();

    // Get the device token (used to send notifications to this device)
    String? token = await _firebaseMessaging.getToken();
    print("Device Token: $token");

    // Listen for foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(
          "Received a message while app is in foreground: ${message.notification?.title}");
      // You can also show a local notification here using `flutter_local_notifications`
      _showNotification(message);
    });

    // Listen for background/terminated messages
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print(
          "Notification clicked! Opened app with message: ${message.notification?.title}");
      // Handle notification click (e.g., navigate to a specific screen)
    });

    // Handle initial notification (if the app is opened by clicking on a notification)
    RemoteMessage? initialMessage =
        await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      print(
          "App opened from a terminated state with message: ${initialMessage.notification?.title}");
      // Handle initial notification click (e.g., navigate to a specific screen)
    }
  }

  // Show a local notification (you can use flutter_local_notifications or any other package)
  static void _showNotification(RemoteMessage message) {
    // Logic to display the notification locally on the device
    // For example, you can use `flutter_local_notifications` to show a system notification
    // Example: FlutterLocalNotificationsPlugin().show(...)
  }

  // Subscribe to a topic (useful for sending notifications to specific groups)
  static Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
    print("Subscribed to topic: $topic");
  }

  // Unsubscribe from a topic
  static Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
    print("Unsubscribed from topic: $topic");
  }

  // This method will be called to handle background notifications when the app is in the background or terminated
  static Future<void> backgroundHandler(RemoteMessage message) async {
    print("Handling background message: ${message.notification?.title}");
    // Handle background notifications (e.g., navigate to a specific screen)
  }
}
