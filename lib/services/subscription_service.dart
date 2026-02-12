import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:admin_ocean_learn2/model/subscription_model.dart';
import 'package:admin_ocean_learn2/utils/user_storage.dart';

class SubscriptionService {
  static const String baseUrl = 'https://api.momentumoceanlearn.com/api/v1';
  
  // Helper method to get headers with authorization
  static Map<String, String> _getAuthHeaders() {
    final token = UserStorage.getToken();
    if (token == null) {
      throw Exception('User not authenticated');
    }
    
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }
  
  static Map<String, String> _getImageHeaders() {
    final token = UserStorage.getToken();
    if (token == null) {
      throw Exception('User not authenticated');
    }
    
    return {
      'Authorization': 'Bearer $token',
    };
  }
  
  static Future<List<SubscriptionModel>> getSubscriptions() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/admin/subscription/index'),
        headers: _getAuthHeaders(),
      );
                                                                    
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => SubscriptionModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load subscriptions: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching subscriptions: $e');
    }
  }
  
  static Future<Map<String, List<SubscriptionModel>>> getSubscriptionsByMonth() async {
    try {
      final subscriptions = await getSubscriptions();
      final Map<String, List<SubscriptionModel>> result = {};

      for (var subscription in subscriptions) {
        final monthNumber = _monthNameToNumber(subscription.month);
        final key = '${subscription.year}-${monthNumber.toString().padLeft(2, '0')}';

        if (!result.containsKey(key)) {
          result[key] = [];
        }
        result[key]!.add(subscription);
      }

      final sortedKeys = result.keys.toList()..sort((a, b) => b.compareTo(a));

      final sortedResult = <String, List<SubscriptionModel>>{};
      for (var key in sortedKeys) {
        sortedResult[key] = result[key]!;
      }

      return sortedResult;
    } catch (e) {
      throw Exception('Error grouping subscriptions: $e');
    }
  }

  static int _monthNameToNumber(String monthName) {
    const months = {
      'January': 1,
      'February': 2,
      'March': 3,
      'April': 4,
      'May': 5,
      'June': 6,
      'July': 7,
      'August': 8,
      'September': 9,
      'October': 10,
      'November': 11,
      'December': 12,
    };

    return months[monthName] ?? 0;
  }

  static Future<bool> confirmPayment(String externalId, String paymentMethod) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/admin/subscription/confirm'),
        headers: _getAuthHeaders(),
        body: json.encode({
          'external_id': externalId,
          'payment_method': paymentMethod, 
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to confirm payment: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error confirming payment: $e');
    }
  }

  static Future<bool> confirmCashPayment(String externalId, String paymentMethod) async {
    return await confirmPayment(externalId, 'cash');
  }

  static Future<bool> confirmTransferPayment(String externalId) async {
    return await confirmPayment(externalId, 'transfer');
  }

  static Future<http.Response> getProofImage(String proofPath) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$proofPath'),
        headers: _getImageHeaders(),
      );
      
      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception('Failed to load proof image: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching proof image: $e');
    }
  }

  static String getProofUrl(String proofPath) {
    return '$baseUrl/$proofPath';
  }

  static Map<String, String> getImageHeaders() {
    return _getImageHeaders();
  }

  static bool hasProof(String? proofPath) {
    return proofPath != null && proofPath.isNotEmpty;
  }

  static String? getProofUrlFromSubscription(SubscriptionModel subscription) {
    if (subscription.detail.proof == null || subscription.detail.proof!.isEmpty) {
      return null;
    }
    return getProofUrl(subscription.detail.proof!);
  }
}