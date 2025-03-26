import 'package:admin_ocean_learn2/services/login_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  
  RxBool isLoading = false.obs;
  RxBool rememberMe = false.obs;

  void login() async {
    if (emailController.text.trim().isEmpty || passwordController.text.trim().isEmpty) {
      _showErrorDialog('Please enter email and password');
      return;
    }

    isLoading.value = true;

    final result = await LoginService.login(
      emailController.text.trim(), 
      passwordController.text.trim()
    );

    isLoading.value = false;

    if (result['success']) {
      if (rememberMe.value) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', result['data']['token']);
        await prefs.setString('email', emailController.text.trim());
      }

      Get.offNamed('/dashboard');
    } else {
      _showErrorDialog(result['message']);
    }
  }

  void _showErrorDialog(String message) {
    Get.dialog(
      AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            child: Text('Okay'),
            onPressed: () => Get.back(),
          )
        ],
      ),
    );
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}