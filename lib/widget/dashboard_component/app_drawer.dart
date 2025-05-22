import 'package:admin_ocean_learn2/pages/dashboard/dashboard_controller.dart';
import 'package:admin_ocean_learn2/widget/dashboard_component/drawer_header.dart';
import 'package:admin_ocean_learn2/widget/dashboard_component/drawer_logout.dart';
import 'package:admin_ocean_learn2/widget/dashboard_component/drawer_menu_item.dart';
import 'package:admin_ocean_learn2/widget/dashboard_component/drawer_profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/color_palette.dart';


class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardController ctrl = Get.find<DashboardController>();

    return Drawer(
      backgroundColor: pureWhite,
      child: SafeArea(
        child: Column(
          children: [
            const DrawerHeaderWidget(),
            const DrawerProfile(),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerMenuItem(
                    icon: Icons.home,
                    title: 'Home',
                    selected: ctrl.selectedIndex.value == 0,
                    onTap: () {
                      ctrl.changeMenu(0);
                      Navigator.pop(context);
                    },
                  ),
                  DrawerMenuItem(
                    icon: Icons.calendar_today,
                    title: 'Schedule',
                    selected: ctrl.selectedIndex.value == 1,
                    onTap: () {
                      ctrl.changeMenu(1);
                      Navigator.pop(context);
                    },
                  ),
                  DrawerMenuItem(
                    icon: Icons.payment,
                    title: 'Pembayaran',
                    selected: ctrl.selectedIndex.value == 2,
                    onTap: () {
                      ctrl.changeMenu(2);
                      Navigator.pop(context);
                    },
                  ),
                  DrawerMenuItem(
                    icon: Icons.person,
                    title: 'Profile',
                    selected: ctrl.selectedIndex.value == 3,
                    onTap: () {
                      ctrl.changeMenu(3);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            const DrawerLogout(),
          ],
        ),
      ),
    );
  }
}
