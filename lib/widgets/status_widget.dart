import 'package:flutter/material.dart';

class StatusWidget extends StatelessWidget {
  final String status; // User's status (e.g., "Online", "Offline", "Typing...")
  final bool isOnline; // Indicates if the user is online or not

  const StatusWidget({
    super.key,
    required this.status,
    required this.isOnline,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
      child: Row(
        children: [
          // Status circle (green for online, grey for offline)
          Container(
            width: 10.0,
            height: 10.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isOnline ? Colors.green : Colors.grey,
            ),
          ),
          SizedBox(width: 10),
          // Status text
          Text(
            status,
            style: TextStyle(
              fontSize: 14.0,
              color: isOnline ? Colors.green : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
