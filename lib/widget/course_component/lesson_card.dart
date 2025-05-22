import 'package:admin_ocean_learn2/model/course_model.dart';
import 'package:admin_ocean_learn2/utils/color_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
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
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Incoming Class", 
                    style: GoogleFonts.inter(
                      fontSize: 16, 
                      fontWeight: FontWeight.bold, 
                      color: Colors.black
                    )
                  ),
                  Text(
                    DateFormat('MMMM d yyyy').format(course.date), 
                    style: const TextStyle(fontSize: 14, color: Colors.black87)
                  ),
                ],
              ),
              
            ],
          ),
          const SizedBox(height: 20),
          Center(
            child: SvgPicture.asset(
              'assets/svg/course.svg', 
              width: 200,
              height: 140,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            height: 48, 
            decoration: BoxDecoration(
              color: secondaryColor, 
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: primaryColor, width: 1.5),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: () async {
                  if (course.videoUrl.isNotEmpty) {
                    final Uri url = Uri.parse(course.videoUrl);
                    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Could not open the URL'))
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('No URL available for this lesson'))
                    );
                  }
                },
                child: Center(
                  child: Text(
                    "Let's check the lessons!",
                    style: GoogleFonts.poppins(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 14),
        ],
      ),
    );
  }
}