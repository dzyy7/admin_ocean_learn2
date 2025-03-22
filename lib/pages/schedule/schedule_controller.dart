import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScheduleController extends GetxController {
  final Rx<DateTime> currentMonth = DateTime.now().obs;
  final RxList<DateTime> markedDates = <DateTime>[].obs;

  @override
  void onInit() {
    super.onInit();
    markedDates.addAll([
      DateTime(2025, 3, 8),
      DateTime(2025, 3, 19),
      DateTime(2025, 3, 24),
      DateTime(2025, 3, 30),
    ]);
  }

  void previousMonth() {
    currentMonth.value = DateTime(currentMonth.value.year, currentMonth.value.month - 1);
  }

  void nextMonth() {
    currentMonth.value = DateTime(currentMonth.value.year, currentMonth.value.month + 1);
  }

  void toggleDateMark(DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    
    final index = markedDates.indexWhere((d) => 
      d.year == normalizedDate.year && 
      d.month == normalizedDate.month && 
      d.day == normalizedDate.day
    );
      
    if (index >= 0) {
      markedDates.removeAt(index);
    } else {
      markedDates.add(normalizedDate);
    }
  }

  bool isDateMarked(DateTime date) {
    return markedDates.any((d) => 
      d.year == date.year && 
      d.month == date.month && 
      d.day == date.day
    );
  }

  bool isToday(DateTime date) {
    final now = DateTime.now();
    return now.year == date.year && 
           now.month == date.month && 
           now.day == date.day;
  }

  List<DateTime> getMarkedDatesForCurrentMonth() {
    return markedDates
      .where((date) => 
        date.year == currentMonth.value.year && 
        date.month == currentMonth.value.month
      )
      .toList()
      ..sort((a, b) => a.compareTo(b));
  }

  bool isDatePast(DateTime date) {
    final now = DateTime.now();
    return date.isBefore(now);
  }
}