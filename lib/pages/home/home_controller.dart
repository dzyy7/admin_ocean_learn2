import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:admin_ocean_learn2/services/course_service.dart';
import 'package:admin_ocean_learn2/model/course_model.dart';

class HomeController extends GetxController {
  final CourseService courseService = CourseService();

  var name = ''.obs;
  var isLoading = true.obs;
  var isLoadingMore = false.obs;
  var lessons = <CourseModel>[].obs;
  final scrollController = ScrollController();
  var searchQuery = ''.obs;
var sortByNewest = true.obs;

List<CourseModel> get filteredLessons {
  var filtered = lessons.where((lesson) =>
      lesson.title.toLowerCase().contains(searchQuery.value.toLowerCase())).toList();

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
    loadInitialLessons();
    scrollController.addListener(_scrollListener);
  }

  @override
  void onClose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.onClose();
  }

  Future<void> loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    name.value = prefs.getString('name') ?? '';
  }

  Future<void> loadInitialLessons() async {
    isLoading.value = true;
    await courseService.loadLessons(1);
    lessons.assignAll(courseService.getLessons());
    isLoading.value = false;
  }

  Future<void> loadMoreLessons() async {
    if (isLoadingMore.value) return;

    isLoadingMore.value = true;
    final hasMore = await courseService.loadMoreLessons();
    if (hasMore) {
      lessons.assignAll(courseService.getLessons());
    }
    isLoadingMore.value = false;
  }

  void _scrollListener() {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200 &&
        !isLoadingMore.value &&
        courseService.hasNextPage) {
      loadMoreLessons();
    }
  }
}
