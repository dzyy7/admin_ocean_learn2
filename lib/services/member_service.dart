import 'package:admin_ocean_learn2/model/member_model.dart';
import 'package:admin_ocean_learn2/utils/user_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class MemberService {
  static const String baseUrl = 'https://ocean-learn-api.rplrus.com/api/v1';

  static Future<MemberResponseModel> getMembers() async {
    try {
      final token = UserStorage.getToken();
      if (token == null) {
        return MemberResponseModel(
          status: false,
          message: 'No authentication token found',
          data: [],
        );
      }

      final response = await http.get(
        Uri.parse('$baseUrl/admin/index'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return MemberResponseModel.fromJson(jsonDecode(response.body));
      } else {
        return MemberResponseModel(
          status: false,
          message: 'Failed to fetch members: ${response.statusCode}',
          data: [],
        );
      }
    } on TimeoutException {
      return MemberResponseModel(
        status: false,
        message: 'Connection timeout. Please check your internet connection.',
        data: [],
      );
    } catch (e) {
      return MemberResponseModel(
        status: false,
        message: 'An unexpected error occurred: ${e.toString()}',
        data: [],
      );
    }
  }

  static List<MemberModel> filterMembers(List<MemberModel> members, String query) {
    if (query.isEmpty) return members;
    
    return members.where((member) {
      return member.accountInfo.name.toLowerCase().contains(query.toLowerCase()) ||
             member.accountInfo.email.toLowerCase().contains(query.toLowerCase()) ||
             member.accountInfo.role.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  static List<MemberModel> sortMembers(List<MemberModel> members, String sortBy) {
    List<MemberModel> sortedMembers = List.from(members);
    
    switch (sortBy) {
      case 'name':
        sortedMembers.sort((a, b) => a.accountInfo.name.compareTo(b.accountInfo.name));
        break;
      case 'email':
        sortedMembers.sort((a, b) => a.accountInfo.email.compareTo(b.accountInfo.email));
        break;
      case 'role':
        sortedMembers.sort((a, b) => a.accountInfo.role.compareTo(b.accountInfo.role));
        break;
      case 'subscription':
        sortedMembers.sort((a, b) => a.accountInfo.subscription.status.compareTo(b.accountInfo.subscription.status));
        break;
      default:
        break;
    }
    
    return sortedMembers;
  }
}