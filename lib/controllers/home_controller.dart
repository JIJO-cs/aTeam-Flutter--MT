import 'package:ateam/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class HomeScreenController extends GetxController {
  // Observables to track selected locations
  Rx<LatLng?> startLocation = Rx<LatLng?>(null);
  Rx<LatLng?> endLocation = Rx<LatLng?>(null);

  // Observables to store place names
  RxString startPlaceName = "Select Start Location".obs;
  RxString endPlaceName = "Select End Location".obs;

  // Update methods for location and place name
  void updateStartLocation(locationData) {
    startLocation.value = locationData["location"];
    startPlaceName.value = locationData["name"];
  }

  void updateEndLocation(locationData) {
    endLocation.value = locationData["location"];
    endPlaceName.value = locationData["name"];
  }

  // Navigate to results screen
  void navigate() {
    if (startLocation.value != null && endLocation.value != null) {
      Get.toNamed(AppRoutes.resultScreen, arguments: {
        "startLocation": startLocation.value,
        "endLocation": endLocation.value,
        "startPlaceName": startPlaceName.value,
        "endPlaceName": endPlaceName.value
      });
    } else {
      Get.snackbar("Warning", "Please select both start and end locations.", backgroundColor: Colors.orange,
      colorText: Colors.white
      );
    }
  }

  void goToHistory(){
    Get.toNamed(AppRoutes.history);
  }
}
