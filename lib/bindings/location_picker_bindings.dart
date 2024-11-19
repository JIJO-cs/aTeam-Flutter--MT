import 'package:ateam/controllers/location_picker_controller.dart';
import 'package:get/get.dart';

class LocationPickerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LocationPickerController>(() => LocationPickerController());
  }
}
