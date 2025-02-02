import 'package:flutter/material.dart';

class MessageWidget extends StatelessWidget {
  final String message;
  final String senderName;
  final bool isSentByCurrentUser;
  final DateTime timestamp;
  final bool isRead;

  const MessageWidget({
    super.key,
    required this.message,
    required this.senderName,
    required this.isSentByCurrentUser,
    required this.timestamp,
    required this.isRead,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Align(
        alignment:
            isSentByCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: isSentByCurrentUser
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            // Sender's name (optional)
            if (!isSentByCurrentUser)
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  senderName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
              ),

            // Message bubble
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              decoration: BoxDecoration(
                color:
                    isSentByCurrentUser ? Colors.blueAccent : Colors.grey[200],
                borderRadius: BorderRadius.circular(15),
              ),
              constraints: BoxConstraints(maxWidth: 250),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message,
                    style: TextStyle(
                      color:
                          isSentByCurrentUser ? Colors.white : Colors.black87,
                    ),
                  ),
                  // Message status indicator (read, delivered, etc.)
                  if (isSentByCurrentUser)
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                            isRead ? Icons.done_all : Icons.done,
                            size: 16,
                            color: isRead ? Colors.green : Colors.grey,
                          ),
                          SizedBox(width: 5),
                          Text(
                            '${timestamp.hour}:${timestamp.minute}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
