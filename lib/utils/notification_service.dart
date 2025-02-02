// ignore_for_file: avoid_print

import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Initialize the notification service
  Future<void> init() async {
    // Initialize local notifications
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
    );
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Request notification permissions
    await requestPermission();

    // Get the FCM token for the device
    String? token = await _firebaseMessaging.getToken();
    print("FCM Token: $token");

    // Listen for incoming notifications while the app is in the foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received message: ${message.notification?.title}');
      _showNotification(message);
    });

    // Handle background notifications
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Opened app from background: ${message.notification?.title}');
      // Handle your logic to navigate to a specific screen if needed
    });

    // Handle notifications when the app is completely terminated
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  // Request notification permissions on iOS
  Future<void> requestPermission() async {
    if (Platform.isIOS) {
      NotificationSettings settings =
          await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('User granted notification permissions');
      } else {
        print('User denied notification permissions');
      }
    }
  }

  // Show the notification when app is in the foreground
  Future<void> _showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'default_channel_id',
      'Default Channel',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
    );
    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title,
      message.notification?.body,
      platformDetails,
      payload: message.data.toString(),
    );
  }

  // Handle background messages
  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print("Handling a background message: ${message.notification?.title}");
    // You can process background messages here and update your app accordingly
  }

  // Navigate to a specific screen based on the notification payload
  Future<void> navigateToScreen(
      BuildContext context, Map<String, dynamic> data) async {
    // You can navigate to a specific screen using the payload (e.g., "chat_screen")
    String screen = data['screen'] ?? '';
    if (screen == 'chat_screen') {
      // Navigate to chat screen or any other screen
      Navigator.pushNamed(context, '/chat');
    }
  }

  // Subscribe to a topic (useful for sending notifications to specific groups)
  Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
    print('Subscribed to topic: $topic');
  }

  // Unsubscribe from a topic
  Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
    print('Unsubscribed from topic: $topic');
  }

  // Send a test notification
  Future<void> sendTestNotification(String token) async {
    await _firebaseMessaging.subscribeToTopic('test');
    print("Notification sent to topic: test");
  }
}
