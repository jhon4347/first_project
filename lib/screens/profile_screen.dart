import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  User? _user;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  // Get the current user
  Future<void> _getUser() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (userDoc.exists) {
      if (!mounted) return;
      setState(() {
        _nameController.text = userDoc['name'] ?? '';
        _statusController.text = userDoc['status'] ?? '';
      });
    }
  }

  // Update user profile
  Future<void> _updateProfile() async {
    if (_user == null) return;

    setState(() => _isUpdating = true);

    await FirebaseFirestore.instance.collection('users').doc(_user!.uid).set({
      'name': _nameController.text,
      'status': _statusController.text,
    }, SetOptions(merge: true));

    if (!mounted) return;
    setState(() => _isUpdating = false);
  }

  // Sign out user safely
  Future<void> _signOut() async {
    await _auth.signOut();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: _signOut,
          ),
        ],
      ),
      body: _user == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Name', style: TextStyle(fontSize: 16)),
                  TextField(
                    controller: _nameController,
                    decoration:
                        const InputDecoration(hintText: 'Enter your name'),
                  ),
                  const SizedBox(height: 16),
                  const Text('Status', style: TextStyle(fontSize: 16)),
                  TextField(
                    controller: _statusController,
                    decoration:
                        const InputDecoration(hintText: 'Enter your status'),
                  ),
                  const SizedBox(height: 24),
                  _isUpdating
                      ? const Center(child: CircularProgressIndicator())
                      : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _updateProfile,
                            child: const Text('Update Profile'),
                          ),
                        ),
                ],
              ),
            ),
    );
  }
}
