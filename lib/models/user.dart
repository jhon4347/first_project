import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id; // Unique identifier for the user (uid from Firebase)
  final String name; // User's full name
  final String email; // User's email address
  final String
      status; // User's current status (e.g., "Online", "Offline", "Busy")
  final String profilePicture; // URL or path to the user's profile picture
  final DateTime
      lastActive; // The last time the user was active (for presence detection)

  // Constructor for creating a new User object
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.status,
    required this.profilePicture,
    required this.lastActive,
  });

  // Factory method to create a User from a Map (for Firebase data retrieval)
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ??
          map['uid'] ??
          '', // Prefer 'uid' if present (from Firebase)
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      status: map['status'] ?? 'Offline',
      profilePicture: map['profilePicture'] ??
          '', // Default empty string if no profile picture
      lastActive: map['lastActive'] != null
          ? (map['lastActive'] as Timestamp).toDate()
          : DateTime
              .now(), // If 'lastActive' is null, set it to the current time
    );
  }

  // Method to convert User object to a Map (for Firebase storage)
  Map<String, dynamic> toMap() {
    return {
      'id': id, // Make sure to store 'id' or 'uid' in Firebase
      'name': name,
      'email': email,
      'status': status,
      'profilePicture': profilePicture,
      'lastActive': lastActive,
    };
  }
}
