import 'package:admin_ocean_learn2/model/course_model.dart';
import 'package:flutter/material.dart';

class NotesSection extends StatelessWidget {
  final CourseModel course;
  final bool isNoteVisible;

  const NotesSection({
    Key? key,
    required this.course,
    required this.isNoteVisible,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (course.note.isEmpty || isNoteVisible) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Note", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(course.note),
        ],
      ),
    );
  }
}
