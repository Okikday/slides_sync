import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:heroine/heroine.dart';
import 'package:slides_sync/data/models/course_model/course_model.dart';
import 'package:slides_sync/features/course_navigation/presentation/views/course_details_view.dart';
import 'package:slides_sync/features/settings/presentation/views/settings_view.dart';
import 'package:slides_sync/routes/sub/course_mgmt_routes.dart';
import 'package:slides_sync/routes/sub/course_nav_routes.dart';
import 'package:slides_sync/routes/sub/home_tabs_routes.dart';
import 'package:slides_sync/routes/routes_strings.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

class Routes {
  static final GoRouter mainRouter = _router;

  static final GoRouter _router = GoRouter(
    initialLocation: RoutesStrings.homeView,
    navigatorKey: rootNavigatorKey,
    observers: [HeroineController()],
    routes: [
      // Home, Library, Explore tabs
      ...HomeTabsRoutes.routes,

      // MANAGE COURSES
      // -> CREATE COURSE
      // -> SELECT TO MODIFY COURSE / MODIFY EXISTING COURSE
      // -> MODIFY COURSE
      //    -> EDIT COURSE
      ...CourseMgmtRoutes.routes,

      ...CourseNavRoutes.routes,

      // SETTINGS ROUTE
      GoRoute(
        path: RoutesStrings.settingsView,
        pageBuilder:
            (context, state) => PageAnimation.buildCustomTransitionPage(
              state.pageKey,
              type: TransitionType.scaleFromLeftCenter,
              duration: Durations.extralong1,
              reverseDuration: Durations.medium1,
              curve: CustomCurves.defaultIosSpring,
              child: const SettingsView(),
            ),
      ),
    ],
  );
}
