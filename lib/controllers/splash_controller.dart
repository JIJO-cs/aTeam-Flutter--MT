import 'dart:developer';

import 'package:get/get.dart';

class SplashController extends GetxController {

  final String _version = '1.0.0';

  String get version => _version;

 @override
  void onInit() {
    super.onInit();
    log('SplashController initialized');
  }




  @override
  void onReady() {
    super.onReady();
    log('OnReady');
    Future.delayed(const Duration(seconds: 3), () {
     Get.offNamed('/home');
    });
  }  
}