import 'package:flutter/material.dart';
import 'package:admin_ocean_learn2/services/course_service.dart';
import 'package:admin_ocean_learn2/utils/color_palette.dart';

class PaginationControls extends StatelessWidget {
  final CourseService courseService;
  final Future<void> Function(int) onPageChange;

  const PaginationControls({
    super.key,
    required this.courseService,
    required this.onPageChange,
  });

  @override
  Widget build(BuildContext context) {
    if (courseService.getLessons().isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: courseService.hasPreviousPage
                ? () => onPageChange(courseService.currentPage - 1)
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.grey[300],
            ),
            child: const Icon(Icons.arrow_back),
          ),
          const SizedBox(width: 16),
          Text(
            'Page ${courseService.currentPage} of ${courseService.totalPages}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 16),
          ElevatedButton(
            onPressed: courseService.hasNextPage
                ? () => onPageChange(courseService.currentPage + 1)
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.grey[300],
            ),
            child: const Icon(Icons.arrow_forward),
          ),
        ],
      ),
    );
  }
}
