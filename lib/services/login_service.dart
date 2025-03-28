import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class LoginService {
  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('https://ocean-learn-api.rplrus.com/api/v1/user/auth'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw TimeoutException('Connection timeout'),
      );

      final responseBody = jsonDecode(response.body);

      if (responseBody['status'] == true) {
        // Extract token from the nested structure
        final token = responseBody['data']['account_info']['token'][0]['token'];
        
        return {
          'success': true,
          'data': {
            'token': token,
            'user': responseBody['data']['account_info']
          },
        };
      } else {
        return {
          'success': false,
          'message': responseBody['message'] ?? 'Login failed. Please check your credentials.',
        };
      }
    } on TimeoutException {
      return {
        'success': false,
        'message': 'Connection timeout. Please check your internet connection.',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An unexpected error occurred. Please try again.',
      };
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
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw TimeoutException('Connection timeout'),
      );

      final responseBody = jsonDecode(response.body);

      if (responseBody['status'] == true) {
        return {
          'success': true,
          'message': responseBody['message'] ?? 'Logged out successfully',
        };
      } else {
        return {
          'success': false,
          'message': responseBody['message'] ?? 'Logout failed. Please try again.',
        };
      }
    } on TimeoutException {
      return {
        'success': false,
        'message': 'Connection timeout. Please check your internet connection.',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An unexpected error occurred during logout.',
      };
    }
  }
}