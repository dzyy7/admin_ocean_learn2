import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:admin_ocean_learn2/model/course_model.dart';
import 'package:admin_ocean_learn2/pages/course_page/course_detail_page.dart';
import 'package:admin_ocean_learn2/services/course_service.dart';

class FeaturedLessonCard extends StatelessWidget {
  final List<CourseModel> lessons;
  final CourseService courseService;
  final Future<void> Function(int) onRefresh;

  const FeaturedLessonCard({
    super.key,
    required this.lessons,
    required this.courseService,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final hasLesson = lessons.isNotEmpty;
    final title = hasLesson ? lessons.first.title : 'No Lessons Yet';
    final date = hasLesson
        ? DateFormat('MMMM d yyyy').format(lessons.first.date)
        : 'Add your first lesson';
    final imagePath = 'assets/svg/home1.svg';

    return GestureDetector(
      onTap: hasLesson
          ? () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CourseDetailPage(
                    course: lessons.first,
                    lessonService: courseService,
                  ),
                ),
              );
              onRefresh(courseService.currentPage);
            }
          : null,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              date,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 16),
            SvgPicture.asset(
              imagePath,
              height: 150,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: hasLesson
                  ? () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CourseDetailPage(
                            course: lessons.first,
                            lessonService: courseService,
                          ),
                        ),
                      );
                      onRefresh(courseService.currentPage);
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue.shade100,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text(
                'More Detail..',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
