import 'package:admin_ocean_learn2/widget/payment_component/invoice_component/invoice_header.dart';
import 'package:admin_ocean_learn2/widget/payment_component/invoice_component/invoice_illustration.dart';
import 'package:admin_ocean_learn2/widget/payment_component/invoice_component/payment_method_selector.dart';
import 'package:admin_ocean_learn2/widget/payment_component/invoice_component/subscription_detail.dart';
import 'package:admin_ocean_learn2/widget/payment_component/invoice_component/thank_button.dart';
import 'package:admin_ocean_learn2/widget/payment_component/invoice_component/transfer_proof.dart';
import 'package:flutter/material.dart';
import 'package:admin_ocean_learn2/model/subscription_model.dart';
import 'package:admin_ocean_learn2/pages/payment/payment_controller.dart';
import 'package:admin_ocean_learn2/utils/color_palette.dart';
import 'package:google_fonts/google_fonts.dart';

class InvoicePage extends StatelessWidget {
  final SubscriptionModel subscription;
  final PaymentController controller;

  const InvoicePage({
    Key? key,
    required this.subscription,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: netralColor,
      appBar: AppBar(
        title: const Text(
          'Invoice Details',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: netralColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: pureBlack),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: pureWhite,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  InvoiceHeader(subscription: subscription),
                  const SizedBox(height: 32),
                  InvoiceIllustration(
                    paymentMethod: subscription.detail.paymentMethod,
                  ),
                  SubscriptionDetails(
                    subscription: subscription,
                    controller: controller,
                  ),
                  PaymentMethodSelector(
                    paymentMethod: subscription.detail.paymentMethod,
                  ),
                  TransferProofSection(
                    subscription: subscription,
                    controller: controller,
                  ),
                  ThankYouButton(
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}