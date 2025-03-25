import 'package:admin_ocean_learn2/pages/dashboard/dashboard_controller.dart';
import 'package:admin_ocean_learn2/pages/home/home_page.dart';
import 'package:admin_ocean_learn2/pages/payment/payment_page.dart';
import 'package:admin_ocean_learn2/pages/profile/profile_page.dart';
import 'package:admin_ocean_learn2/pages/schedule/schedule_page.dart';
import 'package:admin_ocean_learn2/utils/color_palette.dart';
import 'package:admin_ocean_learn2/widget/payment_component/payment_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboardController = Get.put(DashboardController());
    final List<Widget> menus = [
      HomePage(), SchedulePage(), PaymentPage(),ProfilePage()
    ];

    return Obx(() {
      return Scaffold(
        body: menus[dashboardController.selectedIndex.value],
        drawer: Drawer(
          backgroundColor: pureWhite,
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10), 
                  child: Column(
                    children: [
                      Container(
                        height: 150,
                        width: 150,
                        child: Image.asset('assets/images/logo_light.png',
                            errorBuilder: (context, error, stackTrace) => Icon(
                                Icons.school,
                                size: 40,
                                color: Colors.blue)), 
                      ),
                      const SizedBox(height: 8), 
                      Text(
                        'Ocean Learn',
                        style: GoogleFonts.montserrat(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: textColor), 
                      ),
                      Text(
                        'Dive into learning, as deep as the sea.',
                        style: GoogleFonts.montserrat(
                            fontSize: 12, color: textColor),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 8),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(
                            'https://i.pinimg.com/736x/9f/be/f5/9fbef5a4ae96b3498fad7873a8ff9d09.jpg'),
                      ),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Samudra',
                            style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            'samudra@gmail.com',
                            style: GoogleFonts.montserrat(
                                fontSize: 12, color: textColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10), 
                      child: Column(
                        children: [
                          _buildMenuItem(
                            context,
                            Icons.home,
                            'Home',
                            isSelected:
                                dashboardController.selectedIndex.value == 0,
                            onTap: () {
                              dashboardController.changeMenu(0);
                              Navigator.pop(context);
                            },
                          ),
                          _buildMenuItem(
                            context,
                            Icons.calendar_today,
                            'Schedule',
                            isSelected:
                                dashboardController.selectedIndex.value == 1,
                            onTap: () {
                              dashboardController.changeMenu(1);
                              Navigator.pop(context);
                            },
                          ),
                          _buildMenuItem(
                            context,
                            Icons.payment,
                            'Pembayaran',
                            isSelected:
                                dashboardController.selectedIndex.value == 2,
                            onTap: () {
                              dashboardController.changeMenu(2);
                              Navigator.pop(context);
                            },
                          ),
                          _buildMenuItem(
                            context,
                            Icons.person,
                            'Profile',
                            isSelected:
                                dashboardController.selectedIndex.value == 3,
                            onTap: () {
                              dashboardController.changeMenu(3);
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.all(12), 
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextButton.icon(
                      icon: const Icon(Icons.logout, color: Colors.blue),
                      label: const Text(
                        'Log out',
                        style: TextStyle(color: Colors.blue),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String title,
      {bool isSelected = false, required Function onTap}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue.shade50 : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? Colors.blue : Colors.grey,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.blue : Colors.black,
          ),
        ),
        onTap: () => onTap(),
      ),
    );
  }
}
