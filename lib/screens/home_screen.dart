import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chat_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  late Stream<QuerySnapshot> _chatStream;

  @override
  void initState() {
    super.initState();
    _getUser();
    _chatStream = FirebaseFirestore.instance
        .collection('chats')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // Get the current user and update UI safely
  Future<void> _getUser() async {
    final user = _auth.currentUser;
    if (!mounted) return; // Ensure widget is still in the tree
    setState(() {
      _user = user;
    });
  }

  // Sign out user safely
  Future<void> _signOut() async {
    await _auth.signOut();
    if (!mounted) return; // Prevent navigation errors if widget is disposed
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: _signOut,
          ),
        ],
      ),
      body: _user == null
          ? const Center(child: CircularProgressIndicator())
          : StreamBuilder<QuerySnapshot>(
              stream: _chatStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                var chatDocs = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: chatDocs.length,
                  itemBuilder: (ctx, index) {
                    var chat = chatDocs[index];
                    return ListTile(
                      leading: const Icon(Icons.chat),
                      title: Text(chat['name'] ?? 'Unknown'),
                      subtitle: Text(chat['last_message'] ?? 'No messages'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => ChatScreen(chatId: chat.id),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
    );
  }
}
