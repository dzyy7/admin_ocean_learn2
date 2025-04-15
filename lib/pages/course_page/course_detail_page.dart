import 'package:admin_ocean_learn2/pages/course_page/course_model.dart';
import 'package:admin_ocean_learn2/services/course_service.dart';
import 'package:admin_ocean_learn2/utils/color_palette.dart';
import 'package:admin_ocean_learn2/widget/course_page/lesson_card.dart';
import 'package:admin_ocean_learn2/widget/course_page/note_button.dart';
import 'package:admin_ocean_learn2/widget/course_page/note_input.dart';
import 'package:admin_ocean_learn2/widget/course_page/note_section.dart';
import 'package:flutter/material.dart';

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
  late TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController(text: widget.course.note);
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
          widget.course.title,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            LessonCard(course: widget.course),
            const SizedBox(height: 20),
            _isNoteVisible
                ? NoteInput(
                    controller: _noteController,
                    onSave: () async {
                      await widget.lessonService.updateNote(
                        widget.course.id,
                        _noteController.text,
                      );
                      setState(() => _isNoteVisible = false);
                    },
                    onCancel: () => setState(() => _isNoteVisible = false),
                  )
                : NoteButton(onPressed: () {
                    setState(() => _isNoteVisible = true);
                  }),
            const SizedBox(height: 16),
            NotesSection(course: widget.course, isNoteVisible: _isNoteVisible),
          ],
        ),
      ),
    );
  }
}
