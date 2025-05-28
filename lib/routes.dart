import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:heroine/heroine.dart';
import 'package:slides_sync/features/course_mgmt/data/models/course_model/course_model.dart';
import 'package:slides_sync/features/course_navigation/presentation/views/course_details_page.dart';
import 'package:slides_sync/shared/routes/course_mgmt_routes.dart';
import 'package:slides_sync/shared/routes/home_tabs_routes.dart';
import 'package:slides_sync/shared/strings/routes_strings.dart';

class Routes {
  static final GoRouter mainRouter = _router;

  static final GoRouter _router = GoRouter(
    initialLocation: RoutesStrings.homeView,
    observers: [HeroineController()],
    routes: [
      // Home, Library, Explore tabs
      ...HomeTabsRoutes.routes,

      // MANAGE COURSES
      // -> CREATE COURSE
      // -> SELECT TO MODIFY COURSE / MODIFY EXISTING COURSE
      // -> MODIFY COURSE
      //    -> EDIT COURSE
      ...CourseMgmtRoutes.route,

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
              child: CourseDetailsPage(courseModel: state.extra as CourseModel),
            ),
      ),
    ],
  );
}
