import 'package:ateam/constants/app_constants.dart';
import 'package:ateam/controllers/result_controller.dart';
import 'package:ateam/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class ResultsScreen extends StatelessWidget {
  final ResultsScreenController controller = Get.put(ResultsScreenController());

   ResultsScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => Column(
          children: [
            Container(
              height: Get.height * 0.4,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20),
              child: Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Your Location",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      controller.startLocationName.value,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10), 
                    Row(
                      children: [
                        const Icon(Icons.location_pin,
                            color: Colors.white, size: 14),
                        const SizedBox(width: 5),
                        Text(
                          "Lat: ${controller.startLocation.value?.latitude}, Lng: ${controller.startLocation.value?.longitude}", // Replace with dynamic data if required
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    const Divider(color: Colors.white),

                    const SizedBox(height: 20),
                    Text(
                      controller.endLocationName.value,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10), 
                    Row(
                      children: [
                        const Icon(Icons.location_pin,
                            color: Colors.white, size: 14), // Location pin icon
                        const SizedBox(width: 5),
                        Text(
                          "Lat: ${controller.endLocation.value?.latitude}, Lng: ${controller.endLocation.value?.longitude}", // Replace with dynamic data if required
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.navigation_sharp,
                            color: Colors.white, size: 14), 
                        const SizedBox(width: 5),
                        Text(
                          controller.distance
                              .value, 
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              flex: 2,
              child: MapboxMap(
                accessToken: AppConstants.mapboxSecretKey,
                initialCameraPosition: CameraPosition(
                  target: controller.startLocation.value ?? const LatLng(0, 0),
                  zoom: 10.0,
                ),
                onMapCreated: (MapboxMapController mapController) async {
                  controller.routeCoordinates.listen((route) {
                    if (route.isNotEmpty) {
                      mapController.addLine(
                        LineOptions(
                          geometry: route,
                          lineColor: "#3b9cff",
                          lineWidth: 5.0,
                        ),
                      );
                    }
                  });
                },
              ),
            ),
            Container(
              color: Colors.blue,
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (Get.previousRoute == AppRoutes.history) {
                        Get.back();
                      } else {
                        controller.save();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      (Get.previousRoute == AppRoutes.history)
                          ? "Back" // Show "Back" if coming from history
                          : "Save", // Show "Save" otherwise
                      style: const TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
