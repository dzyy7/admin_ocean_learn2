import 'package:admin_ocean_learn2/pages/course_page/course_detail_page.dart';
import 'package:admin_ocean_learn2/pages/schedule/schedule_controller.dart';
import 'package:admin_ocean_learn2/utils/color_palette.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CalendarWidget extends StatelessWidget {
  final ScheduleController controller;
  
  const CalendarWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildCalendarHeader(),
          const SizedBox(height: 12),
          _buildWeekdayHeaders(),
          const SizedBox(height: 12),
          Obx(() => _buildCalendarDays(context)),
        ],
      ),
    );
  }
  
  Widget _buildCalendarHeader() {
    return Obx(() => Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: controller.previousMonth,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        Text(
          DateFormat('MMMM yyyy').format(controller.currentMonth.value),
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: controller.nextMonth,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    ));
  }
  
  Widget _buildWeekdayHeaders() {
    final weekdays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: weekdays.map((day) => 
        SizedBox(
          width: 36,
          child: Text(
            day,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        )
      ).toList(),
    );
  }
  
  Widget _buildCalendarDays(BuildContext context) {
    final currentMonth = controller.currentMonth.value;
    final firstDayOfMonth = DateTime(currentMonth.year, currentMonth.month, 1);
    final lastDayOfMonth = DateTime(currentMonth.year, currentMonth.month + 1, 0);
    
    // Calculate how many empty spots we need before the first day
    final firstWeekday = firstDayOfMonth.weekday % 7; // 0 = Sunday, 1 = Monday, etc.
    
    // Calculate total number of days to display (including empty spots)
    final totalDays = firstWeekday + lastDayOfMonth.day;
    final totalWeeks = (totalDays / 7).ceil();
    
    final calendarDays = List<Widget>.generate(totalWeeks * 7, (index) {
      // Empty spots before the first day of the month
      if (index < firstWeekday) {
        return const SizedBox(width: 36, height: 36);
      }
      
      // Calculate the day number
      final dayNumber = index - firstWeekday + 1;
      
      // Days after the last day of the month
      if (dayNumber > lastDayOfMonth.day) {
        return const SizedBox(width: 36, height: 36);
      }
      
      // Create the date for this calendar day
      final date = DateTime(currentMonth.year, currentMonth.month, dayNumber);
      final isMarked = controller.isDateMarked(date);
      final isToday = controller.isToday(date);
      
      return SizedBox(
        width: 36,
        height: 36,
        child: InkWell(
          onTap: isMarked ? () {
            final course = controller.getCourseForDate(date);
            if (course != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CourseDetailPage(
                    course: course,
                    lessonService: controller.courseService,
                  ),
                ),
              ).then((_) => controller.loadCourses());
            }
          } : null,
          borderRadius: BorderRadius.circular(18),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isToday ? primaryColor.withOpacity(0.2) : Colors.transparent,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  dayNumber.toString(),
                  style: TextStyle(
                    fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                    color: isToday ? primaryColor : Colors.black87,
                  ),
                ),
                if (isMarked)
                  Positioned(
                    bottom: 2,
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: primaryColor,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    });
    
    // Create rows for each week
    final weeks = <Widget>[];
    for (int i = 0; i < totalWeeks; i++) {
      final weekDays = calendarDays.sublist(i * 7, (i + 1) * 7);
      weeks.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: weekDays,
        ),
      );
      
      if (i < totalWeeks - 1) {
        weeks.add(const SizedBox(height: 8));
      }
    }
    
    return Column(children: weeks);
  }
}