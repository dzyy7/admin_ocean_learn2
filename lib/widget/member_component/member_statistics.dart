import 'package:admin_ocean_learn2/pages/member/member_controller.dart';
import 'package:admin_ocean_learn2/utils/color_palette.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MemberStatistics extends StatelessWidget {
  final MemberController controller;

  const MemberStatistics({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: pureWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Member Overview',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 16),
          Obx(() => Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total Members',
                  controller.totalMembers.value.toString(),
                  Icons.people,
                  primaryColor,
                ),
              ),
              const SizedBox(width: 12),
              
            ],
          )),
          const SizedBox(height: 12),
          Obx(() => Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Premium',
                  controller.premiumMembers.value.toString(),
                  Icons.star,
                  Colors.amber,
                ),
              ),              
            ],
          )),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: textColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}