import 'package:admin_ocean_learn2/pages/schedule/schedule_controller.dart';
import 'package:get/get.dart';

class ScheduleBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ScheduleController>(() => ScheduleController());
  }
}