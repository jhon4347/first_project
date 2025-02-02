import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  const ChatScreen({super.key, required this.chatId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _controller = TextEditingController();
  late Stream<QuerySnapshot> _messagesStream;
  User? _user;

  @override
  void initState() {
    super.initState();
    _getUser();
    _messagesStream = FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> _getUser() async {
    final user = _auth.currentUser;
    if (!mounted) return; // Ensure widget is still in the tree
    setState(() {
      _user = user;
    });
  }

  Future<void> _sendMessage() async {
    if (_controller.text.trim().isNotEmpty && _user != null) {
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.chatId)
          .collection('messages')
          .add({
        'text': _controller.text.trim(),
        'senderId': _user!.uid,
        'timestamp': FieldValue.serverTimestamp(),
      });

      if (!mounted) return; // Ensure widget is still in the tree
      _controller.clear();
      setState(() {}); // Safely update UI
    }
  }

  Future<void> _signOut() async {
    await _auth.signOut();
    if (!mounted) return; // Ensure widget is still active
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: _signOut,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _messagesStream,
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No messages yet"));
                }

                var messageDocs = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  itemCount: messageDocs.length,
                  itemBuilder: (ctx, index) {
                    var message = messageDocs[index];
                    return ListTile(
                      title: Text(message['text']),
                      subtitle: Text('Sent by: ${message['senderId']}'),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration:
                        const InputDecoration(labelText: 'Send a message'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
