import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
          BoxShadow(
            color: Colors.grey.withOpacity(0.15), 
            blurRadius: 8, 
            offset: const Offset(0, 3),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(Icons.dashboard_outlined, color: pureWhite, size: 28),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Payment Dashboard',
                    style: TextStyle(
                      fontSize: 24, 
                      fontWeight: FontWeight.bold, 
                      color: textColor,
                    ),
                  ),
                  Text(
                    'Overview & Analytics',
                    style: TextStyle(
                      fontSize: 14, 
                      color: textColor.withOpacity(0.7),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 28),
          
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: _buildEnhancedPaymentCard(
                    title: 'Completed Payments',
                    value: _getCompletedPaymentsForSelectedMonth().toString(),
                    subtitle: 'Successfully processed',
                    icon: Icons.check_circle_outline,
                    color: Colors.green,
                    gradientColors: [Colors.green.shade400, Colors.green.shade600],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildEnhancedPaymentCard(
                    title: 'Rejected Payments',
                    value: _getRejectedPaymentsForSelectedMonth().toString(),
                    subtitle: 'Failed transactions',
                    icon: Icons.cancel_outlined,
                    color: Colors.red,
                    gradientColors: [Colors.red.shade400, Colors.red.shade600],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: _buildEnhancedPaymentCard(
                  title: 'Monthly Revenue',
                  value: _formatCurrency(_calculateMonthlyRevenue()),
                  subtitle: 'Revenue for ${_getSelectedMonthDisplayName()}',
                  icon: Icons.account_balance_wallet_outlined,
                  color: primaryColor,
                  gradientColors: [primaryColor.withOpacity(0.8), primaryColor],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Get completed payments count for selected month
  int _getCompletedPaymentsForSelectedMonth() {
    final monthlySubscriptions = controller.getSubscriptionsForSelectedMonth();
    return monthlySubscriptions.where((s) => s.status == 'Paid').length;
  }

  // Get rejected payments count for selected month
  int _getRejectedPaymentsForSelectedMonth() {
    final monthlySubscriptions = controller.getSubscriptionsForSelectedMonth();
    return monthlySubscriptions.where((s) => s.status == 'Canceled').length;
  }

  // Get display name for selected month
  String _getSelectedMonthDisplayName() {
    if (controller.selectedMonth.value.isEmpty) return 'Current Month';
    
    try {
      final parts = controller.selectedMonth.value.split('-');
      if (parts.length == 2) {
        final year = parts[0];
        final month = int.parse(parts[1]);
        final monthNames = [
          '', 'January', 'February', 'March', 'April', 'May', 'June',
          'July', 'August', 'September', 'October', 'November', 'December'
        ];
        
        if (month >= 1 && month <= 12) {
          return '${monthNames[month]} $year';
        }
      }
    } catch (e) {
      print('Error parsing selected month: $e');
    }
    
    return controller.selectedMonth.value;
  }

  // Enhanced payment card with better design
  Widget _buildEnhancedPaymentCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    required List<Color> gradientColors,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.grey.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: gradientColors),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: Colors.white, size: 20),
              ),
              Container(
                width: 4,
                height: 30,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: gradientColors),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: textColor.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: textColor.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  // Calculate monthly revenue for selected month
  double _calculateMonthlyRevenue() {
    double total = 0;
    final monthlySubscriptions = controller.getSubscriptionsForSelectedMonth();
    
    for (var subscription in monthlySubscriptions) {
      if (subscription.status == 'Paid') {
        String rawOriginal = subscription.detail.amount;
        print('Original amount: $rawOriginal');

        String raw = rawOriginal.toLowerCase().trim();
        raw = raw.replaceAll(RegExp(r'[^0-9km.,]'), '');

        double multiplier = 1;
        if (raw.endsWith('k')) {
          multiplier = 1000;
          raw = raw.replaceAll('k', '');
        } else if (raw.endsWith('m')) {
          multiplier = 1000000;
          raw = raw.replaceAll('m', '');
        }

        raw = raw.replaceAll('.', '').replaceAll(',', '');

        print('Parsed raw: $raw * $multiplier');

        if (raw.isNotEmpty) {
          double? amount = double.tryParse(raw);
          if (amount != null) {
            total += amount * multiplier;
            print('Parsed amount: ${amount * multiplier}');
          }
        }
      }
    }

    print('Monthly Revenue for ${controller.selectedMonth.value}: $total');
    return total;
  }

  // Format currency properly
  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }
}