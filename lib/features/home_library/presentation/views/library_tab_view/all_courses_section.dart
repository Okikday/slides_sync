import 'dart:developer';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:page_transition/page_transition.dart';
import 'package:slides_sync/core/usecases/app_navigator.dart';
import 'package:slides_sync/core/utils/app_ui_state.dart';
import 'package:slides_sync/features/course_navigation/presentation/views/course_details_page.dart';
import 'package:slides_sync/features/home_library/presentation/viewmodels/notifiers/course_card_scale_click_family_notifier.dart';
import 'package:slides_sync/features/home_library/presentation/viewmodels/notifiers/is_course_card_clicked_notifier.dart';
import 'package:slides_sync/features/home_library/presentation/views/library_tab_view/all_courses_section/grid_course_card.dart';
import 'package:slides_sync/features/home_library/presentation/views/library_tab_view/all_courses_section/list_course_card.dart';
import 'package:slides_sync/shared/models/course_model/course_model.dart';

import '../../../../../test/dummy_courses.dart';

class AllCoursesSection extends ConsumerStatefulWidget {
  final NotifierProvider<AppUiState, AppUiModel> appUiStateProvider;
  final bool isListView;

  const AllCoursesSection(this.appUiStateProvider, {super.key, required this.isListView});

  @override
  ConsumerState createState() => _AllCoursesSectionState();
}

class _AllCoursesSectionState extends ConsumerState<AllCoursesSection> {
  late final NotifierProviderFamily<CourseCardScaleClickFamilyNotifier, bool, int> scaleClickProviderFamily;

  late final NotifierProvider<IsCourseCardClickedNotifier, bool> isCourseClickedProvider;

  @override
  void initState() {
    super.initState();
    scaleClickProviderFamily = NotifierProviderFamily<CourseCardScaleClickFamilyNotifier, bool, int>(
      CourseCardScaleClickFamilyNotifier.new,
    );
    isCourseClickedProvider = NotifierProvider<IsCourseCardClickedNotifier, bool>(IsCourseCardClickedNotifier.new);
  }

  @override
  Widget build(BuildContext context) {
    final AppUiModel appUiModel = ref.watch(appUiStateProvider);

    if (widget.isListView) {
      return SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(childCount: 7, (context, index) {
            final NotifierFamilyProvider<CourseCardScaleClickFamilyNotifier, bool, int> provider = scaleClickProviderFamily(index);
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
                    ref.read(provider.notifier).update(true);
                  },
                  onTapCancel: () {
                    log("Detected tap cancel...");
                    ref.read(provider.notifier).update(false);
                  },
                  onTapUp: (details) async {
                    log("Detected tap up...");
                    await Future.delayed(Durations.short2);
                    ref.read(provider.notifier).update(false);
                  },
                  onTap: () async {
                    final bool isCourseOpen = ref.watch(isCourseClickedProvider);
                    if (isCourseOpen) return;
                    final CourseDetailsPage cachePage = CourseDetailsPage();
                    ref.read(isCourseClickedProvider.notifier).update(true); // Tell that a course is currently opened

                    await Future.delayed(Durations.short4);
                    if (context.mounted) {
                      AppNavigator.of(context).courseDetailsPageRoute(CourseModel(courseId: "Example", courseTitle: "Course title"));
                    }
                    ref.read(isCourseClickedProvider.notifier).update(false);
                  },
                  child: ListCourseCard(
                    isDarkMode: appUiModel.isDarkMode,
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
            crossAxisCount: appUiModel.deviceHeight > appUiModel.deviceWidth ? 2 : 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
          ),
          delegate: SliverChildBuilderDelegate(childCount: 7, (context, index) {
            final NotifierFamilyProvider<CourseCardScaleClickFamilyNotifier, bool, int> provider = scaleClickProviderFamily(index);
            return AnimatedScale(
              scale: ref.watch(provider) ? 0.8 : 1.0,
              duration: Durations.medium3,
              curve: CustomCurves.defaultIosSpring,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTapDown: (details) {
                  log("Detected tap down...");
                  ref.read(provider.notifier).update(true);
                },
                onTapCancel: () {
                  log("Detected tap cancel...");
                  ref.read(provider.notifier).update(false);
                },
                onTapUp: (details) async {
                  log("Detected tap up...");
                  await Future.delayed(Durations.short2);
                  ref.read(provider.notifier).update(false);
                },
                onTap: () async {
                  final bool isCourseOpen = ref.watch(isCourseClickedProvider);
                  if (isCourseOpen) return;
                  final CourseDetailsPage cachePage = CourseDetailsPage();
                  ref.read(isCourseClickedProvider.notifier).update(true); // Tell that a course is currently opened

                  await Future.delayed(Durations.short4);
                  if (context.mounted) {
                    AppNavigator.of(context).courseDetailsPageRoute(CourseModel(courseId: "Example", courseTitle: "Course title"));
                  }
                  ref.read(isCourseClickedProvider.notifier).update(false);
                },
                child: GridCourseCard(
                  isDarkMode: appUiModel.isDarkMode,
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
