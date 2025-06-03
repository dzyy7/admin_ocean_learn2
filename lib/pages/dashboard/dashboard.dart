import 'package:admin_ocean_learn2/pages/member/member_page.dart';
import 'package:admin_ocean_learn2/widget/dashboard_component/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dashboard_controller.dart';
import '../home/home_page.dart';
import '../schedule/schedule_page.dart';
import '../payment/payment_page.dart';
import '../profile/profile_page.dart';

class DashboardPage extends StatelessWidget {
  DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardController ctrl = Get.find<DashboardController>();
    final List<Widget> _menus = [
      HomePage(),
      SchedulePage(),
      PaymentPage(),
      MemberPage(),
      ProfilePage(),
    ];

    return Obx(() => Scaffold(
          body: _menus[ctrl.selectedIndex.value],
          drawer: AppDrawer(),
        ));
  }
}
