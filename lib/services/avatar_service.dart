import 'package:admin_ocean_learn2/utils/user_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';

class AvatarService {
  static const String baseUrl = ' https://api.momentumoceanlearn.com/api/v1';

  static String getAvatarUrl(String? avatar) {
    if (avatar == null || avatar.isEmpty) return '';
    return '$baseUrl/$avatar';
  }

  static Future<Uint8List?> getAvatarBytes(String? avatar) async {
    if (avatar == null || avatar.isEmpty) return null;
    
    try {
      final token = UserStorage.getToken();
      if (token == null) return null;

      final response = await http.get(
        Uri.parse(getAvatarUrl(avatar)),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return response.bodyBytes;
      }
      return null;
    } catch (e) {
      print('Error fetching avatar: $e');
      return null;
    }
  }

  static Map<String, String> getAuthHeaders() {
    final token = UserStorage.getToken();
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }
}