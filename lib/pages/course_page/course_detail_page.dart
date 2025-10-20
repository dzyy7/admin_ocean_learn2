import 'package:admin_ocean_learn2/model/course_model.dart';
import 'package:admin_ocean_learn2/pages/course_page/qr_code_page/qr_code_page.dart';
import 'package:admin_ocean_learn2/services/course_service.dart';
import 'package:admin_ocean_learn2/utils/color_palette.dart';
import 'package:admin_ocean_learn2/widget/course_component/lesson_card.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CourseDetailPage extends StatefulWidget {
  final CourseModel course;
  final CourseService courseService;

  const CourseDetailPage({
    super.key,
    required this.course,
    required this.courseService,
  });

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  final bool _isNoteVisible = false;
  bool _isLoading = false;
  bool _isAdmin = false;
  late CourseModel _currentCourse;

  @override
  void initState() {
    super.initState();
    _currentCourse = widget.course;
    _checkAdminStatus();
    _loadCourseDetail();
  }

  Future<void> _checkAdminStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString('role') ?? '';
    setState(() {
      _isAdmin = role.toLowerCase() == 'admin';
    });
  }

  Future<void> _loadCourseDetail() async {
    setState(() {
      _isLoading = true;
    });
    
    final courseDetail = await widget.courseService.getCourseDetail(_currentCourse.id);
    
    if (courseDetail != null) {
      setState(() {
        _currentCourse = courseDetail;
     });
    }
    
    setState(() {
      _isLoading = false;
    });
  }
  
  void _navigateToQRCodePage() {
    if (_currentCourse.qrCode != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QRCodePage(course: _currentCourse),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No QR code available for this course'))
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: netralColor,
      appBar: AppBar(
        backgroundColor: netralColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _currentCourse.title,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // Add QR code button to app bar
          if (_currentCourse.qrCode != null)
            IconButton(
              icon: const Icon(Icons.qr_code, color: Colors.black),
              onPressed: _navigateToQRCodePage,
              tooltip: 'Show QR Code',
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  CourseCard(course: _currentCourse),
                ],
              ),
            ),
    );
  }
}