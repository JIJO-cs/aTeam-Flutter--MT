import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      builder: (context, child) {
    return GetMaterialApp(
      title: 'ATeam',
      initialRoute: AppRoutes.initial,
      getPages: AppRoutes.routes
    );
      }
    );
  }
}