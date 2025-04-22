import 'dart:convert';
import 'package:admin_ocean_learn2/pages/course_page/course_model.dart';
import 'package:admin_ocean_learn2/pages/login/login_controller.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CourseService {
  static const String baseUrl = 'https://ocean-learn-api.rplrus.com/api/v1';
  List<CourseModel> _courses = [];

  // Pagination metadata
  int _currentPage = 1;
  int _totalPages = 1;
  bool _hasNextPage = false;
  bool _hasPreviousPage = false;

  // Getters for pagination info
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  bool get hasNextPage => _hasNextPage;
  bool get hasPreviousPage => _hasPreviousPage;

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Load courses from API with pagination
  Future<void> loadLessons(int page) async {
    final token = await getToken();
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
          _hasNextPage = jsonData['links']['next'] != null;
          _hasPreviousPage = jsonData['links']['prev'] != null;
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

  Future<bool> loadNextPage() async {
    if (!_hasNextPage) return false;
    await loadLessons(_currentPage + 1);
    return true;
  }

  Future<bool> loadPreviousPage() async {
    if (!_hasPreviousPage) return false;
    await loadLessons(_currentPage - 1);
    return true;
  }

  Future<CourseModel?> createLesson(
      String title, String description, String url, DateTime date) async {
    // Existing code...
    final token = await getToken();

    if (token == null) {
      print('Token is null');
      return null;
    }

    final requestBody = {
      'title': title,
      'description': description,
      'video_url': url,
      'date': DateFormat('yyyy-MM-dd HH:mm').format(date),
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
        print('Create response: $jsonData'); // Tambahan debug

        final courseData = jsonData['data'];
        if (courseData != null) {
          final newCourse = CourseModel.fromApiJson(courseData);
          _courses.add(newCourse);
          return newCourse;
        } else {
          print('Course created but no course data returned.');
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
    final token = await getToken();
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

  Future<bool> deleteLesson(String courseId) async {
    final token = await getToken();
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
    final token = await getToken();
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

  Future<bool> isUserAdmin() async {
    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString('role') ?? '';
    return role.toLowerCase() == 'admin';
  }
}
