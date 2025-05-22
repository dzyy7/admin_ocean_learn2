import 'package:admin_ocean_learn2/widget/profile_component/logout_button.dart';
import 'package:admin_ocean_learn2/widget/profile_component/profile_info_card.dart';
import 'package:admin_ocean_learn2/widget/profile_component/profile_setting_card.dart';
import 'package:flutter/material.dart';
import 'package:admin_ocean_learn2/utils/color_palette.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: netralColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Center(
          child: Text(
            'Manage your profile here!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            ProfileInfoCard(),
            SizedBox(height: 16),
            ProfileSettingsCard(),
            Spacer(),
            LogoutButton(),
          ],
        ),
      ),
    );
  }
}
