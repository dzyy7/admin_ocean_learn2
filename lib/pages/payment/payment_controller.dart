import 'package:admin_ocean_learn2/model/subscription_model.dart';
import 'package:admin_ocean_learn2/model/member_model.dart';
import 'package:admin_ocean_learn2/pages/payment/invoice_page.dart';
import 'package:admin_ocean_learn2/services/subscription_service.dart';
import 'package:admin_ocean_learn2/services/member_service.dart';
import 'package:admin_ocean_learn2/utils/color_palette.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'dart:io';
import 'dart:typed_data';

class PaymentController extends GetxController {
  final isLoading = true.obs;
  final error = ''.obs;
  final isConfirming = false.obs;
  final isDownloading = false.obs;

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

  Future<bool> downloadInvoiceAsImage(
    ScreenshotController screenshotController,
    SubscriptionModel subscription,
  ) async {
    try {
      isDownloading.value = true;

      // Request storage permission
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        status = await Permission.storage.request();
        if (!status.isGranted) {
          Get.snackbar(
            'Permission Denied',
            'Storage permission is required to download invoice',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return false;
        }
      }

      // Capture screenshot
      final Uint8List? imageBytes = await screenshotController.capture();

      if (imageBytes != null) {
        // Get directory
        Directory? directory;
        if (Platform.isAndroid) {
          directory = Directory('/storage/emulated/0/Download');
          if (!await directory.exists()) {
            directory = await getExternalStorageDirectory();
          }
        } else {
          directory = await getApplicationDocumentsDirectory();
        }

        if (directory != null) {
          // Create filename with subscription info
          final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
          final String username = getUsernameFromId(subscription.userId)
              .replaceAll(' ', '_')
              .replaceAll(RegExp(r'[^\w\s]+'), '');
          final String fileName = 'invoice_${subscription.month}_${username}_$timestamp.png';
          final String filePath = '${directory.path}/$fileName';

          // Save file
          final File file = File(filePath);
          await file.writeAsBytes(imageBytes);

          Get.snackbar(
            'Download Success',
            'Invoice saved to Downloads folder',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
          );

          return true;
        }
      }

      return false;
    } catch (e) {
      Get.snackbar(
        'Download Failed',
        'Failed to save invoice: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isDownloading.value = false;
    }
  }

  void showFullScreenImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.black,
          child: Stack(
            children: [
              Center(
                child: InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 3.0,
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    httpHeaders: SubscriptionService.getImageHeaders(),
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(
                        color: primaryColor,
                      ),
                    ),
                    errorWidget: (context, url, error) => const Center(
                      child: Icon(Icons.error_outline, 
                          color: Colors.white, size: 48),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 40,
                right: 20,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 30),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        );
      },
    );
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