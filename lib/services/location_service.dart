import 'package:geocoding/geocoding.dart'; // Geocoding package for geocoding and reverse geocoding
import 'package:geolocator/geolocator.dart'; // Geolocator package for location services
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationService {
  // Request permission for accessing location
  Future<bool> requestPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return false;
    }
    return true;
  }

  // Check if location services are enabled
  Future<bool> checkLocationService() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    return serviceEnabled;
  }

  // Get the current position (latitude and longitude)
  Future<Position?> getCurrentLocation() async {
    bool serviceEnabled = await checkLocationService();
    if (!serviceEnabled) {
      // If location services are not enabled
      return null;
    }

    bool permissionGranted = await requestPermission();
    if (!permissionGranted) {
      // If location permission is not granted
      return null;
    }

    // Get the user's current position
    return await Geolocator.getCurrentPosition(
      // ignore: deprecated_member_use
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  // Convert latitude and longitude into a readable address (reverse geocoding)
  Future<String?> getAddressFromCoordinates(
      double latitude, double longitude) async {
    try {
      // Use the geocoding package's method
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        return '${placemark.name}, ${placemark.locality}, ${placemark.country}';
      }
      return null;
    } catch (e) {
      debugPrint('Error getting address: $e');
      return null;
    }
  }

  // Convert an address into latitude and longitude (geocoding)
  Future<LatLng?> getCoordinatesFromAddress(String address) async {
    try {
      // Use the geocoding package's method
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        return LatLng(locations.first.latitude, locations.first.longitude);
      }
      return null;
    } catch (e) {
      debugPrint('Error getting coordinates: $e');
      return null;
    }
  }

  // Share location with other users by sending the latitude and longitude
  Future<void> shareLocation(LatLng location) async {
    // In a real application, you could send the location to a Firebase database or chat system
    debugPrint('Shared location: ${location.latitude}, ${location.longitude}');
  }

  // Get a Google Maps URL for the location
  String getGoogleMapsLink(LatLng location) {
    return 'https://www.google.com/maps?q=${location.latitude},${location.longitude}';
  }

  // Display location on Google Maps (using Google Maps Flutter)
  Widget displayLocationOnMap(LatLng location) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: location,
        zoom: 14.0,
      ),
      markers: {
        Marker(
          markerId: MarkerId('user_location'),
          position: location,
          infoWindow: InfoWindow(title: 'Your Location'),
        ),
      },
    );
  }
}
