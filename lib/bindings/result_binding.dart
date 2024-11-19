import 'package:ateam/controllers/result_controller.dart';
import 'package:get/get.dart';

class ResultsScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ResultsScreenController>(() => ResultsScreenController());
  }
}
