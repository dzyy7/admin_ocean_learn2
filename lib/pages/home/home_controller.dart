import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:admin_ocean_learn2/services/course_service.dart';
import 'package:admin_ocean_learn2/model/course_model.dart';
import 'package:admin_ocean_learn2/utils/user_storage.dart';
import 'package:admin_ocean_learn2/pages/login/login_controller.dart';

class HomeController extends GetxController {
  final CourseService courseService = CourseService();

  var name = ''.obs;
  var isLoading = true.obs;
  var isLoadingMore = false.obs;
  var courses = <CourseModel>[].obs;
  var searchQuery = ''.obs;
  var sortByNewest = true.obs;

  List<CourseModel> get filteredCourses {
    var filtered = courses.where((course) =>
        course.title.toLowerCase().contains(searchQuery.value.toLowerCase())).toList();

    filtered.sort((a, b) => sortByNewest.value
        ? b.date.compareTo(a.date)
        : a.date.compareTo(b.date));

    return filtered;
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  void toggleSortOrder() {
    sortByNewest.value = !sortByNewest.value;
  }


  @override
  void onInit() {
    super.onInit();
    loadUserName();
    loadInitialCourses();
  }


  Future<void> loadUserName() async {
    String? userName = UserStorage.getName();
    
    if (userName == null || userName.isEmpty) {
      userName = LoginController.getSessionName();
    }
    
    name.value = userName ?? '';
  }
  
  Future<void> loadInitialCourses() async {
    isLoading.value = true;
    await courseService.loadLessons(1);

    final sorted = courseService.getLessons()
      ..sort((a, b) => b.date.compareTo(a.date)); 

    courses.assignAll(sorted);
    isLoading.value = false;
  }
}