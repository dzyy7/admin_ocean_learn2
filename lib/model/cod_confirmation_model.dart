import 'package:flutter/material.dart';

class CashConfirmationModel {
  final String id;
  final String name;
  final String amount;
  final String date;
  final String status;

  CashConfirmationModel({
    required this.id,
    required this.name,
    required this.amount,
    required this.date,
    required this.status,
  });
}
