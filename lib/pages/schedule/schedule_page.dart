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
    // Initialize the controller
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
          "Here's your schedule Samudra!",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CalendarWidget(controller: controller),
            const SizedBox(height: 16),
            _buildLectureSection(controller),
          ],
        ),
      ),
    );
  }
  
  Widget _buildLectureSection(ScheduleController controller) {
    return Obx(() {
      final markedDates = controller.getMarkedDatesForCurrentMonth();
      
      if (markedDates.isEmpty) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: Text(
              "No lectures scheduled for this month.\nTap on dates in the calendar to add events.",
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
        children: markedDates.asMap().entries.map((entry) {
          final index = entry.key;
          final date = entry.value;
          final isPast = controller.isDatePast(date);
          final formattedDate = DateFormat('MMMM d yyyy').format(date);
          
          return Padding(
            padding: EdgeInsets.only(bottom: index < markedDates.length - 1 ? 16 : 0),
            child: ScheduleCard(
              weekNumber: index + 1,
              date: formattedDate,
              isPast: isPast,
            ),
          );
        }).toList(),
      );
    });
  }
}