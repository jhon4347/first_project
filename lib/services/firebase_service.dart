import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:first_project/models/message.dart';
import 'package:first_project/models/status.dart';
import 'package:first_project/models/user.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class FirebaseService {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Singleton pattern to access FirebaseService throughout the app
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  // Firebase user authentication
  auth.User? get currentUser => _auth.currentUser;

  // Sign up with email and password
  Future<auth.User?> signUp(
      {required String email, required String password}) async {
    try {
      final auth.UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user != null) {
        return user;
      }
      return null;
    } catch (e) {
      debugPrint('Error signing up: $e');
      return null;
    }
  }

  // Sign in with email and password
  Future<auth.User?> signIn(
      {required String email, required String password}) async {
    try {
      final auth.UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user != null) {
        return user;
      }
      return null;
    } catch (e) {
      debugPrint('Error signing in: $e');
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Create or update user profile
  Future<void> createUserProfile(User user) async {
    try {
      await _firestore.collection('users').doc(user.id).set(user.toMap());
    } catch (e) {
      debugPrint('Error creating user profile: $e');
    }
  }

  // Retrieve user data
  Future<User?> getUserData(String userId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return User.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      debugPrint('Error retrieving user data: $e');
      return null;
    }
  }

  // Send a message
  Future<void> sendMessage(Message message) async {
    try {
      await _firestore.collection('messages').add(message.toMap());
    } catch (e) {
      debugPrint('Error sending message: $e');
    }
  }

  // Get messages between two users
  Future<List<Message>> getMessages(String senderId, String receiverId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('messages')
          .where('senderId', isEqualTo: senderId)
          .where('receiverId', isEqualTo: receiverId)
          .orderBy('timestamp')
          .get();
      return snapshot.docs
          .map((doc) => Message.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Error retrieving messages: $e');
      return [];
    }
  }

  // Upload media (images, videos, etc.)
  Future<String?> uploadMedia(String filePath) async {
    try {
      File file = File(filePath);
      String fileName = Uuid().v4();
      UploadTask uploadTask =
          _storage.ref().child('media/$fileName').putFile(file);

      TaskSnapshot taskSnapshot = await uploadTask;
      String mediaUrl = await taskSnapshot.ref.getDownloadURL();
      return mediaUrl;
    } catch (e) {
      debugPrint('Error uploading media: $e');
      return null;
    }
  }

  // Set status
  Future<void> setStatus(Status status) async {
    try {
      await _firestore
          .collection('statuses')
          .doc(status.id)
          .set(status.toMap());
    } catch (e) {
      debugPrint('Error setting status: $e');
    }
  }

  // Retrieve user statuses
  Future<List<Status>> getStatuses(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('statuses')
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .get();
      return snapshot.docs
          .map((doc) => Status.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Error retrieving statuses: $e');
      return [];
    }
  }

  // Listen for real-time updates on messages
  Stream<List<Message>> getMessagesStream(String senderId, String receiverId) {
    return _firestore
        .collection('messages')
        .where('senderId', isEqualTo: senderId)
        .where('receiverId', isEqualTo: receiverId)
        .orderBy('timestamp')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Message.fromMap(doc.data())).toList();
    });
  }

  // Listen for real-time updates on statuses
  Stream<List<Status>> getStatusesStream(String userId) {
    return _firestore
        .collection('statuses')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Status.fromMap(doc.data())).toList();
    });
  }
}
