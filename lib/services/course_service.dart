import 'dart:convert';
import 'package:admin_ocean_learn2/model/course_model.dart';
import 'package:admin_ocean_learn2/pages/login/login_controller.dart';
import 'package:admin_ocean_learn2/utils/user_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class CourseService {
  static const String baseUrl = 'https://ocean-learn-api.rplrus.com/api/v1';
  List<CourseModel> _courses = [];

  // Pagination metadata
  int _currentPage = 1;
  int _totalPages = 1;

  // Getters for pagination info
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;

  String? getToken() {
    return UserStorage.getToken();
  }

  // Load courses from API with pagination
  Future<void> loadLessons(int page) async {
    final token = getToken();
    if (token == null) return;

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/course?page=$page'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['status'] == true && jsonData['data'] != null) {
          _courses = (jsonData['data'] as List)
              .map((courseJson) => CourseModel.fromApiJson(courseJson))
              .toList();

          // Update pagination info
          _currentPage = jsonData['meta']['current_page'] ?? page;
          _totalPages = jsonData['meta']['last_page'] ?? 1;
        }
      } else if (response.statusCode == 401) {
        print('Unauthorized access. Token may be expired.');
        LoginController().logout();
      } else {
        print('Failed to load courses: ${response.body}');
      }
    } catch (e) {
      print('Error loading courses: $e');
    }
  }

  // Get stored courses
  List<CourseModel> getLessons() {
    return _courses;
  }

  Future<CourseModel?> createLesson(
      String title, String description, String url, DateTime classDate) async {
    final token = getToken();

    if (token == null) {
      print('Token is null');
      return null;
    }

    // Check if a lesson already exists in this week
    if (isLessonExistInWeek(classDate)) {
      print('A lesson already exists in this week. Cannot create another.');
      return null;
    }

    final requestBody = {
      'title': title,
      'description': description,
      'video_url': url,
      'date': DateFormat('yyyy-MM-dd HH:mm').format(classDate),
    };

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/course'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final courseData = jsonData['data'];
        if (courseData != null) {
          final newCourse = CourseModel.fromApiJson(courseData);
          _courses.add(newCourse);
          return newCourse;
        }
      } else {
        print('Failed to create: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error creating course: $e');
    }

    return null;
  }

  Future<bool> updateNote(String courseId, String note) async {
    final token = getToken();
    if (token == null) return false;

    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/course/$courseId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'note': note,
        }),
      );

      if (response.statusCode == 200) {
        int courseIndex =
            _courses.indexWhere((course) => course.id == courseId);
        if (courseIndex != -1) {}
        return true;
      }
    } catch (e) {
      print('Error updating note: $e');
    }
    return false;
  }

  Future<bool> updateLesson({
    required String courseId,
    required String title,
    required String description,
    required String videoUrl,
    required DateTime date,
  }) async {
    final token = getToken();
    if (token == null) return false;

    // Check if another lesson exists in this week (except this course)
    if (isLessonExistInWeek(date, excludeCourseId: courseId)) {
      print('Another lesson already exists in this week. Cannot update.');
      return false;
    }

    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/course/$courseId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'title': title,
          'description': description,
          'video_url': videoUrl,
          'date': DateFormat('yyyy-MM-dd HH:mm').format(date),
        }),
      );

      if (response.statusCode == 200) {
        final index = _courses.indexWhere((c) => c.id == courseId);
        if (index != -1) {
          _courses[index] = CourseModel(
            id: courseId,
            title: title,
            description: description,
            videoUrl: videoUrl,
            date: date,
            qrCode: _courses[index].qrCode,
            qrEndDate: _courses[index].qrEndDate,
            note: _courses[index].note,
          );
        }
        return true;
      }
    } catch (e) {
      print('Error updating course: $e');
    }

    return false;
  }

  Future<bool> deleteLesson(String courseId) async {
    final token = getToken();
    if (token == null) return false;

    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/course/$courseId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        _courses.removeWhere((course) => course.id == courseId);
        return true;
      }
    } catch (e) {
      print('Error deleting course: $e');
    }
    return false;
  }

  Future<CourseModel?> getCourseDetail(String courseId) async {
    final token = getToken();
    if (token == null) return null;

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/course/$courseId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['status'] == true && jsonData['data'] != null) {
          return CourseModel.fromApiJson(jsonData['data']);
        }
      }
    } catch (e) {
      print('Error getting course detail: $e');
    }
    return null;
  }

  bool isInSameWeek(DateTime date1, DateTime date2) {
    final startOfWeek1 = date1.subtract(Duration(days: date1.weekday - 1));
    final startOfWeek2 = date2.subtract(Duration(days: date2.weekday - 1));
    return startOfWeek1.year == startOfWeek2.year &&
        startOfWeek1.month == startOfWeek2.month &&
        startOfWeek1.day == startOfWeek2.day;
  }

  bool isLessonExistInWeek(DateTime dateToCheck, {String? excludeCourseId}) {
    return _courses.any((course) {
      if (excludeCourseId != null && course.id == excludeCourseId) {
        return false;
      }
      return isInSameWeek(course.date, dateToCheck);
    });
  }

  Future<bool> isUserAdmin() async {
    final role = UserStorage.getRole() ?? '';
    return role.toLowerCase() == 'admin';
  }
}