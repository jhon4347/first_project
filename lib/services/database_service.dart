import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_project/models/message.dart';
import 'package:first_project/models/status.dart';
import 'package:first_project/models/user.dart';
import 'package:flutter/material.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Get the current user document from Firestore
  Future<DocumentSnapshot<Map<String, dynamic>>> getUser(String userId) async {
    try {
      return await _db.collection('users').doc(userId).get();
    } catch (e) {
      debugPrint("Error fetching user: $e");
      rethrow;
    }
  }

  // Add or update a user document in Firestore
  Future<void> setUser(User user) async {
    try {
      await _db
          .collection('users')
          .doc(user.id)
          .set(user.toMap(), SetOptions(merge: true));
    } catch (e) {
      debugPrint("Error setting user: $e");
      rethrow;
    }
  }

  // Get all messages in a specific chat
  Stream<List<Message>> getMessages(String chatId) {
    return _db
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Message.fromMap(doc.data())).toList();
    });
  }

  // Add a new message to a specific chat
  Future<void> addMessage(String chatId, Message message) async {
    try {
      await _db
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .add(message.toMap());
    } catch (e) {
      debugPrint("Error adding message: $e");
      rethrow;
    }
  }

  // Get the status of a user
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserStatus(
      String userId) async {
    try {
      return await _db.collection('statuses').doc(userId).get();
    } catch (e) {
      debugPrint("Error fetching user status: $e");
      rethrow;
    }
  }

  // Update or add a user's status
  Future<void> setUserStatus(Status status) async {
    try {
      await _db
          .collection('statuses')
          .doc(status.userId)
          .set(status.toMap(), SetOptions(merge: true));
    } catch (e) {
      debugPrint("Error setting user status: $e");
      rethrow;
    }
  }

  // Get the list of users in the system (for example, for user search)
  Future<List<User>> getUsers() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await _db.collection('users').get();
      return snapshot.docs.map((doc) => User.fromMap(doc.data())).toList();
    } catch (e) {
      debugPrint("Error fetching users: $e");
      rethrow;
    }
  }

  // Delete a message from Firestore
  Future<void> deleteMessage(String chatId, String messageId) async {
    try {
      await _db
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc(messageId)
          .delete();
    } catch (e) {
      debugPrint("Error deleting message: $e");
      rethrow;
    }
  }

  // Get all user statuses (for the status screen)
  Stream<List<Status>> getStatuses() {
    return _db.collection('statuses').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Status.fromMap(doc.data())).toList();
    });
  }

  // Delete a user document from Firestore
  Future<void> deleteUser(String userId) async {
    try {
      await _db.collection('users').doc(userId).delete();
    } catch (e) {
      debugPrint("Error deleting user: $e");
      rethrow;
    }
  }

  // Listen for updates on a specific chat's status (for example, typing indicator)
  Stream<DocumentSnapshot<Map<String, dynamic>>> getChatStatus(String chatId) {
    return _db.collection('chats').doc(chatId).snapshots();
  }
}
