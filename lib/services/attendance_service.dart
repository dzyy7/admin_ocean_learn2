import 'dart:convert';
import 'package:admin_ocean_learn2/model/attendance_model.dart';
import 'package:admin_ocean_learn2/model/member_model.dart';
import 'package:admin_ocean_learn2/services/member_service.dart';
import 'package:admin_ocean_learn2/utils/user_storage.dart';
import 'package:http/http.dart' as http;

class AttendanceService {
  static const String baseUrl = 'https://ocean-learn-api.rplrus.com/api/v1/admin';

  static Future<AttendanceResponseModel> getAttendance(String courseId) async {
    try {
      final token = UserStorage.getToken();
      if (token == null) {
        return AttendanceResponseModel(
          status: false,
          date: '',
          data: [],
        );
      }

      final response = await http.get(
        Uri.parse('$baseUrl/attendence/$courseId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final attendanceResponse = AttendanceResponseModel.fromJson(jsonDecode(response.body));
        
        // Get member data to convert user IDs to usernames
        final memberResponse = await MemberService.getMembers();
        if (memberResponse.status && memberResponse.data.isNotEmpty) {
          // Create a map of user ID to username for faster lookup
          final userIdToNameMap = <int, String>{};
          for (final member in memberResponse.data) {
            if (member.id.personalId != null) {
              userIdToNameMap[member.id.personalId!] = member.accountInfo.name;
            }
          }
          
          // Update attendance records with usernames
          for (final attendance in attendanceResponse.data) {
            attendance.userName = userIdToNameMap[attendance.userId] ?? 'Unknown User';
          }
        }
        
        return attendanceResponse;
      } else {
        return AttendanceResponseModel(
          status: false,
          date: '',
          data: [],
        );
      }
    } catch (e) {
      print('Error fetching attendance: $e');
      return AttendanceResponseModel(
        status: false,
        date: '',
        data: [],
      );
    }
  }
}