import 'package:intl/intl.dart';

class DateTimeHelper {
  // Formats a DateTime object to a readable string format
  static String formatDateTime(DateTime dateTime,
      {String format = 'yyyy-MM-dd HH:mm:ss'}) {
    final DateFormat dateFormat = DateFormat(format);
    return dateFormat.format(dateTime);
  }

  // Converts a DateTime object to a string representing just the date (e.g., 2025-01-31)
  static String formatDate(DateTime dateTime, {String format = 'yyyy-MM-dd'}) {
    final DateFormat dateFormat = DateFormat(format);
    return dateFormat.format(dateTime);
  }

  // Converts a DateTime object to a string representing just the time (e.g., 14:30:00)
  static String formatTime(DateTime dateTime, {String format = 'HH:mm:ss'}) {
    final DateFormat timeFormat = DateFormat(format);
    return timeFormat.format(dateTime);
  }

  // Parses a date string into a DateTime object
  static DateTime parseDate(String dateString, {String format = 'yyyy-MM-dd'}) {
    final DateFormat dateFormat = DateFormat(format);
    return dateFormat.parse(dateString);
  }

  // Gets the current date and time
  static String getCurrentDateTime({String format = 'yyyy-MM-dd HH:mm:ss'}) {
    final DateTime now = DateTime.now();
    return formatDateTime(now, format: format);
  }

  // Gets the current date in a specified format
  static String getCurrentDate({String format = 'yyyy-MM-dd'}) {
    final DateTime now = DateTime.now();
    return formatDate(now, format: format);
  }

  // Gets the current time in a specified format
  static String getCurrentTime({String format = 'HH:mm:ss'}) {
    final DateTime now = DateTime.now();
    return formatTime(now, format: format);
  }

  // Converts a timestamp (milliseconds since epoch) to a readable date string
  static String formatTimestamp(int timestamp,
      {String format = 'yyyy-MM-dd HH:mm:ss'}) {
    final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return formatDateTime(dateTime, format: format);
  }

  // Get the difference between two DateTime objects in a human-readable format
  static String getDifference(DateTime startDateTime, DateTime endDateTime) {
    final Duration difference = endDateTime.difference(startDateTime);
    int days = difference.inDays;
    int hours = difference.inHours % 24;
    int minutes = difference.inMinutes % 60;
    int seconds = difference.inSeconds % 60;

    String result = '';
    if (days > 0) result += '$days days ';
    if (hours > 0) result += '$hours hours ';
    if (minutes > 0) result += '$minutes minutes ';
    if (seconds > 0) result += '$seconds seconds';

    return result.isEmpty ? '0 seconds' : result.trim();
  }

  // Converts a DateTime object to a relative time format (e.g., "3 minutes ago", "2 days ago")
  static String getRelativeTime(DateTime dateTime) {
    final Duration difference = DateTime.now().difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inSeconds > 0) {
      return '${difference.inSeconds} seconds ago';
    } else {
      return 'just now';
    }
  }
}
