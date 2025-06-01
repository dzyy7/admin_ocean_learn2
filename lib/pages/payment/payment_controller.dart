import 'package:admin_ocean_learn2/model/subscription_model.dart';
import 'package:admin_ocean_learn2/services/subscription_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentController extends GetxController {
  final isLoading = true.obs;
  final error = ''.obs;
  final isConfirming = false.obs;

  final subscriptions = <SubscriptionModel>[].obs;
  final subscriptionsByMonth = <String, List<SubscriptionModel>>{}.obs;

  final selectedMonth = ''.obs;
  final months = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchSubscriptions();
  }

  Future<void> fetchSubscriptions() async {
    try {
      isLoading.value = true;
      error.value = '';

      final allSubscriptions = await SubscriptionService.getSubscriptions();
      subscriptions.value = allSubscriptions;

      final groupedSubscriptions =
          await SubscriptionService.getSubscriptionsByMonth();
      subscriptionsByMonth.value = groupedSubscriptions;

      months.value = groupedSubscriptions.keys.toList();

      if (months.isNotEmpty) {
        selectedMonth.value = months.first;
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void changeSelectedMonth(String month) {
    selectedMonth.value = month;
  }

  List<SubscriptionModel> getSubscriptionsForSelectedMonth() {
    if (selectedMonth.isEmpty ||
        !subscriptionsByMonth.containsKey(selectedMonth.value)) {
      return [];
    }
    return subscriptionsByMonth[selectedMonth.value] ?? [];
  }

  void viewInvoice(String invoiceUrl) async {
    if (invoiceUrl.isEmpty || invoiceUrl == "offline payment") {
      Get.snackbar(
        'Info',
        'This is an offline payment - no invoice URL available',
        backgroundColor: Colors.blue,
        colorText: Colors.white,
      );
      return;
    }

    final Uri url = Uri.parse(invoiceUrl);
    final success = await launchUrl(url, mode: LaunchMode.externalApplication);
    if (!success) {
      Get.snackbar(
        'Error',
        'Could not open invoice URL',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> confirmCashPayment(SubscriptionModel subscription) async {
    try {
      // Show confirmation dialog
      bool? shouldConfirm = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('Confirm Payment'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Are you sure you want to confirm this cash payment?'),
              const SizedBox(height: 8),
              Text('User ID: ${subscription.userId}', style: const TextStyle(fontWeight: FontWeight.bold)),
              Text('Amount: Rp ${subscription.detail.amount}', style: const TextStyle(fontWeight: FontWeight.bold)),
              Text('Payment Method: ${subscription.detail.paymentMethod}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Get.back(result: true),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text('Confirm', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );

      if (shouldConfirm != true) return;

      isConfirming.value = true;

      final success = await SubscriptionService.confirmCashPayment(subscription.uuid);
      
      if (success) {
        Get.snackbar(
          'Success',
          'Payment confirmed successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        
        // Refresh the data
        await fetchSubscriptions();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to confirm payment: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isConfirming.value = false;
    }
  }
}