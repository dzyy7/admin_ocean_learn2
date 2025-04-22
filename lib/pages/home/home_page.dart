import 'package:admin_ocean_learn2/widget/home_component/add_course_button.dart';
import 'package:admin_ocean_learn2/widget/home_component/featured_lecture_card.dart';
import 'package:admin_ocean_learn2/widget/home_component/lesson_list.dart';
import 'package:admin_ocean_learn2/widget/home_component/pagination.dart';
import 'package:flutter/material.dart';

import 'package:admin_ocean_learn2/services/course_service.dart';
import 'package:admin_ocean_learn2/utils/color_palette.dart';
import 'package:admin_ocean_learn2/widget/home_component/search_bar_widget.dart';
import 'package:admin_ocean_learn2/pages/course_page/course_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _name = '';
  final CourseService _courseService = CourseService();
  bool _isLoading = true;
  List<CourseModel> _lessons = [];

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('name') ?? '';
    });
  }

  @override
  void initState() {
    _loadUserName();
    super.initState();
    _loadLessons(1);
  }

  Future<void> _loadLessons(int page) async {
    setState(() => _isLoading = true);
    await _courseService.loadLessons(page);
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
      floatingActionButton: AddCourseButton(
        courseService: _courseService,
        onCourseAdded: () => _loadLessons(1),
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: () => _loadLessons(_courseService.currentPage),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        FeaturedLessonCard(
                            lessons: _lessons,
                            courseService: _courseService,
                            onRefresh: _loadLessons),
                        const SizedBox(height: 20),
                        const SearchBarWidget(),
                        const SizedBox(height: 20),
                        LessonList(
                          lessons: _lessons,
                          courseService: _courseService,
                          onRefresh: _loadLessons,
                        ),
                        const SizedBox(height: 20),
                        PaginationControls(
                            courseService: _courseService,
                            onPageChange: _loadLessons),
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: netralColor,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.black),
        onPressed: () => Scaffold.of(context).openDrawer(),
      ),
      title: Text(
        "Here's your schedule, $_name!",
        style: const TextStyle(
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
}
