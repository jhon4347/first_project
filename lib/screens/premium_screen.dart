import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  bool _isPremium = false;

  @override
  void initState() {
    super.initState();
    _getUserStatus();
  }

  // Get the user's premium status from Firestore
  Future<void> _getUserStatus() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (userDoc.exists) {
      if (!mounted) return;
      setState(() {
        _isPremium = userDoc['isPremium'] ?? false;
      });
    }
  }

  // Upgrade to premium
  Future<void> _upgradeToPremium() async {
    if (_user == null) return;

    await FirebaseFirestore.instance.collection('users').doc(_user!.uid).set({
      'isPremium': true,
    }, SetOptions(merge: true));

    if (!mounted) return;
    setState(() {
      _isPremium = true;
    });

    // Add further logic for premium subscription (e.g., payment handling)
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
        title: const Text('Premium Features'),
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
                  Text(
                    _isPremium
                        ? 'You have a Premium account!'
                        : 'You are not a Premium user.',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  _isPremium
                      ? Column(
                          children: [
                            const Text(
                              'Enjoy the exclusive premium features!',
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, '/exclusive-feature');
                              },
                              child: const Text('Access Premium Features'),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            const Text(
                              'Upgrade to premium to unlock more features.',
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: _upgradeToPremium,
                              child: const Text('Upgrade to Premium'),
                            ),
                          ],
                        ),
                ],
              ),
            ),
    );
  }
}
