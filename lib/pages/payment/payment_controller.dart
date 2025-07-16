import 'package:admin_ocean_learn2/model/subscription_model.dart';
import 'package:admin_ocean_learn2/model/member_model.dart';
import 'package:admin_ocean_learn2/pages/payment/invoice_page.dart';
import 'package:admin_ocean_learn2/services/subscription_service.dart';
import 'package:admin_ocean_learn2/services/member_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentController extends GetxController {
  final isLoading = true.obs;
  final error = ''.obs;
  final isConfirming = false.obs;

  final subscriptions = <SubscriptionModel>[].obs;
  final subscriptionsByMonth = <String, List<SubscriptionModel>>{}.obs;
  final members = <MemberModel>[].obs;

  final selectedMonth = ''.obs;
  final months = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      isLoading.value = true;
      error.value = '';

      await Future.wait([
        fetchSubscriptions(),
        fetchMembers(),
      ]);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchSubscriptions() async {
    try {
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
      throw Exception('Error fetching subscriptions: $e');
    }
    print("Available months: ${months.value}");
  }

  Future<void> fetchMembers() async {
    try {
      final response = await MemberService.getMembers();
      if (response.status) {
        members.value = response.data;
      } else {
        throw Exception('Failed to fetch members: ${response.message}');
      }
    } catch (e) {
      throw Exception('Error fetching members: $e');
    }
  }

  String getUsernameFromId(int userId) {
    try {
      final member = members.firstWhere(
        (member) => member.id.personalId == userId,
      );
      return member.accountInfo.name;
    } catch (e) {
      return 'Unknown User';
    }
  }

  String getUserEmailFromId(int userId) {
    try {
      final member = members.firstWhere(
        (member) => member.id.personalId == userId,
      );
      return member.accountInfo.email;
    } catch (e) {
      return 'Unknown Email';
    }
  }

  String getUserRoleFromId(int userId) {
    try {
      final member = members.firstWhere(
        (member) => member.id.personalId == userId,
      );
      return member.accountInfo.role;
    } catch (e) {
      return 'Unknown Role';
    }
  }

  MemberModel? getMemberFromId(int userId) {
    try {
      return members.firstWhere(
        (member) => member.id.personalId == userId,
      );
    } catch (e) {
      return null;
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

  void viewInvoice(SubscriptionModel subscription) {
  final paymentMethod = subscription.detail.paymentMethod.toLowerCase();

  if (paymentMethod == 'cash' || paymentMethod == 'transfer') {
    Get.to(
      () => InvoicePage(
        subscription: subscription,
        controller: this,
      ),
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 300),
    );
  } else {
    Get.snackbar(
      'Info',
      'Online invoice view is disabled in this version.',
      backgroundColor: Colors.grey,
      colorText: Colors.white,
    );
  }
}


  Future<void> confirmPayment(SubscriptionModel subscription) async {
    try {
      final username = getUsernameFromId(subscription.userId);
      final paymentMethod = subscription.detail.paymentMethod;

      bool? shouldConfirm = await Get.dialog<bool>(
        AlertDialog(
          title: Text('Confirm ${paymentMethod.toUpperCase()} Payment'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  'Are you sure you want to confirm this ${paymentMethod} payment?'),
              const SizedBox(height: 8),
              Text('Username: $username',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              Text('Amount: Rp ${subscription.detail.amount}',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              Text('Payment Method: ${paymentMethod.toUpperCase()}'),
              if (paymentMethod.toLowerCase() == 'transfer') ...[
                const SizedBox(height: 8),
                const Text(
                    'Note: Please verify the transfer receipt before confirming.',
                    style: TextStyle(color: Colors.orange, fontSize: 12)),
              ],
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
              child:
                  const Text('Confirm', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );

      if (shouldConfirm != true) return;

      isConfirming.value = true;

      final success = await SubscriptionService.confirmPayment(
        subscription.uuid,
        paymentMethod.toLowerCase(),
      );

      if (success) {
        Get.snackbar(
          'Success',
          '${paymentMethod.toUpperCase()} payment confirmed successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        await fetchData();
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

  Future<void> confirmCashPayment(SubscriptionModel subscription) async {
    await confirmPayment(subscription);
  }

  Future<void> confirmTransferPayment(SubscriptionModel subscription) async {
    await confirmPayment(subscription);
  }

  Future<void> refreshData() async {
    await fetchData();
  }
}
