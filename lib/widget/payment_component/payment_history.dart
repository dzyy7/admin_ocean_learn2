import 'package:flutter/material.dart';
import 'package:admin_ocean_learn2/model/subscription_model.dart';
import 'package:admin_ocean_learn2/pages/payment/payment_controller.dart';
import 'package:admin_ocean_learn2/utils/color_palette.dart';

class PaymentHistory extends StatelessWidget {
  final SubscriptionModel subscription;
  final PaymentController controller;

  const PaymentHistory({
    super.key,
    required this.subscription,
    required this.controller,
  });

  // Helper method untuk mapping payment method
  String _getDisplayPaymentMethod(String originalMethod) {
    final method = originalMethod.toLowerCase();
    if (method == 'cash') {
      return 'Cash';
    } else {
      return 'Transfer'; // Semua selain cash jadi Transfer
    }
  }

  // Helper method to check if confirm button should be shown
  bool _shouldShowConfirmButton() {
    final paymentMethod = subscription.detail.paymentMethod.toLowerCase();
    final status = subscription.status.toLowerCase();
    
    // Show confirm button for cash and transfer when status is 'paid'
    return (paymentMethod == 'cash' || paymentMethod == 'transfer') && 
           status == 'paid';
  }

  @override
  Widget build(BuildContext context) {
    final username = controller.getUsernameFromId(subscription.userId);
    final userEmail = controller.getUserEmailFromId(subscription.userId);
    final userRole = controller.getUserRoleFromId(subscription.userId);
    final paymentMethod = subscription.detail.paymentMethod.toLowerCase();
    final displayPaymentMethod =
        _getDisplayPaymentMethod(subscription.detail.paymentMethod);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        username,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        userEmail,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(subscription.status),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    subscription.status,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildDetailItem(
                    'Amount',
                    'Rp ${subscription.detail.amount}',
                    Icons.attach_money,
                  ),
                ),
                Expanded(
                  child: _buildDetailItem(
                    'Method',
                    displayPaymentMethod, // Gunakan display method yang sudah dimapping
                    _getPaymentMethodIcon(paymentMethod),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildDetailItem(
                    'Date',
                    subscription.detail.paidAt,
                    Icons.calendar_today,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                // Show confirm button only when status is 'paid'
                if (_shouldShowConfirmButton())
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => controller.confirmPayment(subscription),
                      icon: const Icon(Icons.check, color: Colors.white),
                      label: Text(
                        'Confirm ${displayPaymentMethod.toUpperCase()}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: paymentMethod == 'cash'
                            ? Colors.green
                            : Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                if (_shouldShowConfirmButton())
                  const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: subscription.status.toLowerCase() == 'canceled'
                        ? null
                        : () => controller.viewInvoice(subscription),
                    icon: Icon(
                      Icons.receipt,
                      color: subscription.status.toLowerCase() == 'canceled'
                          ? Colors.grey
                          : primaryColor,
                    ),
                    label: Text(
                      'View Invoice',
                      style: TextStyle(
                        color: subscription.status.toLowerCase() == 'canceled'
                            ? Colors.grey
                            : primaryColor,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: subscription.status.toLowerCase() == 'canceled'
                            ? Colors.grey
                            : primaryColor,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return Colors.orange; // Changed to orange to distinguish from confirmed
      case 'pending':
        return Colors.grey;
      case 'confirmed':
        return Colors.green; // Confirmed is now green (success)
      case 'failed':
        return Colors.red;
      case 'canceled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getPaymentMethodIcon(String paymentMethod) {
    switch (paymentMethod) {
      case 'cash':
        return Icons.money;
      case 'transfer':
        return Icons.account_balance;
      default:
        return Icons.payment;
    }
  }
}