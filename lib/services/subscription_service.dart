import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:admin_ocean_learn2/model/subscription_model.dart';
import 'package:admin_ocean_learn2/utils/user_storage.dart';

class SubscriptionService {
  static const String baseUrl = 'https://ocean-learn-api.rplrus.com/api/v1/admin';
  
  static Future<List<SubscriptionModel>> getSubscriptions() async {
    try {
      final token = UserStorage.getToken();
      if (token == null) {
        throw Exception('User not authenticated');
      }
      
      final response = await http.get(
        Uri.parse('$baseUrl/subscription/index'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
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

  // Updated method to handle both cash and transfer payments
  static Future<bool> confirmPayment(String externalId, String paymentMethod) async {
    try {
      final token = UserStorage.getToken();
      if (token == null) {
        throw Exception('User not authenticated');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/subscription/confirm'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'external_id': externalId,
          'payment_method': paymentMethod, // 'cash' or 'transfer'
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

  // Backward compatibility - redirect to confirmPayment
  static Future<bool> confirmCashPayment(String externalId, String paymentMethod) async {
    return await confirmPayment(externalId, 'cash');
  }

  // New method for transfer confirmation
  static Future<bool> confirmTransferPayment(String externalId) async {
    return await confirmPayment(externalId, 'transfer');
  }
}