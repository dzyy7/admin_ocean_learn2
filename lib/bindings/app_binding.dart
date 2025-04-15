import 'package:admin_ocean_learn2/pages/dashboard/dashboard_controller.dart';
import 'package:admin_ocean_learn2/pages/intro/intro_controller.dart';
import 'package:admin_ocean_learn2/pages/login/login_controller.dart';
import 'package:admin_ocean_learn2/pages/schedule/schedule_controller.dart';
import 'package:get/get.dart';

class AppBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController(), fenix: true);
    Get.lazyPut<DashboardController>(() => DashboardController(), fenix: true);
    Get.lazyPut<IntroController>(() => IntroController(), fenix: true);
    Get.lazyPut<ScheduleController>(() => ScheduleController(), fenix: true);
    
  }
}