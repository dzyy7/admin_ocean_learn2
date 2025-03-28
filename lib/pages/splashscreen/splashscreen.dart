import 'package:admin_ocean_learn2/utils/color_palette.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    await Future.delayed(const Duration(seconds: 1));

    if (token != null && token.isNotEmpty) {
      Get.offNamed(MyAppRoutes.dashboard);
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
              Text(
                'Ocean Learn',
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