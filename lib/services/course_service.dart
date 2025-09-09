import 'dart:convert';
import 'dart:io';
import 'package:admin_ocean_learn2/model/course_model.dart';
import 'package:admin_ocean_learn2/pages/login/login_controller.dart';
import 'package:admin_ocean_learn2/utils/user_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class CourseService {
  static const String baseUrl = 'https://ocean-learn-api.rplrus.com/api/v1/admin';
  List<CourseModel> _courses = [];

  String? getToken() {
    return UserStorage.getToken() ?? LoginController.getSessionToken();
  }

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
          
          // Sort courses by date untuk memudahkan pencarian upcoming lesson
          _courses.sort((a, b) => a.date.compareTo(b.date));
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

  List<CourseModel> getLessons() {
    return _courses;
  }

  // Method untuk mendapatkan upcoming lessons
  List<CourseModel> getUpcomingLessons() {
    final now = DateTime.now();
    return _courses.where((course) {
      return course.date.isAfter(now) || 
             course.date.isAtSameMomentAs(now) ||
             _isSameDay(course.date, now);
    }).toList();
  }

  CourseModel? getNextUpcomingLesson() {
    final upcomingLessons = getUpcomingLessons();
    if (upcomingLessons.isEmpty) {
      if (_courses.isNotEmpty) {
        final sortedCourses = List<CourseModel>.from(_courses);
        sortedCourses.sort((a, b) => b.date.compareTo(a.date));
        return sortedCourses.first;
      }
      return null;
    }
    
    upcomingLessons.sort((a, b) => a.date.compareTo(b.date));
    return upcomingLessons.first;
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }

  Future<CourseModel?> createCourse(
      String title, String description, File pdfFile, DateTime classDate) async {
    final token = getToken();

    if (token == null) {
      print('Token is null');
      return null;
    }

    if (isCourseExistInWeek(classDate)) {
      print('A course already exists in this week. Cannot create another.');
      return null;
    }

    try {
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/course'));
      
      // Add headers
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';
      
      // Add fields
      request.fields['title'] = title;
      request.fields['description'] = description;
      request.fields['date'] = DateFormat('yyyy-MM-dd HH:mm').format(classDate);
      
      // Add PDF file
      var pdfStream = http.ByteStream(pdfFile.openRead());
      var length = await pdfFile.length();
      var multipartFile = http.MultipartFile(
        'file', // field name expected by API
        pdfStream,
        length,
        filename: pdfFile.path.split('/').last,
      );
      request.files.add(multipartFile);

      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      if (response.statusCode == 201 || response.statusCode == 200) {
        final jsonData = jsonDecode(responseData);
        final courseData = jsonData['data'];
        if (courseData != null) {
          final newCourse = CourseModel.fromApiJson(jsonData);
          _courses.add(newCourse);
          // Sort ulang setelah menambah course baru
          _courses.sort((a, b) => a.date.compareTo(b.date));
          return newCourse;
        }
      } else {
        print('Failed to create: ${response.statusCode} - $responseData');
      }
    } catch (e) {
      print('Error creating course: $e');
    }

    return null;
  }

  

  Future<bool> updateCourse({
    required String courseId,
    required String title,
    required String description,
    required DateTime date,
  }) async {
    final token = getToken();
    if (token == null) return false;

    if (isCourseExistInWeek(date, excludeCourseId: courseId)) {
      print('Another course already exists in this week. Cannot update.');
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
            filePath: _courses[index].filePath,
            date: date,
            qrCode: _courses[index].qrCode,
            qrEndDate: _courses[index].qrEndDate,
          );
          // Sort ulang setelah update
          _courses.sort((a, b) => a.date.compareTo(b.date));
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
          return CourseModel.fromApiJson(jsonData);
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

  bool isCourseExistInWeek(DateTime dateToCheck, {String? excludeCourseId}) {
    return _courses.any((course) {
      if (excludeCourseId != null && course.id == excludeCourseId) {
        return false;
      }
      return isInSameWeek(course.date, dateToCheck);
    });
  }

  Future<bool> isUserAdmin() async {
    final role = UserStorage.getRole() ?? LoginController.getSessionRole() ?? '';
    return role.toLowerCase() == 'admin';
  }
}