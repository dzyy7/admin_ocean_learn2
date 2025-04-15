import 'package:admin_ocean_learn2/bindings/app_binding.dart';
import 'package:admin_ocean_learn2/pages/dashboard/dashboard.dart';
import 'package:admin_ocean_learn2/pages/dashboard/dashboard_controller.dart';
import 'package:admin_ocean_learn2/pages/intro/intro.dart';
import 'package:admin_ocean_learn2/pages/login/login_controller.dart';
import 'package:admin_ocean_learn2/pages/login/login_page.dart';
import 'package:admin_ocean_learn2/pages/splashscreen/splashscreen.dart';
import 'package:admin_ocean_learn2/routes/my_pages.dart';
import 'package:admin_ocean_learn2/routes/my_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Ocean Learn',
      initialRoute: MyAppRoutes.splashScreen,
      initialBinding: AppBinding(), 
      getPages: MyAppPage.pages,
    );
  }
}