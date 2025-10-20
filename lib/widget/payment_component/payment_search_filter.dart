import 'package:flutter/material.dart';
import 'package:admin_ocean_learn2/utils/color_palette.dart';
import 'package:admin_ocean_learn2/pages/payment/payment_controller.dart';

class SearchAndFilter extends StatelessWidget {
  final PaymentController controller;
  const SearchAndFilter({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: secondaryColor,
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
                    SizedBox(
            height: 40,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: controller.months.map((month) {
                  final isSelected = controller.selectedMonth.value == month;
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(formatMonthLabel(month)),
                      selected: isSelected,
                      selectedColor: primaryColor,
                      backgroundColor: secondaryColor,
                      labelStyle: TextStyle(
                        color: isSelected ? pureWhite : textColor,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      onSelected: (selected) {
                        if (selected) controller.changeSelectedMonth(month);
                      },
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
      
    );
  }
  
  String formatMonthLabel(String key) {
    final parts = key.split('-');
    if (parts.length != 2) return key;

    final year = parts[0];
    final month = int.tryParse(parts[1]) ?? 0;

    const monthNames = [
      '', // index 0 dummy
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];

    final monthName =
        (month >= 1 && month <= 12) ? monthNames[month] : 'Unknown';
    return '$monthName $year';
  }}
