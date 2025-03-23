import 'package:admin_ocean_learn2/model/payment_history_model.dart';
import 'package:admin_ocean_learn2/utils/color_palette.dart';
import 'package:flutter/material.dart';

class PaymentHistoryTab extends StatelessWidget {
  const PaymentHistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    final List<PaymentHistoryModel> paymentHistory = [
      PaymentHistoryModel(
        id: 'INV-001',
        name: 'Samudra',
        amount: 'Rp 150,000',
        date: 'March 5, 2025',
        status: 'Completed',
        statusColor: Colors.green,
      ),
      PaymentHistoryModel(
        id: 'INV-002',
        name: 'Oceana',
        amount: 'Rp 200,000',
        date: 'March 3, 2025',
        status: 'Pending',
        statusColor: Colors.orange,
      ),
      PaymentHistoryModel(
        id: 'INV-003',
        name: 'Marine',
        amount: 'Rp 100,000',
        date: 'March 1, 2025',
        status: 'Completed',
        statusColor: Colors.green,
      ),
    ];

    return Container(
      color: pureWhite,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search invoice or customer',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: paymentHistory.length,
              itemBuilder: (context, index) {
                final payment = paymentHistory[index];
                return _buildPaymentHistoryItem(payment);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentHistoryItem(PaymentHistoryModel payment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: primaryColor.withOpacity(0.1),
          child: Text(
            payment.name[0],
            style: TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          payment.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              payment.id,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              payment.date,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              payment.amount,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: payment.statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                payment.status,
                style: TextStyle(
                  color: payment.statusColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}