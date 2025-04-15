import 'package:admin_ocean_learn2/pages/course_page/course_model.dart';
import 'package:admin_ocean_learn2/utils/color_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class LessonCard extends StatelessWidget {
  final CourseModel course;

  const LessonCard({Key? key, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Incoming Class", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey[700])),
          Text(DateFormat('MMMM d yyyy').format(course.date), style: const TextStyle(fontSize: 14, color: Colors.grey)),
          const SizedBox(height: 16),
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              decoration: BoxDecoration(color: Colors.lightBlue.shade100, borderRadius: BorderRadius.circular(8)),
              child: Center(child: SvgPicture.asset('assets/svg/home1.svg', width: 120)),
            ),
          ),
          const SizedBox(height: 16),
          Text(course.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(course.description, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                if (course.url.isNotEmpty) {
                  final Uri url = Uri.parse(course.url);
                  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not open the URL')));
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No URL available for this lesson')));
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text("Let's check the lessons!", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
