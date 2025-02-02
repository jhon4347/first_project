import 'package:permission_handler/permission_handler.dart';

class PermissionsService {
  // Helper method to request a single permission
  static Future<bool> _requestPermission(Permission permission) async {
    final status = await permission.request();
    return status.isGranted;
  }

  // Check and request camera permission
  static Future<bool> requestCameraPermission() async {
    return await _requestPermission(Permission.camera);
  }

  // Check and request microphone permission
  static Future<bool> requestMicrophonePermission() async {
    return await _requestPermission(Permission.microphone);
  }

  // Check and request storage permission (for accessing images, videos)
  static Future<bool> requestStoragePermission() async {
    return await _requestPermission(Permission.storage);
  }

  // Check and request location permission (for sharing location)
  static Future<bool> requestLocationPermission() async {
    return await _requestPermission(Permission.location);
  }

  // Check and request notification permission
  static Future<bool> requestNotificationPermission() async {
    return await _requestPermission(Permission.notification);
  }

  // Check and request phone state permission (for handling calls)
  static Future<bool> requestPhoneStatePermission() async {
    return await _requestPermission(Permission.phone);
  }

  // Check if all necessary permissions are granted
  static Future<bool> arePermissionsGranted() async {
    final permissions = [
      Permission.camera,
      Permission.microphone,
      Permission.storage,
      Permission.location,
      Permission.notification,
      Permission.phone,
    ];

    // Wait for all permission status checks to complete
    final statuses = await Future.wait(
        permissions.map((permission) => permission.isGranted));

    return statuses.every((status) => status); // Check if all are granted
  }

  // Request all permissions at once
  static Future<bool> requestAllPermissions() async {
    final permissions = [
      Permission.camera,
      Permission.microphone,
      Permission.storage,
      Permission.location,
      Permission.notification,
      Permission.phone,
    ];

    // Request all permissions and check if all are granted
    final statuses = await Future.wait(
        permissions.map((permission) => permission.request()));
    return statuses.every((status) => status.isGranted);
  }

  // Open app settings if permissions are denied
  static Future<void> openAppSettings() async {
    await openAppSettings(); // This method is already defined in permission_handler
  }
}
