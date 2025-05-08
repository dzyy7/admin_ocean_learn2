import 'package:flutter/material.dart';
import 'package:admin_ocean_learn2/utils/color_palette.dart';
import 'package:admin_ocean_learn2/widget/payment_component/payment_card.dart';
import 'package:admin_ocean_learn2/pages/payment/payment_controller.dart';

class PaymentDashboard extends StatelessWidget {
  final PaymentController controller;
  const PaymentDashboard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 6, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.analytics_outlined, color: pureWhite, size: 24),
              ),
              const SizedBox(width: 12),
              const Text(
                'Payment Dashboard',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColor),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: PaymentCard(
                  title: 'Completed Payments',
                  value: controller.subscriptions.where((s) => s.status == 'Paid').length.toString(),
                  icon: Icons.check_circle_outline,
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: PaymentCard(
                  title: 'Rejected Payments',
                  value: controller.subscriptions.where((s) => s.status == 'Canceled').length.toString(),
                  icon: Icons.cancel_outlined,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: PaymentCard(
                  title: 'Total Revenue',
                  value: 'Rp ${_calculateTotalRevenue()}',
                  icon: Icons.account_balance_wallet,
                  color: primaryColor,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: PaymentCard(
                  title: 'Total Transactions',
                  value: controller.subscriptions.length.toString(),
                  icon: Icons.receipt_long,
                  color: Colors.purple,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _calculateTotalRevenue() {
    double total = 0;
    for (var s in controller.subscriptions) {
      if (s.status == 'Paid') {
        String amountStr = s.detail.amount.replaceAll(RegExp(r'[^0-9.]'), '');
        if (amountStr.isNotEmpty) total += double.tryParse(amountStr) ?? 0;
      }
    }
    return '${(total / 1000).toStringAsFixed(1)} juta';
  }
}
