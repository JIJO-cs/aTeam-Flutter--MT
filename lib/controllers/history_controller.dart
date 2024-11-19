import 'package:get/get.dart';
import 'package:hive/hive.dart';

class HistoryController extends GetxController {
  RxList<Map<String, dynamic>> historyList = RxList<Map<String, dynamic>>();

  @override
  void onInit() {
    super.onInit();
    loadHistory();
  }

  void loadHistory() {
    final box = Hive.box('historyBox');
    historyList.value =
        box.values.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  void clearHistory() {
    final box = Hive.box('historyBox');
    box.clear();
    loadHistory();
    Get.snackbar("Cleared", "History cleared.");
  }
}
