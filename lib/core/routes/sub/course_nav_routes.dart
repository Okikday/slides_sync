import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:slides_sync/core/routes/routes.dart';
import 'package:slides_sync/domain/models/course_model/course.dart';
import 'package:slides_sync/features/course_navigation/presentation/views/course_details_view.dart';
import 'package:slides_sync/core/routes/routes_strings.dart';

class CourseNavRoutes {
  static List<GoRoute> routes = [
    //COURSE NAVIGATION
    GoRoute(
      path: RoutesStrings.courseDetailsView,
      pageBuilder:
          (context, state) => defaultTransition(
            state.pageKey,
            defaultIncoming: TransitionType.fade,
            defaultIncomingDuration: Durations.medium2,
            defaultIncomingCurve: Curves.fastEaseInToSlowEaseOut,
            child: CourseDetailsView(course: state.extra as Course),
          ),
    ),
  ];
}
