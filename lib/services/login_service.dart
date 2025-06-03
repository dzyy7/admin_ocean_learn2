import 'package:admin_ocean_learn2/model/login_service_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class LoginService {
  static Future<LoginResponseModel> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('https://ocean-learn-api.rplrus.com/api/v1/admin/auth'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      ).timeout(const Duration(seconds: 10));

      return LoginResponseModel.fromJson(jsonDecode(response.body));
    } on TimeoutException {
      return LoginResponseModel(
        status: false,
        message: 'Connection timeout. Please check your internet connection.',
      );
    } catch (_) {
      return LoginResponseModel(
        status: false,
        message: 'An unexpected error occurred.',
      );
    }
  }

  static Future<Map<String, dynamic>> logout(String token) async {
    try {
      final response = await http.post(
        Uri.parse('https://ocean-learn-api.rplrus.com/api/v1/user/logout'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10));

      final jsonResponse = jsonDecode(response.body);

      return {
        'success': jsonResponse['status'] == true,
        'message': jsonResponse['message'] ?? 'Logout response received',
      };
    } on TimeoutException {
      return {'success': false, 'message': 'Timeout during logout'};
    } catch (_) {
      return {'success': false, 'message': 'Unexpected error during logout'};
    }
  }
}
