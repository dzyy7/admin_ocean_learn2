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

  // Method untuk mendapatkan lesson yang mendekati (upcoming)
  CourseModel? _getUpcomingLesson() {
  if (lessons.isEmpty) return null;

  final now = DateTime.now();

  // Filter lesson yang belum lewat
  final upcomingLessons = lessons.where((lesson) {
    return lesson.date.isAfter(now) ||
           lesson.date.isAtSameMomentAs(now) ||
           _isSameDay(lesson.date, now);
  }).toList();

  if (upcomingLessons.isEmpty) {
    // copy dulu biar gak ubah RxList asli
    final sortedLessons = List<CourseModel>.from(lessons)
      ..sort((a, b) => b.date.compareTo(a.date));
    return sortedLessons.first;
  }

  // Sort berdasarkan tanggal ascending
  upcomingLessons.sort((a, b) => a.date.compareTo(b.date));
  return upcomingLessons.first;
}


  // Helper method untuk mengecek apakah dua tanggal adalah hari yang sama
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }

  // Method untuk mendapatkan status lesson
  
  @override
  Widget build(BuildContext context) {
    final upcomingLesson = _getUpcomingLesson();
    final hasLesson = upcomingLesson != null;
    
    final title = hasLesson ? upcomingLesson.title : 'No Lessons Yet';
    final date = hasLesson
        ? DateFormat('MMMM d yyyy').format(upcomingLesson.date)
        : 'Add your first lesson';
    final imagePath = 'assets/svg/home1.svg';

    return GestureDetector(
      onTap: hasLesson
          ? () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CourseDetailPage(
                    course: upcomingLesson,
                    courseService: courseService,
                  ),
                ),
              );
              onRefresh(0);
            }
          : null,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
          
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
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
                            course: upcomingLesson,
                            courseService: courseService,
                          ),
                        ),
                      );
                      onRefresh(0);
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: hasLesson 
                    ? Colors.lightBlue.shade100 
                    : Colors.grey.shade200,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: Text(
                hasLesson ? 'More Detail..' : 'No Lessons Available',
                style: TextStyle(
                  color: hasLesson ? Colors.black87 : Colors.grey.shade600,
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