import 'package:admin_ocean_learn2/pages/dashboard/dashboard.dart';
import 'package:admin_ocean_learn2/pages/home/home_page.dart';
import 'package:admin_ocean_learn2/pages/intro/intro.dart';
import 'package:admin_ocean_learn2/pages/login/login_page.dart';
import 'package:admin_ocean_learn2/pages/payment/payment_page.dart';
import 'package:admin_ocean_learn2/pages/profile/profile_page.dart';
import 'package:admin_ocean_learn2/pages/schedule/schedule_page.dart';
import 'package:admin_ocean_learn2/pages/splashscreen/splashscreen.dart';
import 'package:admin_ocean_learn2/routes/my_routes.dart';
import 'package:get/get.dart';


class MyAppPage {
  static final List<GetPage> pages = [
    //GetPage(name: name, page: page)
    GetPage(name: MyAppRoutes.splashScreen, page: () => SplashScreen()),
    GetPage(name: MyAppRoutes.introPage, page: () => IntroPage()),
    GetPage(name: MyAppRoutes.loginPage, page: () => LoginPage()),
    GetPage(name: MyAppRoutes.dashboard, page: () => Dashboard()),
    GetPage(name: MyAppRoutes.homePage, page: () => HomePage()),
    GetPage(name: MyAppRoutes.schedulePage, page: () => SchedulePage()),
    GetPage(name: MyAppRoutes.paymentPage, page: () => PaymentPage()),
    GetPage(name: MyAppRoutes.profilePage, page: () => ProfilePage()),

  ];
}
