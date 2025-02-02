class AppConstants {
  // Firebase Collection Names
  static const String usersCollection = 'users';
  static const String messagesCollection = 'messages';
  static const String statusCollection = 'status';

  // Firestore Field Names
  static const String fieldUserId = 'userId';
  static const String fieldUserName = 'userName';
  static const String fieldUserEmail = 'userEmail';
  static const String fieldUserPhone = 'userPhone';
  static const String fieldUserProfilePic = 'profilePic';
  static const String fieldUserStatus = 'status';
  static const String fieldLastMessage = 'lastMessage';
  static const String fieldTimestamp = 'timestamp';
  static const String fieldMessageContent = 'messageContent';
  static const String fieldMessageType = 'messageType';
  static const String fieldMessageStatus = 'messageStatus';
  static const String fieldSenderId = 'senderId';

  // App theme and UI Constants
  static const String appTitle = 'Flutter Chat App';
  static const double defaultPadding = 16.0;
  static const double avatarRadius = 30.0;

  // Date and Time Formats
  static const String dateFormat = 'yyyy-MM-dd';
  static const String timeFormat = 'HH:mm';

  // Notification Channel ID and Name for Push Notifications
  static const String notificationChannelId = 'default_channel';
  static const String notificationChannelName = 'Default Channel';
  static const String notificationChannelDescription =
      'Channel for general notifications';

  // App Locale / Language Constants
  static const String enLocale = 'en';
  static const String esLocale = 'es';
  static const String frLocale = 'fr';

  // Firebase Cloud Messaging (FCM) Topics
  static const String generalTopic = 'general';
  static const String chatTopic = 'chat';

  // App Theme Constants
  static const String lightTheme = 'Light';
  static const String darkTheme = 'Dark';

  // User Status Constants
  static const String statusOnline = 'Online';
  static const String statusOffline = 'Offline';
  static const String statusBusy = 'Busy';
  static const String statusAway = 'Away';

  // Message Types
  static const String messageText = 'text';
  static const String messageImage = 'image';
  static const String messageVideo = 'video';
  static const String messageLocation = 'location';
  static const String messageVoice = 'voice';

  // Message Status
  static const String messageSent = 'sent';
  static const String messageDelivered = 'delivered';
  static const String messageRead = 'read';
  static const String messageFailed = 'failed';

  // Error Messages
  static const String errorNetwork = 'Network error, please try again later';
  static const String errorSomethingWentWrong = 'Something went wrong';
  static const String errorInvalidCredentials = 'Invalid credentials';
  static const String errorUserNotFound = 'User not found';

  // Success Messages
  static const String successMessageSent = 'Message sent successfully';
  static const String successProfileUpdated = 'Profile updated successfully';
  static const String successStatusUpdated = 'Status updated successfully';

  // Other Constants
  static const String appStoreLink =
      'https://play.google.com/store/apps/details?id=com.example.chat_app';
  static const String appVersion = '1.0.0';
  static const String privacyPolicyUrl = 'https://www.example.com/privacy';
  static const String termsOfServiceUrl = 'https://www.example.com/terms';
}
