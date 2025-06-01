import 'package:admin_ocean_learn2/model/subscription_model.dart';
import 'package:flutter/material.dart';
import 'package:admin_ocean_learn2/utils/color_palette.dart';
import 'package:admin_ocean_learn2/pages/payment/payment_controller.dart';
import 'package:get/get.dart';

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

    bool isCashPayment = subscription.detail.paymentMethod.toLowerCase() == 'cash';
    bool isPending = subscription.status == 'Pending';

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
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Payment Method: ${subscription.detail.paymentMethod}',
                        style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 12),
                      ),
                    ),
                    if (isCashPayment) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue.withOpacity(0.3)),
                        ),
                        child: const Text(
                          'CASH',
                          style: TextStyle(color: Colors.blue, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ],
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                if (subscription.detail.invoiceUrl.isNotEmpty && subscription.detail.invoiceUrl != "offline payment")
                  Expanded(
                    flex: 1,
                    child: TextButton.icon(
                      icon: const Icon(Icons.receipt_long, color: primaryColor, size: 16),
                      label: const Text('Invoice', style: TextStyle(color: primaryColor, fontSize: 12)),
                      onPressed: () => controller.viewInvoice(subscription.detail.invoiceUrl),
                      style: TextButton.styleFrom(
                        backgroundColor: secondaryColor.withOpacity(0.3),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                
                if (subscription.detail.invoiceUrl.isNotEmpty && 
                    subscription.detail.invoiceUrl != "offline payment" && 
                    isCashPayment && isPending)
                  const SizedBox(width: 8),
                
                if (isCashPayment && isPending)
                  Expanded(
                    flex: 1,
                    child: Obx(() => ElevatedButton.icon(
                      icon: controller.isConfirming.value 
                          ? const SizedBox(
                              width: 12,
                              height: 12,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Icon(Icons.check_circle, color: Colors.white, size: 16),
                      label: Text(
                        controller.isConfirming.value ? 'Confirming...' : 'Confirm',
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      onPressed: controller.isConfirming.value 
                          ? null 
                          : () => controller.confirmCashPayment(subscription),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    )),
                  ),

                if (isCashPayment && subscription.detail.invoiceUrl == "offline payment" && !isPending)
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.info_outline, color: Colors.grey, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            'Offline Payment',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}