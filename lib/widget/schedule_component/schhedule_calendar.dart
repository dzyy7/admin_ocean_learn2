import 'package:admin_ocean_learn2/pages/schedule/schedule_controller.dart';
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
      ),
      child: Column(
        children: [
          _buildCalendarHeader(),
          const SizedBox(height: 12),
          _buildWeekdayHeaders(),
          const SizedBox(height: 12),
          Obx(() => _buildCalendarDays()),
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
    final weekdays = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: weekdays.map((day) {
        return SizedBox(
          width: 40,
          child: Text(
            day,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCalendarDays() {
    // First day of the month
    final currentMonth = controller.currentMonth.value;
    final firstDay = DateTime(currentMonth.year, currentMonth.month, 1);
    // Days in month
    final daysInMonth = DateTime(currentMonth.year, currentMonth.month + 1, 0).day;
    // Calculate offset for first day (0 = Sunday, 1 = Monday, etc.)
    final firstWeekdayOfMonth = firstDay.weekday % 7;
    
    // Generate calendar grid
    List<Widget> weeks = [];
    int day = 1;
    
    // Generate up to 6 weeks to cover all possible month layouts
    for (int week = 0; week < 6; week++) {
      List<Widget> daysRow = [];
      
      for (int weekday = 0; weekday < 7; weekday++) {
        // Skip days before the first day of the month
        if (week == 0 && weekday < firstWeekdayOfMonth) {
          daysRow.add(const SizedBox(width: 40, height: 40));
          continue;
        }
        
        // Stop after we've rendered all days of the month
        if (day > daysInMonth) {
          daysRow.add(const SizedBox(width: 40, height: 40));
          continue;
        }
        
        // Create the date for this calendar cell
        final date = DateTime(currentMonth.year, currentMonth.month, day);
        
        // Add the day widget to the row
        daysRow.add(_buildCalendarDay(day, date));
        day++;
      }
      
      weeks.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: daysRow,
        ),
      );
      
      // If we've rendered all days, break out of the loop
      if (day > daysInMonth) break;
    }
    
    return Column(children: weeks);
  }

  Widget _buildCalendarDay(int day, DateTime date) {
    return Obx(() {
      final isMarked = controller.isDateMarked(date);
      final isToday = controller.isToday(date);
      
      return InkWell(
        onTap: () => controller.toggleDateMark(date),
        child: Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(vertical: 4),
          decoration: isMarked
              ? BoxDecoration(
                  color: Colors.lightBlue,
                  shape: BoxShape.circle,
                )
              : null,
          child: Text(
            day.toString(),
            style: TextStyle(
              color: isMarked ? Colors.white : Colors.black,
              fontWeight: isToday ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ),
      );
    });
  }
}