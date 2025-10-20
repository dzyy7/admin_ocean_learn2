import 'package:admin_ocean_learn2/utils/color_palette.dart';
import 'package:admin_ocean_learn2/utils/user_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:admin_ocean_learn2/routes/my_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ),
    );

    _animationController.forward();

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _checkAuthentication();
      }
    });
  }

  Future<void> _checkAuthentication() async {
    final token = UserStorage.getToken();
    final userRole = UserStorage.getRole();
    print('Token from GetStorage: $token');
    print('User role: $userRole');
    await Future.delayed(const Duration(seconds: 1));

    if (token != null && token.isNotEmpty) {
      if (userRole != null && userRole.toLowerCase() == 'admin') {
        Get.offNamed(MyAppRoutes.dashboard);
      } else {
        await UserStorage.clearUserData();
        Get.offNamed(MyAppRoutes.introPage);
      }
    } else {
      Get.offNamed(MyAppRoutes.introPage);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: netralColor,
      body: Center(
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo_light.png',
                width: 200,
                height: 200,
              ),
              const SizedBox(height: 20),
              const Text(
                'Ocean Learn Admin',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}