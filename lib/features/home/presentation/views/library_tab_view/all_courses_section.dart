import 'dart:developer';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:page_transition/page_transition.dart';
import 'package:slides_sync/core/usecases/app_navigator.dart';
import 'package:slides_sync/core/utils/app_ui_state.dart';
import 'package:slides_sync/features/course_mgmt/data/models/course_model/course_model.dart';
import 'package:slides_sync/shared/styles/app_ui_context.dart';

import '../../../../../test/dummy_courses.dart';
import 'all_courses_section/grid_course_card.dart';
import 'all_courses_section/list_course_card.dart';

class AllCoursesSection extends ConsumerStatefulWidget {
  final bool isListView;

  const AllCoursesSection({super.key, required this.isListView});

  @override
  ConsumerState createState() => _AllCoursesSectionState();
}

class _AllCoursesSectionState extends ConsumerState<AllCoursesSection> {
  late final AutoDisposeStateProviderFamily<bool, int> scaleClickProviderFamily;
  late final StateProvider<bool> isCourseClickedProvider;

  @override
  void initState() {
    super.initState();
    scaleClickProviderFamily = AutoDisposeStateProviderFamily((ref, index) => false);
    isCourseClickedProvider = StateProvider((ref) => false);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isListView) {
      return SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(childCount: 7, (context, index) {
            final AutoDisposeStateProvider<bool> provider = scaleClickProviderFamily(index);
            updateScaleClickProvider(bool newValue)=> ref.read(provider.notifier).update((cb) => newValue);
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: AnimatedScale(
                scale: ref.watch(provider) ? 0.85 : 1.0,
                duration: Durations.medium3,
                curve: CustomCurves.defaultIosSpring,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTapDown: (details) {
                    log("Detected tap down...");
                    updateScaleClickProvider(true);
                  },
                  onTapCancel: () {
                    log("Detected tap cancel...");
                    updateScaleClickProvider(false);
                  },
                  onTapUp: (details) async {
                    log("Detected tap up...");
                    await Future.delayed(Durations.short2);
                    updateScaleClickProvider(false);
                  },
                  onTap: () async {
                    final isCourseClickedNotifier = ref.read(isCourseClickedProvider.notifier);
                    if (isCourseClickedNotifier.state) return;
                    isCourseClickedNotifier.update((cb) => true); // Tell that a course is currently opened

                    await Future.delayed(Durations.short4);
                    if (context.mounted) {
                      AppNavigator.to(context).courseDetailsViewRoute(CourseModel.create(courseTitle: "Course title"));
                    }
                   if(context.mounted) isCourseClickedNotifier.update((cb) => false);
                  },
                  child: ListCourseCard(
                    isDarkMode: context.isDarkMode,
                    courseCode: DummyCourses.dummyCourses[index]['courseCode'],
                    courseName: DummyCourses.dummyCourses[index]['courseName'],
                    categoriesCount: DummyCourses.dummyCourses[index]['categoriesCount'],
                    progress: DummyCourses.dummyCourses[index]['progress'],
                  ),
                ),
              ),
            ).animate().fadeIn();
          }),
        ),
      );
    } else {
      return SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        sliver: SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: context.deviceHeight > context.deviceWidth ? 2 : 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
          ),
          delegate: SliverChildBuilderDelegate(childCount: 7, (context, index) {
            final AutoDisposeStateProvider<bool> provider = scaleClickProviderFamily(index);
            updateScaleClickProvider(bool newValue)=> ref.read(provider.notifier).update((cb) => newValue);
            return AnimatedScale(
              scale: ref.watch(provider) ? 0.8 : 1.0,
              duration: Durations.medium3,
              curve: CustomCurves.defaultIosSpring,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTapDown: (details) {
                  log("Detected tap down...");
                  updateScaleClickProvider(true);
                },
                onTapCancel: () {
                  log("Detected tap cancel...");
                  updateScaleClickProvider(false);
                },
                onTapUp: (details) async {
                  log("Detected tap up...");
                  await Future.delayed(Durations.short2);
                  updateScaleClickProvider(false);
                },
                onTap: () async {
                  final isCourseClickedNotifier = ref.read(isCourseClickedProvider.notifier);
                  if (isCourseClickedNotifier.state) return;
                  isCourseClickedNotifier.update((cb) => true); // Tell that a course is currently opened

                  await Future.delayed(Durations.short4);
                  if (context.mounted) {
                    AppNavigator.to(context).courseDetailsViewRoute(CourseModel.create(courseTitle: "Course title"));
                  }
                  isCourseClickedNotifier.update((cb) => false);
                },
                child: GridCourseCard(
                  isDarkMode: context.isDarkMode,
                  courseCode: DummyCourses.dummyCourses[index]['courseCode'],
                  courseName: DummyCourses.dummyCourses[index]['courseName'],
                  categoriesCount: DummyCourses.dummyCourses[index]['categoriesCount'],
                  progress: DummyCourses.dummyCourses[index]['progress'],
                ),
              ),
            ).animate().fadeIn();
          }),
        ),
      );
    }
  }
}
