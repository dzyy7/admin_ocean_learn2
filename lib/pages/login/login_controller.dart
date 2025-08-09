import 'package:admin_ocean_learn2/services/firebase_service.dart';
import 'package:admin_ocean_learn2/services/login_service.dart';
import 'package:admin_ocean_learn2/utils/user_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  RxBool isLoading = false.obs;
  RxBool rememberMe = false.obs;
  
  static String? _sessionToken;
  static String? _sessionEmail;
  static String? _sessionName;
  static String? _sessionRole;
  
  static String? getSessionToken() {
    return _sessionToken;
  }
  
  static String? getSessionEmail() {
    return _sessionEmail;
  }
  
  static String? getSessionName() {
    return _sessionName;
  }
  
  static String? getSessionRole() {
    return _sessionRole;
  }

  void login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showErrorDialog('Please enter email and password');
      return;
    }

    isLoading.value = true;

    final response = await LoginService.login(email, password);
    isLoading.value = false;

    if (response.status && response.accountInfo != null) {
      if (response.accountInfo!.role.toLowerCase() != 'admin') {
        _showErrorDialog('Access denied. Only admin users can login to this application.');
        return;
      }
      
      final token = response.accountInfo!.tokens.isNotEmpty
          ? response.accountInfo!.tokens[0].token
          : '';

      if (token.isNotEmpty) {
        _sessionToken = token;
        _sessionEmail = response.accountInfo!.email;
        _sessionName = response.accountInfo!.name;
        _sessionRole = response.accountInfo!.role;
        
        if (rememberMe.value) {
          await UserStorage.saveUserData(
            token: token,
            email: response.accountInfo!.email,
            name: response.accountInfo!.name,
            role: response.accountInfo!.role,
          );
        }
        
        print('Token saved: ${UserStorage.getToken() ?? _sessionToken}');
        FirebaseService.saveFcmTokenToServer();
        Get.offNamed('/dashboard');
      } else {
        _showErrorDialog('Token not found in response');
      }
    } else {
      _showErrorDialog(response.message);
    }
  }

  void logout() async {
  await UserStorage.clearUserData();

  _sessionToken = null;
  _sessionEmail = null;
  _sessionName = null;
  _sessionRole = null;

  print('User logged out locally.');
  Get.offAllNamed('/');
}


  void _showErrorDialog(String message) {
    Get.dialog(
      AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('OK'),
          ),
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