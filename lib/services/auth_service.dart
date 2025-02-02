import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  // Extend ChangeNotifier
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream to listen for authentication state changes
  Stream<User?> get user => _auth.authStateChanges();

  String? get languageCode => null;

  bool get isAuthenticated =>
      _auth.currentUser !=
      null; // Updated to return true/false based on current user

  // Register a new user with email and password
  Future<User?> registerWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      notifyListeners(); // Notify listeners after state change
      return userCredential.user;
    } catch (e) {
      debugPrint("Error registering user: $e");
      rethrow;
    }
  }

  // Login user with email and password
  Future<User?> loginWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      notifyListeners(); // Notify listeners after state change
      return userCredential.user;
    } catch (e) {
      debugPrint("Error logging in: $e");
      rethrow;
    }
  }

  // Log out the current user
  Future<void> logout() async {
    try {
      await _auth.signOut();
      notifyListeners(); // Notify listeners after state change
    } catch (e) {
      debugPrint("Error logging out: $e");
      rethrow;
    }
  }

  // Get the current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Update user display name (or any other user info)
  Future<void> updateUserProfile(String displayName) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.updateDisplayName(displayName);
        await user.reload();
        notifyListeners(); // Notify listeners after state change
      }
    } catch (e) {
      debugPrint("Error updating user profile: $e");
      rethrow;
    }
  }

  // Send a password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      debugPrint("Error sending password reset email: $e");
      rethrow;
    }
  }

  // Delete the user account
  Future<void> deleteUserAccount() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.delete();
        notifyListeners(); // Notify listeners after state change
      }
    } catch (e) {
      debugPrint("Error deleting user account: $e");
      rethrow;
    }
  }
}
