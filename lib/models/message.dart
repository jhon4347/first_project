import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String id; // Unique identifier for the message
  final String senderId; // ID of the sender
  final String receiverId; // ID of the receiver
  final String content; // Message content (text, image URL, etc.)
  final DateTime timestamp; // The timestamp when the message was sent
  final MessageType messageType; // Type of message (text, image, video, etc.)
  final bool isRead; // Flag to indicate if the message has been read

  // Constructor for creating a new Message object
  Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.timestamp,
    required this.messageType,
    this.isRead = false, // Default is false (message is unread)
  });

  // Factory method to create a Message from a Map (for Firebase data retrieval)
  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'] ?? '',
      senderId: map['senderId'] ?? '',
      receiverId: map['receiverId'] ?? '',
      content: map['content'] ?? '',
      timestamp: map['timestamp'] != null
          ? (map['timestamp'] as Timestamp).toDate()
          : DateTime.now(),
      messageType:
          MessageType.values[map['messageType'] ?? 0], // Default to text
      isRead: map['isRead'] ?? false,
    );
  }

  // Method to convert Message object to a Map (for Firebase storage)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
      'timestamp': timestamp,
      'messageType': messageType.index,
      'isRead': isRead,
    };
  }
}

// Enum to define the message types
enum MessageType {
  text, // Text messages
  image, // Image messages
  video, // Video messages
  file, // File messages (e.g., PDFs, Documents)
  location, // Location sharing
}
