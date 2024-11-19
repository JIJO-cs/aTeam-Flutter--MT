

import 'package:ateam/constants/app_constants.dart';
import 'package:ateam/controllers/history_controller.dart';
import 'package:ateam/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mapbox_gl/mapbox_gl.dart';


class HistoryPage extends StatelessWidget {
  final HistoryController controller = Get.put(HistoryController());

   HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         iconTheme: const IconThemeData(
    color: Colors.white, // Change the color of the back button
  ),
        backgroundColor: Colors.blue,
        title: const Text('Route History',style: TextStyle(color: Colors.white),),
        actions: [
          // IconButton(
          //   icon: const Icon(Icons.delete),
          //   onPressed: controller.clearHistory,
          // ),
        ],
      ),
      body: Obx(
        () => controller.historyList.isEmpty
            ? const Center(child: Text("No route history available"))
            : ListView.builder(
                itemCount: controller.historyList.length,
                itemBuilder: (context, index) {
                  final history = controller.historyList[index];
                  return GestureDetector(
                    onTap: () {
                      // Navigate to Result Screen
                      Get.toNamed(
                        AppRoutes.resultScreen,
                        arguments: {
                          "startPlaceName": history['startPlaceName'],
                          "endPlaceName": history['endPlaceName'],
                          "startLocation": LatLng(
                            history['startLocation']['latitude'],
                            history['startLocation']['longitude'],
                          ),

                          "endLocation": LatLng(
                            history['endLocation']['latitude'],
                            history['endLocation']['longitude'],
                          ),
                        },
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            blurRadius: 5,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Map Preview
                          SizedBox(
                            height: 150,
                            child: MapboxMap(
                              accessToken: AppConstants.mapboxSecretKey,
                              initialCameraPosition: CameraPosition(
                                target: LatLng(
                                  history['startLocation']['latitude'],
                                  history['startLocation']['longitude'],
                                ),
                                zoom: 12.0,
                              ),
                              onMapCreated: (MapboxMapController mapController) {
                                mapController.addLine(
                                  LineOptions(
                                    geometry: [
                                      LatLng(
                                        history['startLocation']['latitude'],
                                        history['startLocation']['longitude'],
                                      ),
                                      LatLng(
                                        history['endLocation']['latitude'],
                                        history['endLocation']['longitude'],
                                      ),
                                    ],
                                    lineColor: "#3b9cff",
                                    lineWidth: 5.0,
                                  ),
                                );
                              },
                              myLocationEnabled: false,
                              zoomGesturesEnabled: false,
                              scrollGesturesEnabled: false,
                              tiltGesturesEnabled: false,
                              rotateGesturesEnabled: false,
                            ),
                          ),
                          // Route Details
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Distance: ${history['distance']}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Time: ${history['time']}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
