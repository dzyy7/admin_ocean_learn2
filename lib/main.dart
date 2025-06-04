import 'package:admin_ocean_learn2/routes/my_pages.dart';
import 'package:admin_ocean_learn2/routes/my_routes.dart';
import 'package:admin_ocean_learn2/services/firebase_service.dart';
import 'package:admin_ocean_learn2/utils/user_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await GetStorage.init();
  await UserStorage.init();
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.requestPermission();
  await FirebaseService.saveFcmTokenToServer();
  FirebaseMessaging.instance.onTokenRefresh.listen((newtoken) {
    FirebaseService.saveFcmTokenToServer();
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Ocean Learn Admin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: MyAppRoutes.splashScreen,
      getPages: MyAppPage.pages,
    );
  }
}