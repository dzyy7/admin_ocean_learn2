import 'package:admin_ocean_learn2/pages/course_page/course_detail_page.dart';
import 'package:admin_ocean_learn2/pages/schedule/schedule_controller.dart';
import 'package:admin_ocean_learn2/utils/color_palette.dart';
import 'package:admin_ocean_learn2/widget/schedule_component/schedule_card.dart';
import 'package:admin_ocean_learn2/widget/schedule_component/schhedule_calendar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ScheduleController());

    return Scaffold(
      backgroundColor: netralColor,
      appBar: AppBar(
        backgroundColor: netralColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        title: const Text(
          "Course Schedule",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: () => controller.loadCourses(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        
        return RefreshIndicator(
          onRefresh: () => controller.loadCourses(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Weekly Schedule Rules:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "• Each week can have only one lesson or none\n"
                        "• Lessons are shown on the calendar with blue circles\n"
                        "• Tap on a lesson date in the calendar to view details",
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                CalendarWidget(controller: controller),
                const SizedBox(height: 16),
                _buildLectureSection(controller, context),
              ],
            ),
          ),
        );
      }),
    );
  }
  
  Widget _buildLectureSection(ScheduleController controller, BuildContext context) {
    return Obx(() {
      final courses = controller.getCoursesForCurrentMonth();
      
      if (courses.isEmpty) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: Text(
              "No courses scheduled for this month.\nCourses you create will appear here.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16,
              ),
            ),
          ),
        );
      }
      
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 8, bottom: 8),
            child: Text(
              "This Month's Courses",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          ...courses.asMap().entries.map((entry) {
            final index = entry.key;
            final course = entry.value;
            final isPast = controller.isDatePast(course.date);
            final formattedDate = DateFormat('MMMM d yyyy').format(course.date);
            
            return Padding(
              padding: EdgeInsets.only(bottom: index < courses.length - 1 ? 16 : 0),
              child: ScheduleCard(
                weekNumber: index + 1,
                date: formattedDate,
                isPast: isPast,
                title: course.title,
                onViewDetails: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CourseDetailPage(
                        course: course,
                        lessonService: controller.courseService,
                      ),
                    ),
                  ).then((_) => controller.loadCourses());
                },
              ),
            );
          }).toList(),
        ],
      );
    });
  }
}