import 'package:admin_ocean_learn2/pages/member/member_controller.dart';
import 'package:get/get.dart';

class MemberBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MemberController>(() => MemberController());
  }
}