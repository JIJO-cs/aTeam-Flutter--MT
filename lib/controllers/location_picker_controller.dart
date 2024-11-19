

import 'dart:convert';
import 'dart:math';
import 'package:ateam/constants/app_constants.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:http/http.dart' as http;

class LocationPickerController extends GetxController {
  late MapboxMapController mapController;

  var selectedLocation = Rx<LatLng?>(null);
  RxString selectedLocationName = "Select a location".obs;

  final String mapboxAccessToken = AppConstants.mapboxSecretKey;

  // Fetch location suggestions using Mapbox Geocoding API
  Future<List<Map<String, dynamic>>> searchLocations(String query) async {
    final url =
        "https://api.mapbox.com/geocoding/v5/mapbox.places/$query.json?access_token=$mapboxAccessToken";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['features'] as List).map((e) {
        return {
          "name": e['place_name'],
          "coordinates": LatLng(
            e['geometry']['coordinates'][1],
            e['geometry']['coordinates'][0],
          ),
        };
      }).toList();
    } else {
      throw Exception("Failed to fetch locations");
    }
  }

  // Initialize the Mapbox map controller
  void onMapCreated(MapboxMapController controller) {
    mapController = controller;
  }

  // Handle map tap to select a location and fetch the place name
  void onMapTapped(Point<double> point, LatLng coordinates) async {
    selectedLocation.value = coordinates;
    selectedLocationName.value = "Fetching location name...";
    selectedLocationName.value = await fetchLocationName(coordinates);
  }

  // Fetch the location name using Mapbox Geocoding API
  Future<String> fetchLocationName(LatLng location) async {
    final url =
        "https://api.mapbox.com/geocoding/v5/mapbox.places/${location.longitude},${location.latitude}.json?access_token=$mapboxAccessToken";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['features'].isNotEmpty) {
          return data['features'][0]['place_name']; // Most relevant place name
        } else {
          return "Unknown location";
        }
      } else {
        return "Error fetching location";
      }
    } catch (e) {
      return "Error: $e";
    }
  }

  // Add a custom pin at the given location
  Future<void> addCustomPin(LatLng location) async {
    await mapController.addImage(
      'custom-pin', // Unique key for this icon
      await _loadAssetImage('assets/custom_pin.png'),
    );
    mapController.addSymbol(
      SymbolOptions(
        geometry: location,
        iconImage: 'custom-pin',
        iconSize: 0.2, // Adjust size as needed
      ),
    );
  }

  Future<Uint8List> _loadAssetImage(String assetPath) async {
    final byteData = await rootBundle.load(assetPath);
    return byteData.buffer.asUint8List();
  }

  // Move the map to the given location, add a pin, and fetch the place name
  void moveToLocation(LatLng location) async {
    mapController.animateCamera(CameraUpdate.newLatLng(location));
    selectedLocation.value = location;
    selectedLocationName.value = "Fetching location name...";
    selectedLocationName.value = await fetchLocationName(location);
    addCustomPin(location);
  }
}
