import 'package:admin_ocean_learn2/model/member_model.dart';
import 'package:admin_ocean_learn2/services/member_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MemberController extends GetxController {
  final isLoading = true.obs;
  final error = ''.obs;
  
  final members = <MemberModel>[].obs;
  final filteredMembers = <MemberModel>[].obs;
  final searchQuery = ''.obs;
  final sortBy = 'name'.obs;
  
  // Statistics
  final totalMembers = 0.obs;
  final premiumMembers = 0.obs;
  final freeMembers = 0.obs;
  final adminMembers = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMembers();
  }

  Future<void> fetchMembers() async {
  try {
    isLoading.value = true;
    error.value = '';

    final response = await MemberService.getMembers();

    if (response.status) {
      final premiumOnly = response.data.where((m) => m.accountInfo.subscription.status.toLowerCase() == 'premium').toList();
      members.value = premiumOnly;
      updateFilteredMembers();
      updateStatistics();
    } else {
      error.value = response.message;
    }
  } catch (e) {
    error.value = e.toString();
  } finally {
    isLoading.value = false;
  }
}

  void updateSearchQuery(String query) {
    searchQuery.value = query;
    updateFilteredMembers();
  }

  void updateSortBy(String sort) {
    sortBy.value = sort;
    updateFilteredMembers();
  }

  void updateFilteredMembers() {
    List<MemberModel> filtered = MemberService.filterMembers(members, searchQuery.value);
    filtered = MemberService.sortMembers(filtered, sortBy.value);
    filteredMembers.value = filtered;
  }

  void updateStatistics() {
    totalMembers.value = members.length;
    premiumMembers.value = members.where((m) => m.accountInfo.subscription.status == 'premium').length;
    freeMembers.value = members.where((m) => m.accountInfo.subscription.status == 'free').length;
    adminMembers.value = members.where((m) => m.accountInfo.role == 'admin').length;
  }

  void showMemberDetails(MemberModel member) {
    Get.dialog(
      AlertDialog(
        title: Text(member.accountInfo.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Email', member.accountInfo.email),
            _buildDetailRow('Role', member.accountInfo.role),
            _buildDetailRow('Subscription', member.accountInfo.subscription.status),
            if (member.accountInfo.emailVerifiedAt != null)
              _buildDetailRow('Verified', 'Yes'),
            if (member.id.personalId != null)
              _buildDetailRow('ID', member.id.personalId.toString()),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Color getSubscriptionColor(String status) {
    switch (status.toLowerCase()) {
      case 'premium':
        return Colors.amber;
      case 'free':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }

  Color getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return Colors.red;
      case 'student':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}