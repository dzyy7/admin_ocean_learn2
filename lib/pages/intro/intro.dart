import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:admin_ocean_learn2/pages/intro/intro_controller.dart';
import 'package:admin_ocean_learn2/routes/my_routes.dart';
import 'package:admin_ocean_learn2/utils/color_palette.dart';
import 'package:admin_ocean_learn2/widget/my_slider.dart';

class IntroPage extends StatelessWidget {
  IntroPage({super.key});

  final IntroController controller = Get.put(IntroController());

  final List<Map<String, String>> introData = [
    {
      "img": "assets/svg/intro1.svg",
      "title": "Learn the Easy Way!",
      "description": "Fun, fast, and effective English lessons just for you.",
    },
    {
      "img": "assets/svg/intro2.svg",
      "title": "Learn Anytime, Anywhere!",
      "description": "Pick up where you left off, wherever you are.",
    },
    {
      "img": "assets/svg/intro3.svg",
      "title": "Pay Your Way!",
      "description": "Simple, hassle-free payments so you can focus on learning.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: netralColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                onPageChanged: controller.updatePage,
                itemCount: introData.length,
                itemBuilder: (context, index) {
                  final item = introData[index];
                  return MySlider(
                    img: item["img"]!,
                    title: item["title"]!,
                    description: item["description"]!,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    introData.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: controller.currentPage.value == index 
                          ? 35 
                          : 8,  
                      height: 8,
                      decoration: BoxDecoration(
                        color: controller.currentPage.value == index 
                            ? primaryColor 
                            : secondaryColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Get.offNamed(MyAppRoutes.loginPage);
                    },
                    child: Text(
                      'Skip',
                      style: GoogleFonts.poppins(
                        color: textColor,
                      ),
                    ),
                  ),
                  Obx(
                    () => OutlinedButton(
                      onPressed: () {
                        if (controller.currentPage.value < introData.length - 1) {
                          controller.pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          Get.offNamed(MyAppRoutes.loginPage);
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: primaryColor, width: 1),
                        foregroundColor: textColor,
                        backgroundColor: secondaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      ),
                      child: Text(
                        style: GoogleFonts.poppins(
                          color: textColor,
                          fontWeight: FontWeight.bold, 
                        ),
                        controller.currentPage.value == introData.length - 1 
                            ? "Start" 
                            : "Next",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}