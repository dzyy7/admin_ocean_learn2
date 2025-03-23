import 'package:flutter/material.dart';

class PaymentHistoryModel {
  final String id;
  final String name;
  final String amount;
  final String date;
  final String status;
  final Color statusColor;

  PaymentHistoryModel({
    required this.id,
    required this.name,
    required this.amount,
    required this.date,
    required this.status,
    required this.statusColor,
  });
}
