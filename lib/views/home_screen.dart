
import 'package:ateam/constants/app_constants.dart';
import 'package:ateam/controllers/home_controller.dart';
import 'package:ateam/routes.dart';
import 'package:ateam/views/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mapbox_gl/mapbox_gl.dart';



class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeScreenController controller = Get.find<HomeScreenController>();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header with user details
          const CustomAppBar(
            userName: "Robert Doe",
            userEmail: "robertdoe@email.com",
            ),
          const SizedBox(height: 20),
          // Search fields
        Expanded(
  child: Container(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      children: [
        _buildSearchField("Start Location", () async {
       final startLocation  = await Get.toNamed(AppRoutes.locationPicker);
          if (startLocation != null) {

            controller.updateStartLocation(startLocation);
          }
        },controller.startPlaceName,controller.startLocation),
        const SizedBox(height: 15),
        _buildSearchField("End Location", () async {
          dynamic endLocation = await Get.toNamed(AppRoutes.locationPicker);
          if (endLocation != null) {
            controller.updateEndLocation(endLocation);
            // 
          }
        },controller.endPlaceName,controller.endLocation),
        const Spacer(),
        const SizedBox(height: 20),
      ],
    ),
  ),
),


        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.blue,
        padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Navigate to route screen
                            controller.navigate();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text("Navigate",style: TextStyle(color: Colors.blue),),
                        ),
                        ElevatedButton(
                          onPressed: () {
                           controller.goToHistory(); 
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text("Saved",style: TextStyle(color: Colors.blue),),
                        ),
                      ],
                    ),
                  ),
    );
  }

Widget _buildSearchField(String hint, VoidCallback onTap, RxString placeName,Rx<dynamic> location) {
  return InkWell(
    onTap: onTap,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            border: Border.all(
      color: Colors.blue, // Border color
      width: 1.0,         // Border width
    ),
            
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 5,
                spreadRadius: 2,
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() => Expanded(
                    child: Text(
                          placeName.value,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                            overflow: TextOverflow.ellipsis,
                          ),
                          
                        ),
                  )),
                  const Icon(Icons.location_on, color: Colors.blue),
                ],
              ),
            Obx(() {
        if (location.value != null) {
          return _buildMapPreview(location.value!,onTap); // Show map preview
        } else {
          return const SizedBox(height: 0); // Hide if no location is selected
        }
              }),
            ],
          ),
        ),
      ],
    ),
  );
}


Widget _buildMapPreview(LatLng location,onTap) {
  return Container(
    height: 150,
    margin: const EdgeInsets.only(top: 10), // Space between field and map
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.shade200,
          blurRadius: 5,
          spreadRadius: 2,
        ),
      ],
    ),
    child: AbsorbPointer(
      absorbing: true,
      child: MapboxMap(
        accessToken: AppConstants.mapboxSecretKey,
        initialCameraPosition: CameraPosition(
          target: location,
          zoom: 14.0, // Adjust zoom for map preview
        ),
        myLocationEnabled: false,
         onMapCreated: (MapboxMapController mapController) async {
          // Load custom pin image and add a symbol
          await mapController.addImage(
            "custom-pin",
            await _loadAssetImage('assets/custom_pin.png'),
          );
          mapController.addSymbol(SymbolOptions(
            geometry: location,
            iconImage: "custom-pin",
            iconSize: 0.2, // Adjust the size of the pin
          ));
        },
      ),
    ),
  );
}

Future<Uint8List> _loadAssetImage(String assetPath) async {
  final byteData = await rootBundle.load(assetPath);
  return byteData.buffer.asUint8List();
}

}