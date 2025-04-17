import 'dart:convert';
import 'package:admin_ocean_learn2/pages/course_page/course_model.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CourseService {
  static const String baseUrl = 'https://ocean-learn-api.rplrus.com/api/v1';
  List<CourseModel> _courses = [];

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Load courses from API
  Future<void> loadLessons() async {
    final token = await getToken();
    if (token == null) return;

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/courses'),
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
        }
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
    String title, String description, String url, DateTime date) async {
  final token = await getToken();

  if (token == null) {
    print('Token is null');
    return null;
  }

  final requestBody = {
    'title': title,
    'description': description,
    'video_url': url,
    'class_date': DateFormat('yyyy-MM-dd').format(date), // Try simplified date
  };

  try {
    final response = await http.post(
      Uri.parse('$baseUrl/courses'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestBody),
    );

    print('Request body: $requestBody');
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 201 || response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      if (jsonData['status'] == true && jsonData['data'] != null) {
        final newCourse = CourseModel.fromApiJson(jsonData['data']);
        _courses.add(newCourse);
        return newCourse;
      } else {
        print('API returned false status or missing data: ${jsonData}');
      }
    } else {
      print('Failed to create: ${response.body}');
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
        Uri.parse('$baseUrl/courses/$courseId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'note': note,
        }),
      );

      if (response.statusCode == 200) {
        int courseIndex = _courses.indexWhere((course) => course.id == courseId);
        if (courseIndex != -1) {
          _courses[courseIndex].note = note;
        }
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
        Uri.parse('$baseUrl/courses/$courseId'),
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
        Uri.parse('$baseUrl/courses/$courseId'),
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