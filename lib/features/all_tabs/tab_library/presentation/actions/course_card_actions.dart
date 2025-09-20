import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/core/routes/app_route_navigator.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/domain/models/course_model/course.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/providers/library_tab_view_providers.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/views/library_tab_view/expand_card_dialog.dart';
import 'package:slides_sync/core/global_providers/data_providers/course_providers.dart';

class CourseCardActions {
  final WidgetRef ref;
  const CourseCardActions(this.ref);
  static CourseCardActions of(WidgetRef ref) => CourseCardActions(ref);

  BuildContext get context => ref.context;

  void onTapCourseCard(Course course) async {
    final isCourseCardAnimating = LibraryTabViewProviders.isCourseCardAnimating;
    if (isCourseCardAnimating) return;
    LibraryTabViewProviders.isCourseCardAnimating = true; // Tell that a course is currently opened
    ref.read(CourseProviders.courseProvider.notifier).updateCourse(course);
    await Future.delayed(Durations.short4);

    if (context.mounted) AppRouteNavigator.to(context).courseDetailsRoute(course);
    LibraryTabViewProviders.isCourseCardAnimating = false;
  }

  void onHoldCourseCard(Course course) async {
    final Offset? tapPosition = LibraryTabViewProviders.cardTapPositionDetails;
    if (tapPosition == null) return;
    UiUtils.showCustomDialog(
      context,
      blurSigma: Offset(2, 2),
      barrierColor: Colors.black26,
      child: ExpandCardDialog(
        tapPosition: tapPosition,
        course: course,
        onOpen: () {
          UiUtils.hideDialog(context);
          onTapCourseCard(course);
        },
      ),
    );
  }
}
