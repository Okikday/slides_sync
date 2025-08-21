import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:slides_sync/domain/models/course_model/course.dart';
import 'package:slides_sync/features/manage_all/manage_collections/presentation/views/modify_collections_view.dart';
import 'package:slides_sync/features/manage_all/manage_contents/presentation/views/modify_contents_view.dart';
import 'package:slides_sync/features/manage_all/manage_course/presentation/views/modify_course_view.dart';
import 'package:slides_sync/features/manage_all/manage_course/presentation/views/select_to_modify_course_view.dart';
import 'package:slides_sync/shared/models/type_defs.dart';
import 'package:slides_sync/core/routes/routes_strings.dart';

import '../../../features/manage_all/manage_course/presentation/views/create_course_view.dart';

class CourseMgmtRoutes {
  static List<GoRoute> routes = //COURSE MGMT NAVIGATION
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

    // SELECT TO MODIFY COURSE VIEW NAVIGATION
    GoRoute(
      path: RoutesStrings.selectToModifyCourseView,
      pageBuilder:
          (context, state) => PageAnimation.buildCustomTransitionPage(
            state.pageKey,
            type: TransitionType.rightToLeftWithFade,
            duration: Durations.extralong1,
            reverseDuration: Durations.medium1,
            curve: CustomCurves.defaultIosSpring,
            child: SelectToModifyCourseView(),
          ),
    ),

    //MODIFY COURSE VIEW NAVIGATION
    GoRoute(
      path: RoutesStrings.modifyCourseView,
      pageBuilder:
          (context, state) => PageAnimation.buildCustomTransitionPage(
            state.pageKey,
            type: TransitionType.rightToLeftWithFade,
            duration: Durations.extralong1,
            reverseDuration: Durations.medium1,
            curve: CustomCurves.defaultIosSpring,
            child: ModifyCourseView(course: state.extra as Course),
          ),
      routes: [
        //MODIFY COLLECTIONS VIEW NAVIGATION
        GoRoute(
          path: RoutesStrings.modifyCollectionsView,
          pageBuilder:
              (context, state) => PageAnimation.buildCustomTransitionPage(
                state.pageKey,
                type: TransitionType.fade,
                duration: Durations.medium1,
                reverseDuration: Durations.medium1,
                child: ModifyCollectionsView(courseDbId: (state.extra as Course).id),
              ),
          routes: [
            //MODIFY CONTENTS VIEW NAVIGATION
            GoRoute(
              path: RoutesStrings.modifyContentsView,
              pageBuilder: (context, state) {
                return PageAnimation.buildCustomTransitionPage(
                  state.pageKey,
                  type: TransitionType.rightToLeftWithFade,
                  duration: Durations.extralong1,
                  reverseDuration: Durations.medium1,
                  curve: CustomCurves.defaultIosSpring,
                  child: ModifyContentsView(record: state.extra as ContentRecord<int, CourseCollection, CourseTitleRecord>),
                );
              },
            ),
          ],
        ),
      ],
    ),
  ];
}
