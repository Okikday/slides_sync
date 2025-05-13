import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:heroine/heroine.dart';
import 'package:slides_sync/features/course_mgmt/presentation/views/manage_courses/create_course_view.dart';
import 'package:slides_sync/features/course_mgmt/presentation/views/manage_courses/create_course_view/modify_course_view.dart';
import 'package:slides_sync/features/course_navigation/presentation/views/course_details_page.dart';
import 'package:slides_sync/shared/models/course_model/course_model.dart';
import 'package:slides_sync/shared/strings/routes_strings.dart';

import 'features/home/presentation/views/home_view.dart';

class Routes {
  static final GoRouter mainRouter = _router;

  static final GoRouter _router = GoRouter(
    initialLocation: RoutesStrings.homeView,
    observers: [HeroineController()],
    routes: [
      // HOME ROUTE
      GoRoute(
        path: RoutesStrings.homeView,
        pageBuilder: (context, state) => PageAnimation.buildCustomTransitionPage(state.pageKey, child: HomeView(tabIndex: 0)),
      ),

      // LIBRARY ROUTE
      GoRoute(
        path: RoutesStrings.libraryView,
        pageBuilder: (context, state) => PageAnimation.buildCustomTransitionPage(state.pageKey, child: HomeView(tabIndex: 1)),
      ),

      // EXPLORE ROUTE
      GoRoute(
        path: RoutesStrings.exploreView,
        pageBuilder: (context, state) => PageAnimation.buildCustomTransitionPage(state.pageKey, child: HomeView(tabIndex: 1)),
      ),

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
              child: CourseDetailsPage(),
            ),
      ),

      // //COURSE MGMT NAVIGATION
      // GoRoute(
      //   path: RoutesStrings.manageCoursesPage,
      //   pageBuilder:
      //       (context, state) => PageAnimation.buildCustomTransitionPage(
      //     state.pageKey,
      //     type: TransitionType.levelFromTopLeftWithFade,
      //     duration: Durations.extralong1,
      //     reverseDuration: Durations.medium1,
      //     curve: CustomCurves.defaultIosSpring,
      //     child: CourseDetailsPage(),
      //   ),
      // ),


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
