import 'package:flutter/material.dart';

class ScheduleCard extends StatelessWidget {
  final int weekNumber;
  final String date;
  final bool isPast;
  final String? title;
  final VoidCallback? onViewDetails;

  const ScheduleCard({
    Key? key,
    required this.weekNumber,
    required this.date,
    required this.isPast, 
    this.title,
    this.onViewDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Week $weekNumber: ${title ?? 'Lecture Title'}",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            isPast ? "Completed on $date" : "Upcoming on $date",
            style: TextStyle(
              color: isPast ? Colors.grey : Colors.green,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: onViewDetails,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFE1F5FE),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.info_outline, size: 18, color: Colors.blue),
                  SizedBox(width: 8),
                  Text(
                    "View Course Details",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}