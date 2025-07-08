import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:slides_sync/data/models/course_model/course_model.dart';
import 'package:slides_sync/features/course_navigation/presentation/views/course_details_view.dart';
import 'package:slides_sync/shared/strings/routes_strings.dart';

class CourseNavRoutes {
  static List<GoRoute> routes = [
    //COURSE NAVIGATION
    GoRoute(
      path: RoutesStrings.courseDetailsView,
      pageBuilder:
          (context, state) => PageAnimation.buildCustomTransitionPage(
            state.pageKey,
            type: TransitionType.topLevel,
            duration: Durations.extralong1,
            reverseDuration: Durations.medium1,
            curve: CustomCurves.defaultIosSpring,
            child: CourseDetailsView(courseModel: state.extra as CourseModel),
          ),
    ),
  ];
}
