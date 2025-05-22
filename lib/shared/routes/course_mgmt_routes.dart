import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:slides_sync/features/course_mgmt/data/models/course_model/course_model.dart';
import 'package:slides_sync/features/course_mgmt/presentation/views/manage_courses_page.dart';
import 'package:slides_sync/features/course_mgmt/presentation/views/modify_course_view.dart';
import 'package:slides_sync/features/home/presentation/views/home_view.dart';
import 'package:slides_sync/shared/strings/routes_strings.dart';

import '../../features/course_mgmt/presentation/views/create_course_view.dart';
import '../../features/course_navigation/presentation/views/course_details_page.dart';

class CourseMgmtRoute {
  static GoRoute route = //COURSE MGMT NAVIGATION
      GoRoute(
    path: RoutesStrings.manageCoursesView,
    pageBuilder:
        (context, state) => PageAnimation.buildCustomTransitionPage(
          state.pageKey,
          type: TransitionType.levelFromTopLeftWithFade,
          duration: Durations.extralong1,
          reverseDuration: Durations.medium1,
          curve: CustomCurves.defaultIosSpring,
          child: ManageCoursesPage(),
        ),
    routes: [
      //CREATE COURSE VIEW NAVIGATION
      GoRoute(
        path: RoutesStrings.createCoursePage,
        pageBuilder:
            (context, state) => PageAnimation.buildCustomTransitionPage(
              state.pageKey,
              type: TransitionType.rightToLeftWithFade,
              duration: Durations.extralong1,
              reverseDuration: Durations.medium1,
              curve: CustomCurves.defaultIosSpring,
              child: CreateCourseView(),
            ),
      ),

      //MODIFY COURSE VIEW NAVIGATION
      GoRoute(
        path: RoutesStrings.modifyCoursePage,
        pageBuilder:
            (context, state) => PageAnimation.buildCustomTransitionPage(
              state.pageKey,
              type: TransitionType.uptown,
              duration: Durations.extralong1,
              reverseDuration: Durations.medium1,
              curve: CustomCurves.defaultIosSpring,
              child: ModifyCourseView(courseModel: state.extra as CourseModel),
            ),
      ),
    ],
  );
}
