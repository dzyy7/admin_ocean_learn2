import 'package:admin_ocean_learn2/pages/intro/intro_controller.dart';
import 'package:get/get.dart';

class IntroBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IntroController>(() => IntroController());
  }
}