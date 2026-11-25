import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  /// Ask for permission and location services
  static Future<bool> requestPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    /// Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    /// Check permission status
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  static Future<bool> checkPermission() async {
    bool serviceEnabled;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }
    LocationPermission permission = await Geolocator.checkPermission();
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  static Future<Position?> getCurrentLocation() async {
    try {
      final hasPermission = await requestPermission();
      if (!hasPermission) {
        log("Location permission not granted", name: "LocationService");
        return null;
      }

      log("Getting current position...", name: "LocationService");
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          distanceFilter: 100,
        ),
      ).timeout(const Duration(seconds: 5));
    } catch (e) {
      log("Error getting location: $e. Falling back to getLastKnownPosition()",
          name: "LocationService");
      try {
        return await Geolocator.getLastKnownPosition();
      } catch (e2) {
        log("Error getting last known location: $e2", name: "LocationService");
        return null;
      }
    }
  }

  static Future<Position?> getCurrentLocationwithoutAskPermision() async {
    try {
      final hasPermission = await checkPermission();
      if (!hasPermission) {
        log("Location permission not granted", name: "LocationService");
        return null;
      }

      log("Getting current position...", name: "LocationService");
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          distanceFilter: 100,
        ),
      ).timeout(const Duration(seconds: 3));
    } catch (e) {
      log("Error getting location: $e. Falling back to getLastKnownPosition()",
          name: "LocationService");
      try {
        return await Geolocator.getLastKnownPosition();
      } catch (e2) {
        log("Error getting last known location: $e2", name: "LocationService");
        return null;
      }
    }
  }

  static const String apiKey = "AIzaSyDIKS4q1KAy8ihwmtjMbBpEc-c7M2RxmNg";

  /// Returns: {"name": formatted address, "lat": double, "lng": double}
  static Future<List<GooglePlace>> locationFromAddress(String input) async {
    final url =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=${Uri.encodeComponent(input)}&types=(cities)&key=$apiKey";

    final response = await Dio().get(url);

    if (response.statusCode == 200) {
      final data = response.data;
      log(data.toString(), name: "LocationService");
      log((data["predictions"] is List).toString(), name: "checkList");
      log((data["status"] == "OK").toString(), name: "checkStatus");
      if (data["status"] == "OK" && data["predictions"] is List) {
        var result = (data["predictions"] as List)
            .map((p) => GooglePlace.fromAutocomplete(p))
            .toList();
        log(result.length.toString(), name: "LocationSlenth");
        return result;
      }
    }
    return [];
  }

  static Future<GooglePlace?> getPlaceDetails(String placeId) async {
    final url =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey";

    final response = await Dio().get(url);

    if (response.statusCode == 200) {
      final data = response.data;
      if (data["status"] == "OK") {
        return GooglePlace.fromDetails(data["result"]);
      }
    }
    return null;
  }
}

class GooglePlace {
  final String name;
  final String placeId;
  final double lat;
  final double lng;

  GooglePlace({
    required this.name,
    required this.lat,
    required this.lng,
    required this.placeId,
  });

  factory GooglePlace.fromJson(Map<String, dynamic> json) {
    final location = json["geometry"]["location"];
    return GooglePlace(
      name: json["formatted_address"],
      lat: location["lat"],
      lng: location["lng"],
      placeId: json["place_id"] ?? '',
    );
  }

  factory GooglePlace.fromAutocomplete(Map<String, dynamic> json) {
    return GooglePlace(
      name: json["description"],
      placeId: json["place_id"] ?? '', // store place_id for later
      lat: json["geometry"]?["location"]?["lat"] ?? 0,
      lng: json["geometry"]?["location"]?["lng"] ?? 0,
    );
  }
  factory GooglePlace.fromDetails(Map<String, dynamic> json) {
    final location = json["geometry"]["location"];
    return GooglePlace(
      name: json["formatted_address"],
      placeId: json["place_id"],
      lat: location["lat"],
      lng: location["lng"],
    );
  }

  @override
  String toString() => "GooglePlace(name: $name, lat: $lat, lng: $lng)";
}
