import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:admin_ocean_learn2/utils/user_storage.dart';

class FirebaseService {
  static Future<void> saveFcmTokenToServer() async {
    try {
      final fcmToken = await FirebaseMessaging.instance.getToken();
      print('Retrieved FCM Token: $fcmToken');

      if (fcmToken == null) {
        print(
            '⚠ FCM Token is null. Mungkin izin belum diberikan atau Firebase belum siap.');
        return;
      }

      final token = UserStorage.getToken();
      print('Retrieved JWT Token: $token');

      if (token == null) {
        print('⚠ JWT token is null. Pastikan sudah login dan token disimpan.');
        return;
      }

      final response = await http.post(
        Uri.parse('https://ocean-learn-api.rplrus.com/api/v1/user/fcm-token'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'token': fcmToken}),
      );

      print('✅ FCM Token sent. Status Code: ${response.statusCode}');
      print('Response body: ${response.body}');
    } catch (e) {
      print('❌ Failed to send FCM token: $e');
    }
  }
}