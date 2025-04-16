// home_page.dart
import 'package:admin_ocean_learn2/pages/course_page/add_course_screen.dart';
import 'package:admin_ocean_learn2/pages/course_page/course_detail_page.dart';
import 'package:admin_ocean_learn2/pages/course_page/course_model.dart';
import 'package:admin_ocean_learn2/services/course_service.dart';
import 'package:admin_ocean_learn2/utils/color_palette.dart';
import 'package:admin_ocean_learn2/widget/home_component/featured_lecture_card.dart';
import 'package:admin_ocean_learn2/widget/home_component/lesson_list_item.dart';
import 'package:admin_ocean_learn2/widget/home_component/search_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CourseService _courseService = CourseService();
  bool _isLoading = true;
  List<CourseModel> _lessons = [];

  @override
  void initState() {
    super.initState();
    _loadLessons();
  }

  Future<void> _loadLessons() async {
    await _courseService.loadLessons();
    setState(() {
      _lessons = _courseService.getLessons();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: netralColor,
      appBar: _buildAppBar(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddCourseScreen(
                lessonService: _courseService,
              ),
            ),
          );
          if (result == true) {
            _loadLessons();
          }
        },
        backgroundColor: primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      _lessons.isNotEmpty
                          ? _buildFeaturedLesson(_lessons.first)
                          : const FeaturedLectureCard(
                              title: 'No Lessons Yet',
                              date: 'Add your first lesson',
                              imagePath: 'assets/svg/home1.svg',
                            ),
                      const SizedBox(height: 20),
                      const SearchBarWidget(),
                      const SizedBox(height: 20),
                      _buildLessonsList(),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildFeaturedLesson(CourseModel lesson) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CourseDetailPage(
              course: lesson,
              lessonService: _courseService,
            ),
          ),
        ).then((_) => _loadLessons());
      },
      child: FeaturedLectureCard(
        title: lesson.title,
        date: DateFormat('MMMM d yyyy').format(lesson.date),
        imagePath: 'assets/svg/home1.svg',
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
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
    );
  }

  // home_page.dart
// Update the _buildLessonsList method in the HomePage class

Widget _buildLessonsList() {
  if (_lessons.isEmpty) {
    return const Center(
      child: Text(
        "No lessons yet. Create one using the + button.",
        style: TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }

  return ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: _lessons.length,
    itemBuilder: (context, index) {
      final lesson = _lessons[index];
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
                        MaterialPageRoute(
              builder: (context) => CourseDetailPage(
                course: lesson,
                lessonService: _courseService,
              ),
            ),
          ).then((_) => _loadLessons());
        },
        child: LessonListItem(
          title: lesson.title,
          date: DateFormat('MMMM d yyyy').format(lesson.date),
          onDelete: () async {
            await _courseService.deleteLesson(lesson.id);
            _loadLessons();
          },
        ),
      );
    },
  );
}
}