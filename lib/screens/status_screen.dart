import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({super.key});

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _statusController = TextEditingController();
  User? _user;
  late Stream<QuerySnapshot> _statusStream;

  @override
  void initState() {
    super.initState();
    _getUser();
    _statusStream = FirebaseFirestore.instance.collection('users').snapshots();
  }

  // Get the current user
  Future<void> _getUser() async {
    User? user = _auth.currentUser;
    if (mounted) {
      setState(() {
        _user = user;
      });
    }
  }

  // Update user status
  Future<void> _updateStatus() async {
    if (_statusController.text.trim().isNotEmpty && _user != null) {
      await FirebaseFirestore.instance.collection('users').doc(_user!.uid).set({
        'status': _statusController.text,
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      if (mounted) {
        setState(() {
          _statusController.clear();
        });
      }
    }
  }

  @override
  void dispose() {
    _statusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Status'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              await _auth.signOut();
              if (mounted) {
                if (context.mounted) {
                  Navigator.pushReplacementNamed(context, '/login');
                }
              }
            },
          ),
        ],
      ),
      body: _user == null
          ? const Center(child: Text("Please log in to update your status"))
          : Column(
              children: [
                // Current user's status section
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const Text('Your Status',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      TextField(
                        controller: _statusController,
                        decoration: const InputDecoration(
                          hintText: 'Update your status',
                          border: OutlineInputBorder(),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.save),
                        label: const Text("Update"),
                        onPressed: _updateStatus,
                      ),
                    ],
                  ),
                ),
                const Divider(),
                // List of users and their statuses
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _statusStream,
                    builder: (ctx, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      var userDocs = snapshot.data!.docs;
                      return ListView.builder(
                        itemCount: userDocs.length,
                        itemBuilder: (ctx, index) {
                          var user = userDocs[index];
                          return ListTile(
                            leading: const Icon(Icons.person),
                            title: Text(user['name'] ?? 'Unknown',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            subtitle:
                                Text(user['status'] ?? 'No status available'),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
