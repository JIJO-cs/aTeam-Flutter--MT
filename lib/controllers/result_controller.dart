import 'dart:convert';
import 'package:ateam/constants/app_constants.dart';
import 'package:ateam/routes.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class ResultsScreenController extends GetxController {
  Rx<LatLng?> startLocation = Rx<LatLng?>(null);
  Rx<LatLng?> endLocation = Rx<LatLng?>(null);
  Rx<String> startLocationName = Rx<String>("");
  Rx<String> endLocationName = Rx<String>("");
  Rx<String> distance = Rx<String>("0 km");
  Rx<String> time = Rx<String>("0 mins");
  RxList<String> directions = RxList<String>();
  RxList<LatLng> routeCoordinates = RxList<LatLng>(); // To store route geometry


  final String accessToken = AppConstants.mapboxSecretKey; // Replace with your token

   @override
  void onInit() {
    super.onInit();
    startLocation.value = Get.arguments['startLocation'];
    endLocation.value = Get.arguments['endLocation'];
    startLocationName.value = Get.arguments['startPlaceName'];
    endLocationName.value = Get.arguments['endPlaceName'];
    calculateRoute();
  }

  Future<void> calculateRoute() async {
   
    if (startLocation.value != null && endLocation.value != null) {
      final url =
          "https://api.mapbox.com/directions/v5/mapbox/driving/${startLocation.value!.longitude},${startLocation.value!.latitude};${endLocation.value!.longitude},${endLocation.value!.latitude}?geometries=geojson&access_token=$accessToken";

      try {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final route = data['routes'][0];

          // Update distance and time
          distance.value = "${(route['distance'] / 1000).toStringAsFixed(2)} km";
          time.value = "${(route['duration'] / 60).toStringAsFixed(0)} mins";

          // Update route coordinates
          final geometry = route['geometry']['coordinates'] as List;
          routeCoordinates.value = geometry.map((coord) {
            return LatLng(coord[1], coord[0]);
          }).toList();

          // Update step-by-step directions
          final steps = route['legs'][0]['steps'] as List;
          directions.value = steps.map((step) {
            return step['maneuver']['instruction'] as String;
          }).toList();
        } else {
          Get.snackbar("Error", "Failed to fetch route: ${response.body}");
        }
      } catch (e) {
        Get.snackbar("Error", "An error occurred: $e");
      }
    } else {
      Get.snackbar("Error", "Start and End locations are required.");
    }
  }

  save() async {
  if (startLocation.value != null && endLocation.value != null) {
    final box = Hive.box('historyBox');
    final history = {
      "startPlaceName": startLocationName.value,
      "endPlaceName": endLocationName.value,
      "startLocation": {
        "latitude": startLocation.value!.latitude,
        "longitude": startLocation.value!.longitude,
      },
      "endLocation": {
        "latitude": endLocation.value!.latitude,
        "longitude": endLocation.value!.longitude,
      },
      "distance": distance.value,
      "time": time.value,
      "directions": directions.toList(),
    };
    await box.add(history);
    Get.snackbar("Saved", "Route saved to history!", backgroundColor: Colors.green,colorText: Colors.white,);
    Get.offAllNamed(AppRoutes.home);
  } else {
    Get.snackbar("Error", "No route to save.");
  }
}

}


