import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:admin_ocean_learn2/model/course_model.dart';
import 'package:admin_ocean_learn2/services/course_service.dart';

class ScheduleController extends GetxController {
  final Rx<DateTime> currentMonth = DateTime.now().obs;
  final RxList<DateTime> markedDates = <DateTime>[].obs;
  final CourseService courseService = CourseService();
  final RxList<CourseModel> courses = <CourseModel>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadCourses();
  }

  Future<void> loadCourses() async {
    isLoading.value = true;
    await courseService.loadLessons(1);
    courses.value = courseService.getLessons();
    
    // Update marked dates based on course dates
    updateMarkedDates();
    
    isLoading.value = false;
  }
  
  void updateMarkedDates() {
    final newMarkedDates = <DateTime>[];
    
    for (final course in courses) {
      // Add only the date part (no time) to marked dates
      final courseDate = DateTime(course.date.year, course.date.month, course.date.day);
      newMarkedDates.add(courseDate);
    }
    
    markedDates.assignAll(newMarkedDates);
  }

  void previousMonth() {
    currentMonth.value = DateTime(currentMonth.value.year, currentMonth.value.month - 1);
  }

  void nextMonth() {
    currentMonth.value = DateTime(currentMonth.value.year, currentMonth.value.month + 1);
  }

  bool isDateMarked(DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    return markedDates.any((d) => 
      d.year == normalizedDate.year && 
      d.month == normalizedDate.month && 
      d.day == normalizedDate.day
    );
  }

  // Get course for a specific date (if exists)
  CourseModel? getCourseForDate(DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    
    for (final course in courses) {
      final courseDate = DateTime(course.date.year, course.date.month, course.date.day);
      if (courseDate.isAtSameMomentAs(normalizedDate)) {
        return course;
      }
    }
    
    return null;
  }

  bool isToday(DateTime date) {
    final now = DateTime.now();
    return now.year == date.year && 
           now.month == date.month && 
           now.day == date.day;
  }

  List<CourseModel> getCoursesForCurrentMonth() {
    return courses
      .where((course) => 
        course.date.year == currentMonth.value.year && 
        course.date.month == currentMonth.value.month
      )
      .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  bool isDatePast(DateTime date) {
    final now = DateTime.now();
    return date.isBefore(now);
  }
}