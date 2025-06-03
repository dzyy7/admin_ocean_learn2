import 'package:admin_ocean_learn2/pages/member/member_controller.dart';
import 'package:admin_ocean_learn2/utils/color_palette.dart';
import 'package:admin_ocean_learn2/widget/member_component/member_card.dart';
import 'package:admin_ocean_learn2/widget/member_component/member_statistics.dart';
import 'package:admin_ocean_learn2/widget/member_component/member_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MemberPage extends StatelessWidget {
  const MemberPage({super.key});

  @override
  Widget build(BuildContext context) {
    final MemberController controller = Get.put(MemberController());

    return Scaffold(
      backgroundColor: netralColor,
      appBar: AppBar(
        title: const Text(
          'Member Management',
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
            onPressed: () => controller.fetchMembers(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: _buildMemberPageContent(controller)),
        ],
      ),
    );
  }

  Widget _buildMemberPageContent(MemberController controller) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator(color: primaryColor));
      }

      if (controller.error.isNotEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text('Error: ${controller.error.value}', style: const TextStyle(color: textColor)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => controller.fetchMembers(),
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      }

      if (controller.members.isEmpty) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.people_outline, color: primaryColor, size: 48),
              SizedBox(height: 16),
              Text('No members found', style: TextStyle(color: textColor, fontSize: 16)),
            ],
          ),
        );
      }

      return NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverToBoxAdapter(child: MemberStatistics(controller: controller)),
          SliverPersistentHeader(
            pinned: true,
            delegate: _StickyHeaderDelegate(
              child: MemberSearchFilter(controller: controller),
              minHeight: 144,
              maxHeight: 144,
            ),
          ),
        ],
        body: RefreshIndicator(
          onRefresh: () => controller.fetchMembers(),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.filteredMembers.length,
            itemBuilder: (context, index) {
              final member = controller.filteredMembers[index];
              return MemberCard(member: member, controller: controller);
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

  _StickyHeaderDelegate({required this.child, required this.minHeight, required this.maxHeight});

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_StickyHeaderDelegate old) {
    return maxHeight != old.maxHeight || minHeight != old.minHeight || child != old.child;
  }
}