import 'package:admin_ocean_learn2/pages/course_page/course_model.dart';
import 'package:admin_ocean_learn2/services/course_service.dart';
import 'package:admin_ocean_learn2/utils/color_palette.dart';
import 'package:admin_ocean_learn2/widget/course_page/lesson_card.dart';
import 'package:admin_ocean_learn2/widget/course_page/note_button.dart';
import 'package:admin_ocean_learn2/widget/course_page/note_input.dart';
import 'package:admin_ocean_learn2/widget/course_page/note_section.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CourseDetailPage extends StatefulWidget {
  final CourseModel course;
  final CourseService lessonService;

  const CourseDetailPage({
    Key? key,
    required this.course,
    required this.lessonService,
  }) : super(key: key);

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  bool _isNoteVisible = false;
  bool _isLoading = false;
  bool _isAdmin = false;
  late TextEditingController _noteController;
  late CourseModel _currentCourse;

  @override
  void initState() {
    super.initState();
    _currentCourse = widget.course;
    _noteController = TextEditingController(text: widget.course.note);
    _checkAdminStatus();
    _loadCourseDetail();
  }

  Future<void> _checkAdminStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString('role') ?? '';
    setState(() {
      _isAdmin = role.toLowerCase() == 'admin';
    });
  }

  Future<void> _loadCourseDetail() async {
    setState(() {
      _isLoading = true;
    });
    
    final courseDetail = await widget.lessonService.getCourseDetail(_currentCourse.id);
    
    if (courseDetail != null) {
      setState(() {
        _currentCourse = courseDetail;
        _noteController.text = courseDetail.note;
      });
    }
    
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: netralColor,
      appBar: AppBar(
        backgroundColor: netralColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _currentCourse.title,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  LessonCard(course: _currentCourse),
                  const SizedBox(height: 20),
                  if (_isAdmin)
                    _isNoteVisible
                        ? NoteInput(
                            controller: _noteController,
                            onSave: () async {
                              setState(() {
                                _isLoading = true;
                              });
                              
                              bool success = await widget.lessonService.updateNote(
                                _currentCourse.id,
                                _noteController.text,
                              );
                              
                              setState(() {
                                _isLoading = false;
                                _isNoteVisible = false;
                                if (success) {
                                  _currentCourse.note = _noteController.text;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Note updated successfully"))
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Failed to update note"))
                                  );
                                }
                              });
                            },
                            onCancel: () => setState(() => _isNoteVisible = false),
                          )
                        : NoteButton(onPressed: () {
                            setState(() => _isNoteVisible = true);
                          }),
                  const SizedBox(height: 16),
                  NotesSection(course: _currentCourse, isNoteVisible: _isNoteVisible),
                ],
              ),
            ),
    );
  }
}