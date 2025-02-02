import 'package:cloud_firestore/cloud_firestore.dart';

class Status {
  final String id; // Unique identifier for the status update
  final String userId; // ID of the user who created the status
  final String content; // The content of the status (e.g., "At the gym")
  final DateTime timestamp; // The timestamp when the status was posted
  final StatusType statusType; // Type of the status (text, image, video)
  final String? mediaUrl; // URL of the media (if status contains media)
  final bool isActive; // Flag to indicate if the status is active or expired

  // Constructor for creating a new Status object
  Status({
    required this.id,
    required this.userId,
    required this.content,
    required this.timestamp,
    required this.statusType,
    this.mediaUrl,
    this.isActive = true, // Default is true (active)
  });

  // Factory method to create a Status from a Map (for Firebase data retrieval)
  factory Status.fromMap(Map<String, dynamic> map) {
    return Status(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      content: map['content'] ?? '',
      timestamp: map['timestamp'] != null
          ? (map['timestamp'] as Timestamp).toDate()
          : DateTime.now(),
      statusType: StatusType.values[map['statusType'] ?? 0], // Default to text
      mediaUrl: map['mediaUrl'],
      isActive: map['isActive'] ?? true,
    );
  }

  // Method to convert Status object to a Map (for Firebase storage)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'content': content,
      'timestamp': timestamp,
      'statusType': statusType.index,
      'mediaUrl': mediaUrl,
      'isActive': isActive,
    };
  }
}

// Enum to define the type of status (text, image, video)
enum StatusType {
  text, // Text-based status
  image, // Image-based status
  video, // Video-based status
}
