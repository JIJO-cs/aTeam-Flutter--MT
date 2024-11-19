import 'package:ateam/bindings/history_bindings.dart';
import 'package:ateam/bindings/home_bindings.dart';
import 'package:ateam/bindings/location_picker_bindings.dart';
import 'package:ateam/bindings/result_binding.dart';
import 'package:ateam/bindings/splash_bindings.dart';
import 'package:ateam/views/history_screen.dart';
import 'package:ateam/views/home_screen.dart';
import 'package:ateam/views/location_picker_screen.dart';
import 'package:ateam/views/result_view.dart';
import 'package:get/get.dart';

import 'views/splash_screen.dart';

class AppRoutes {

  static const String initial = '/';
  static const String home = '/home';
  static const String locationPicker = '/location-picker';
  static const String resultScreen = '/result-screen';
  static const String history = '/history';

  static final routes = [
    GetPage(name: initial, page: () => const SplashScreenView(), binding: SplashBinding()),
    GetPage(name: home, page: () => const HomeScreen(), binding: HomeScreenBinding()),
    GetPage(
      name: locationPicker,
      page: () => MapboxLocationPickerScreen(),
      binding: LocationPickerBinding(),
    ),
    GetPage(name: resultScreen, page: ()=> ResultsScreen(), binding: ResultsScreenBinding()),
    GetPage(name: history, page: () =>  HistoryPage(), binding: HistoryBinding()),
  ];
}