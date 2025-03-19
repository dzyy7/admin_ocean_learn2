// widgets/lesson_list_item.dart
import 'package:flutter/material.dart';

class LessonListItem extends StatelessWidget {
  final String title;
  final String date;

  const LessonListItem({
    super.key,
    required this.title,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.lightBlue.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          date,
          style: const TextStyle(
            color: Colors.black54,
          ),
        ),
        trailing: const Icon(Icons.more_vert),
      ),
    );
  }
}