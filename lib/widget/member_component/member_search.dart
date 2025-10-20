import 'package:admin_ocean_learn2/pages/member/member_controller.dart';
import 'package:admin_ocean_learn2/utils/color_palette.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MemberSearchFilter extends StatelessWidget {
  final MemberController controller;

  const MemberSearchFilter({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: netralColor,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Search Bar
          Container(
            decoration: BoxDecoration(
              color: pureWhite,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: primaryColor.withOpacity(0.3)),
            ),
            child: TextField(
              onChanged: controller.updateSearchQuery,
              decoration: const InputDecoration(
                hintText: 'Search members by name, email, or role...',
                prefixIcon: Icon(Icons.search, color: primaryColor),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Sort Filter
          Row(
            children: [
              const Text(
                'Sort by:',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Obx(() => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: pureWhite,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: primaryColor.withOpacity(0.3)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: controller.sortBy.value,
                      isExpanded: true,
                      items: const [
                        DropdownMenuItem(value: 'name', child: Text('Name')),
                        DropdownMenuItem(value: 'status', child: Text('Status')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          controller.updateSortBy(value);
                        }
                      },
                    ),
                  ),
                )),
              ),
            ],
          ),
        ],
      ),
    );
  }
}