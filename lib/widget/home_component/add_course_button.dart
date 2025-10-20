import 'package:flutter/material.dart';
import 'package:admin_ocean_learn2/pages/course_page/add_course_screen.dart';
import 'package:admin_ocean_learn2/services/course_service.dart';
import 'package:admin_ocean_learn2/utils/color_palette.dart';

class AddCourseButton extends StatelessWidget {
  final CourseService courseService;
  final VoidCallback onCourseAdded;

  const AddCourseButton({
    super.key,
    required this.courseService,
    required this.onCourseAdded,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddCourseScreen(courseService: courseService),
          ),
        );
        if (result == true) onCourseAdded();
      },
      backgroundColor: primaryColor,
      child: const Icon(Icons.add, color: Colors.white),
    );
  }
}
