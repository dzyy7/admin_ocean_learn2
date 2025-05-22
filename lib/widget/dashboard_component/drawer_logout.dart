import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../pages/login/login_controller.dart';

class DrawerLogout extends StatelessWidget {
  const DrawerLogout({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextButton.icon(
          icon: const Icon(Icons.logout, color: Colors.blue),
          label: const Text('Log out', style: TextStyle(color: Colors.blue)),
          onPressed: () => Get.find<LoginController>().logout(),
        ),
      ),
    );
  }
}
