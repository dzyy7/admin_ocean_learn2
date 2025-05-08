import 'package:admin_ocean_learn2/model/subscription_model.dart';
import 'package:admin_ocean_learn2/services/subscription_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentController extends GetxController {
  final isLoading = true.obs;
  final error = ''.obs;

  // All subscriptions
  final subscriptions = <SubscriptionModel>[].obs;

  // Subscriptions grouped by month
  final subscriptionsByMonth = <String, List<SubscriptionModel>>{}.obs;

  // For filtering
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

      // Get all subscriptions
      final allSubscriptions = await SubscriptionService.getSubscriptions();
      subscriptions.value = allSubscriptions;

      // Get subscriptions by month
      final groupedSubscriptions =
          await SubscriptionService.getSubscriptionsByMonth();
      subscriptionsByMonth.value = groupedSubscriptions;

      // Extract available months
      months.value = groupedSubscriptions.keys.toList();

      // Set selected month to the most recent one if available
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
    if (invoiceUrl.isEmpty) {
      Get.snackbar(
        'Error',
        'Invoice URL is not available',
        backgroundColor: Colors.orange,
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
}
