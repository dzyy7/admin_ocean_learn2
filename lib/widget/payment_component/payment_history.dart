import 'package:admin_ocean_learn2/model/subscription_model.dart';
import 'package:flutter/material.dart';
import 'package:admin_ocean_learn2/utils/color_palette.dart';
import 'package:admin_ocean_learn2/pages/payment/payment_controller.dart';

class PaymentHistory extends StatelessWidget {
  final SubscriptionModel subscription;
  final PaymentController controller;

  const PaymentHistory({super.key, required this.subscription, required this.controller});

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    switch (subscription.status) {
      case 'Paid':
        statusColor = Colors.green;
        break;
      case 'Pending':
        statusColor = Colors.orange;
        break;
      case 'Canceled':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: pureWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: netralColor),
        boxShadow: [
          BoxShadow(
            color: secondaryColor.withOpacity(0.8),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: CircleAvatar(
              backgroundColor: primaryColor,
              child: Text(
                'ID:${subscription.id}',
                style: const TextStyle(color: pureWhite, fontWeight: FontWeight.bold, fontSize: 10),
              ),
            ),
            title: Text(
              'User ID: ${subscription.userId}',
              style: const TextStyle(fontWeight: FontWeight.bold, color: textColor),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  'Payment Method: ${subscription.detail.paymentMethod}',
                  style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 12),
                ),
                const SizedBox(height: 2),
                Text(
                  'Paid at: ${subscription.detail.paidAt}',
                  style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 12),
                ),
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Rp ${subscription.detail.amount}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textColor),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: statusColor.withOpacity(0.3)),
                  ),
                  child: Text(
                    subscription.status,
                    style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          if (subscription.detail.invoiceUrl.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: TextButton.icon(
                icon: const Icon(Icons.receipt_long, color: primaryColor),
                label: const Text('View Invoice', style: TextStyle(color: primaryColor)),
                onPressed: () => controller.viewInvoice(subscription.detail.invoiceUrl),
                style: TextButton.styleFrom(
                  backgroundColor: secondaryColor.withOpacity(0.3),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
