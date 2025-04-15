// services/lesson_service.dart
import 'dart:math';
import 'package:admin_ocean_learn2/pages/course_page/course_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CourseService {
  static const String _storageKey = 'lessons';
  List<CourseModel> _lessons = [];

  Future<void> loadLessons() async {
    final prefs = await SharedPreferences.getInstance();
    final lessonsJson = prefs.getStringList(_storageKey) ?? [];
    _lessons = lessonsJson
        .map((json) => CourseModel.fromMap(jsonDecode(json)))
        .toList();
  }

  Future<void> saveCourse() async {
    final prefs = await SharedPreferences.getInstance();
    final lessonsJson =
        _lessons.map((lesson) => jsonEncode(lesson.toMap())).toList();
    await prefs.setStringList(_storageKey, lessonsJson);
  }

  List<CourseModel> getLessons() {
    return _lessons;
  }

  Future<CourseModel> createLesson(
      String title, String description, String url, DateTime date) async {
    final lesson = CourseModel(
      id: Random().nextInt(10000).toString(),
      title: title,
      description: description,
      url: url,
      date: date,
    );
    _lessons.add(lesson);
    await saveCourse();
    return lesson;
  }

  // This is the correct method for updating the note
  Future<void> updateNote(String lessonId, String note) async {
    final lessonIndex = _lessons.indexWhere((lesson) => lesson.id == lessonId);
    if (lessonIndex != -1) {
      _lessons[lessonIndex].note = note;
      await saveCourse();
    }
  }

  Future<void> deleteLesson(String lessonId) async {
    _lessons.removeWhere((lesson) => lesson.id == lessonId);
    await saveCourse();
  }
}