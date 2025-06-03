import 'package:admin_ocean_learn2/bindings/app_binding.dart';
import 'package:admin_ocean_learn2/bindings/dashboard_binding.dart';
import 'package:admin_ocean_learn2/bindings/intro_binding.dart';
import 'package:admin_ocean_learn2/bindings/login_binding.dart';
import 'package:admin_ocean_learn2/bindings/schedule_binding.dart';
import 'package:admin_ocean_learn2/pages/dashboard/dashboard.dart';
import 'package:admin_ocean_learn2/pages/home/home_page.dart';
import 'package:admin_ocean_learn2/pages/intro/intro.dart';
import 'package:admin_ocean_learn2/pages/login/login_page.dart';
import 'package:admin_ocean_learn2/pages/member/member_page.dart';
import 'package:admin_ocean_learn2/pages/payment/payment_page.dart';
import 'package:admin_ocean_learn2/pages/profile/profile_page.dart';
import 'package:admin_ocean_learn2/pages/schedule/schedule_page.dart';
import 'package:admin_ocean_learn2/pages/splashscreen/splashscreen.dart';
import 'package:admin_ocean_learn2/routes/my_routes.dart';
import 'package:get/get.dart';

class MyAppPage {
  static final List<GetPage> pages = [
    GetPage(
      name: MyAppRoutes.splashScreen, 
      page: () => SplashScreen(),
      binding: AppBinding(),
    ),
    GetPage(
      name: MyAppRoutes.introPage, 
      page: () => IntroPage(),
      binding: IntroBinding(),
    ),
    GetPage(
      name: MyAppRoutes.loginPage, 
      page: () => LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: MyAppRoutes.dashboard, 
      page: () => DashboardPage(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: MyAppRoutes.homePage, 
      page: () => HomePage(),
    ),
    GetPage(
      name: MyAppRoutes.schedulePage, 
      page: () => SchedulePage(),
      binding: ScheduleBinding(),
    ),
    GetPage(
      name: MyAppRoutes.paymentPage, 
      page: () => PaymentPage(),
    ),
    GetPage(
      name: MyAppRoutes.memberPage, 
      page: () => MemberPage(),
    ),
    GetPage(
      name: MyAppRoutes.profilePage, 
      page: () => ProfilePage(),
    ),
  ];
}