import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:slides_sync/features/course_mgmt/data/models/course_model/course_model.dart';
import 'package:slides_sync/features/course_mgmt/presentation/views/course_collections_view.dart';
import 'package:slides_sync/features/course_mgmt/presentation/views/modify_course_view.dart';
import 'package:slides_sync/features/course_mgmt/presentation/views/select_to_modify_course_view.dart';
import 'package:slides_sync/shared/strings/routes_strings.dart';

import '../../features/course_mgmt/presentation/views/create_course_view.dart';

class CourseMgmtRoutes {
  static List<GoRoute> route = //COURSE MGMT NAVIGATION
      [
    //CREATE COURSE VIEW NAVIGATION
    GoRoute(
      path: RoutesStrings.createCourseView,
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

    // // SELECT TO MODIFY COURSE VIEW NAVIGATION
    // GoRoute(
    //   path: RoutesStrings.selectToModifyCourseView,
    //   pageBuilder:
    //       (context, state) => PageAnimation.buildCustomTransitionPage(
    //         state.pageKey,
    //         type: TransitionType.rightToLeftWithFade,
    //         duration: Durations.extralong1,
    //         reverseDuration: Durations.medium1,
    //         curve: CustomCurves.defaultIosSpring,
    //         child: SelectToModifyCourseView(),
    //       ),
    // ),

    //MODIFY COURSE VIEW NAVIGATION
    GoRoute(
      path: RoutesStrings.modifyCourseView,
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

    //COURSE COLLECTIONS VIEW NAVIGATION
    GoRoute(
      path: RoutesStrings.courseCollectionsView,
      pageBuilder:
          (context, state) => PageAnimation.buildCustomTransitionPage(
            state.pageKey,
            type: TransitionType.fade,
            duration: Durations.medium1,
            reverseDuration: Durations.medium1,
            child: CourseCollectionsView(courseModel: state.extra as CourseModel),
          ),
    ),
  ];
}
