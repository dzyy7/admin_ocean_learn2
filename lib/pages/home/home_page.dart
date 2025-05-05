import 'package:admin_ocean_learn2/pages/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:admin_ocean_learn2/utils/color_palette.dart';
import 'package:admin_ocean_learn2/widget/home_component/add_course_button.dart';
import 'package:admin_ocean_learn2/widget/home_component/featured_lecture_card.dart';
import 'package:admin_ocean_learn2/widget/home_component/lesson_list.dart';
import 'package:admin_ocean_learn2/widget/home_component/search_bar_widget.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          backgroundColor: netralColor,
          appBar: AppBar(
            backgroundColor: netralColor,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.menu, color: Colors.black),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
            title: Text(
              "Here's your schedule, ${controller.name.value}!",
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined,
                    color: Colors.black),
                onPressed: () {},
              ),
            ],
          ),
          floatingActionButton: AddCourseButton(
            courseService: controller.courseService,
            onCourseAdded: () => controller.loadInitialLessons(),
          ),
          body: SafeArea(
            child: controller.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () => controller.loadInitialLessons(),
                    child: CustomScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      slivers: [
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          sliver: SliverList(
                            delegate: SliverChildListDelegate([
                              const SizedBox(height: 20),
                              FeaturedLessonCard(
                                lessons: controller.lessons,
                                courseService: controller.courseService,
                                onRefresh: (_) =>
                                    controller.loadInitialLessons(),
                              ),
                              const SizedBox(height: 20),
                              Obx(() => SearchBarWidget(
                                    onChanged: controller.updateSearchQuery,
                                    onTunePressed: controller.toggleSortOrder,
                                    isNewest: controller.sortByNewest.value,
                                  )),
                              const SizedBox(height: 20),
                              LessonList(
                                lessons: controller.filteredLessons,
                                courseService: controller.courseService,
                                onRefresh: (_) =>
                                    controller.loadInitialLessons(),
                              ),
                              if (controller.isLoadingMore.value)
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16.0),
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                ),
                              const SizedBox(height: 80),
                            ]),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ));
  }
}
