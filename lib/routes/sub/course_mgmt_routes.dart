import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:slides_sync/data/models/course_model/course_model.dart';
import 'package:slides_sync/features/modify_all/modify_collections/presentation/views/modify_collections_view.dart';
import 'package:slides_sync/features/modify_all/modify_contents/presentation/views/modify_contents_view.dart';
import 'package:slides_sync/features/modify_all/modify_courses/presentation/views/modify_course_view.dart';
import 'package:slides_sync/features/modify_all/modify_courses/presentation/views/select_to_modify_course_view.dart';
import 'package:slides_sync/shared/models/type_defs.dart';
import 'package:slides_sync/shared/strings/routes_strings.dart';

import '../../features/create_all/create_course/presentation/views/create_course_view.dart';

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
            child: ModifyCourseView(courseModel: state.extra as CourseModel),
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
                child: ModifyCollectionsView(courseDbId: (state.extra as CourseModel).id),
              ),
          routes: [
            //MODIFY CONTENTS VIEW NAVIGATION
            GoRoute(
              path: RoutesStrings.modifyContentsView,
              pageBuilder: (context, state) {
                return PageAnimation.buildCustomTransitionPage(
                  state.pageKey,
                  type: TransitionType.fade,
                  duration: Durations.medium1,
                  reverseDuration: Durations.medium1,
                  child: ModifyContentsView(record: state.extra as ContentRecord<int, CourseSubCollection, CourseTitleRecord>),
                );
              },
            ),
          ],
        ),
      ],
    ),
  ];
}
