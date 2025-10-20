import 'package:admin_ocean_learn2/widget/payment_component/payment_dashboard.dart';
import 'package:admin_ocean_learn2/widget/payment_component/payment_history.dart';
import 'package:admin_ocean_learn2/widget/payment_component/payment_search_filter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:admin_ocean_learn2/pages/payment/payment_controller.dart';
import 'package:admin_ocean_learn2/utils/color_palette.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final PaymentController controller = Get.put(PaymentController());

    return Scaffold(
      backgroundColor: netralColor,
      appBar: AppBar(
        title: const Text(
          'Payment Management',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: secondaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: pureBlack),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: pureBlack),
            onPressed: () => controller.refreshData(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: _buildPaymentPageContent(controller)),
        ],
      ),
    );
  }

  Widget _buildPaymentPageContent(PaymentController controller) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
            child: CircularProgressIndicator(color: primaryColor));
      }

      if (controller.error.isNotEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text('Error: ${controller.error.value}',
                  style: const TextStyle(color: textColor)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => controller.refreshData(),
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      }

      if (controller.months.isEmpty) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.folder_outlined, color: primaryColor, size: 48),
              SizedBox(height: 16),
              Text('No payment records found',
                  style: TextStyle(color: textColor, fontSize: 16)),
            ],
          ),
        );
      }

      return NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverToBoxAdapter(child: PaymentDashboard(controller: controller)),
          SliverPersistentHeader(
            pinned: true,
            delegate: _StickyHeaderDelegate(
              child: SearchAndFilter(controller: controller),
              minHeight: 80,
              maxHeight: 80,
            ),
          ),
        ],
        body: RefreshIndicator(
          onRefresh: () => controller.refreshData(),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.getSubscriptionsForSelectedMonth().length,
            itemBuilder: (context, index) {
              final sortedSubscriptions =
                  controller.getSubscriptionsForSelectedMonth()
                    ..sort((a, b) {
                      int getStatusPriority(String status) {
                        switch (status.toLowerCase()) {
                          case 'pending':
                            return 0; // Highest priority - needs attention
                          case 'paid':
                            return 1; // Second priority - needs confirmation
                          case 'confirmed':
                            return 2; // Third priority - completed
                          case 'failed':
                          case 'canceled':
                            return 3; // Lowest priority - failed/canceled
                          default:
                            return 4; // Unknown status
                        }
                      }

                      return getStatusPriority(a.status)
                          .compareTo(getStatusPriority(b.status));
                    });

              final sub = sortedSubscriptions[index];
              return PaymentHistory(subscription: sub, controller: controller);
            },
          ),
        ),
      );
    });
  }
}

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double minHeight;
  final double maxHeight;

  _StickyHeaderDelegate(
      {required this.child, required this.minHeight, required this.maxHeight});

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_StickyHeaderDelegate old) {
    return maxHeight != old.maxHeight ||
        minHeight != old.minHeight ||
        child != old.child;
  }
}
