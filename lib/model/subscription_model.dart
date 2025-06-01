class SubscriptionModel {
  final int id;
  final int userId;
  final String status;
  final String uuid;
  final SubscriptionDetail detail;
  final String month;
  final String year;

  SubscriptionModel({
    required this.id,
    required this.userId,
    required this.status,
    required this.uuid,
    required this.detail,
    required this.month,
    required this.year,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    String paidAt = json['detail']['paid_at'] ?? '';
    List<String> dateParts = paidAt.split(' ');
    String month = dateParts.length >= 2 ? dateParts[1] : '';
    String year = dateParts.length >= 3 ? dateParts[2] : '';

    return SubscriptionModel(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      status: json['status'] ?? '',
      uuid: json['uuid'] ?? '',
      detail: SubscriptionDetail.fromJson(json['detail'] ?? {}),
      month: month,
      year: year,
    );
  }
}

class SubscriptionDetail {
  final String amount;
  final String paymentMethod;
  final String paidAt;
  final String invoiceUrl;

  SubscriptionDetail({
    required this.amount,
    required this.paymentMethod,
    required this.paidAt,
    required this.invoiceUrl,
  });

  factory SubscriptionDetail.fromJson(Map<String, dynamic> json) {
    return SubscriptionDetail(
      amount: json['amount'] ?? '',
      paymentMethod: json['payment_method'] ?? '',
      paidAt: json['paid_at'] ?? '',
      invoiceUrl: json['invoice_url'] ?? '',
    );
  }
}