import 'package:ateam/controllers/location_picker_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:mapbox_gl/mapbox_gl.dart';


class MapboxLocationPickerScreen extends StatelessWidget {
  final LocationPickerController controller = Get.put(LocationPickerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
  backgroundColor: Colors.blue,
  title: Row(
    children: [
      // Back Button
      IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          Navigator.of(context).pop(); // Go back to the previous screen
        },
      ),
      Expanded(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: TypeAheadField<Map<String, dynamic>>(
            textFieldConfiguration: TextFieldConfiguration(
              decoration: InputDecoration(
                hintText: "Search Location",
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey.shade600),
              ),
              style: TextStyle(color: Colors.black),
            ),
            suggestionsCallback: (query) async {
              return await controller.searchLocations(query);
            },
            itemBuilder: (context, suggestion) {
              return ListTile(
                leading: const Icon(Icons.location_on, color: Colors.blue),
                title: Text(suggestion['name']),
              );
            },
            onSuggestionSelected: (suggestion) {
              final LatLng location = suggestion['coordinates'];
              controller.moveToLocation(location);
            },
          ),
        ),
      ),
    ],
  ),
),

      body: Stack(
        children: [
          MapboxMap(
            accessToken: controller.mapboxAccessToken,
            onMapCreated: controller.onMapCreated,
            onMapClick: controller.onMapTapped,
            initialCameraPosition: const CameraPosition(
              target: LatLng(37.7749, -122.4194), // Default location
              zoom: 12.0,
            ),
            myLocationEnabled: true,
            myLocationTrackingMode: MyLocationTrackingMode.Tracking,
          ),
          Obx(() {
            if (controller.selectedLocation.value != null) {
              return Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: ElevatedButton(
                  onPressed: () {
                    // Pass the selected location back to the previous screen
                    Get.back(result: {
                        "location": controller.selectedLocation.value,
                        "name": controller.selectedLocationName.value,
                      });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Confirm Location',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          }),
        ],
      ),
    );
  }
}
