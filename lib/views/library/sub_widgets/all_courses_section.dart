import 'dart:developer';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/app/models/app_ui_model.dart';
import 'package:slides_sync/app/states/app_ui_state.dart';
import 'package:slides_sync/dummy/dummy_courses.dart';
import 'package:slides_sync/use_cases/library/library_ui_funcs.dart';
import 'package:page_transition/page_transition.dart';
import 'package:slides_sync/views/library/sub_pages/course_details_page.dart';

class ScaleClick extends FamilyNotifier<bool, int> {
  @override
  build(value) => false;
  update(bool value) {
    if (state == value) return;
    state = value;
  }
}

class IsCourseClicked extends Notifier<bool> {
  @override
  build() => false;
  update(bool value) {
    if (state == value) return;
    state = value;
  }
}

class AllCoursesSection extends ConsumerWidget {
  final NotifierProvider<AppUiState, AppUiModel> appUiStateProvider;

  AllCoursesSection(this.appUiStateProvider, {super.key});

  final NotifierProviderFamily<ScaleClick, bool, int> scaleClickProviderFamily = NotifierProviderFamily<ScaleClick, bool, int>(
    ScaleClick.new,
  );

  final NotifierProvider<IsCourseClicked, bool> isCourseClickedProvider = NotifierProvider<IsCourseClicked, bool>(IsCourseClicked.new);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppUiModel appUiModel = ref.watch(appUiStateProvider);
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: appUiModel.deviceHeight > appUiModel.deviceWidth ? 2 : 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
        ),
        delegate: SliverChildBuilderDelegate(childCount: 7, (context, index) {
          final NotifierFamilyProvider<ScaleClick, bool, int> provider = scaleClickProviderFamily(index);
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
                final CourseDetailsPage cachePage = CourseDetailsPage(appUiStateProvider);
                ref.read(isCourseClickedProvider.notifier).update(true); // Tell that a course is currently opened

                await Future.delayed(Durations.short4);

                if (context.mounted) {
                  Navigator.of(context)
                      .push(
                        PageTransition(
                          type: PageTransitionType.bottomToTop,
                          duration: Durations.extralong3,
                          reverseDuration: Durations.medium1,
                          curve: CustomCurves.snappySpring,
                          child: cachePage,
                        ),
                      )
                      .then((value) {
                        ref.read(isCourseClickedProvider.notifier).update(false);
                      });
                }
              },
              child: CourseCard(isDarkMode: appUiModel.isDarkMode,
                courseCode: DummyCourses.dummyCourses[index]['courseCode'],
                courseName: DummyCourses.dummyCourses[index]['courseName'],
                categoriesCount: DummyCourses.dummyCourses[index]['categoriesCount'],
                progress: DummyCourses.dummyCourses[index]['progress'],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class CourseCard extends ConsumerWidget {
  const CourseCard({
    super.key,
    required this.courseCode,
    required this.courseName,
    required this.categoriesCount,
    required this.progress,
    required this.isDarkMode,
    this.dotColor = Colors.transparent,
  });

  final String courseCode;
  final String courseName;
  final int categoriesCount;
  final double progress;
  final bool isDarkMode;
  final Color dotColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Badge(
      backgroundColor: Colors.transparent,
      label: CircleAvatar(radius: 5, backgroundColor: dotColor),
      offset: Offset(-12, 12),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: LibraryUiFuncs.getBoxDecorationStyle(isDarkMode),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(padding: const EdgeInsets.only(top: 4), child: CustomText(courseCode, fontSize: 15, fontWeight: FontWeight.bold)),

            ConstantSizing.columnSpacing(8),

            CustomText(courseName, fontSize: 11, fontWeight: FontWeight.bold),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // CustomText("This is a Content."),
                  CustomText("$categoriesCount categories", fontSize: 14),
                ],
              ),
            ),

            ConstantSizing.columnSpacing(16),
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    minHeight: 16,
                    borderRadius: BorderRadius.circular(36),
                    value: 0.4,
                    backgroundColor: Colors.black.withAlpha(40),
                    color: Colors.deepPurple, //.withAlpha(40)
                  ),
                ),
                ConstantSizing.rowSpacing(8),
                CustomText("${(progress * 100).truncate()}%", fontSize: 12),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
