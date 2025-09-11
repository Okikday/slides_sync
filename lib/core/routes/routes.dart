import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:heroine/heroine.dart';
import 'package:slides_sync/core/routes/sub/auth_routes.dart';
import 'package:slides_sync/features/settings/presentation/views/settings_view.dart';
import 'package:slides_sync/core/routes/sub/course_mgmt_routes.dart';
import 'package:slides_sync/core/routes/sub/course_nav_routes.dart';
import 'package:slides_sync/core/routes/sub/home_tabs_routes.dart';
import 'package:slides_sync/core/routes/routes_strings.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

dynamic defaultTransition(
  pageKey, {
  required Widget child,
  TransitionType defaultIncoming = TransitionType.rightToLeft,
}) {
  return PageAnimation.buildCustomTransitionPage(
    pageKey,
    type: TransitionType.paired(
      incoming: defaultIncoming,
      outgoing: TransitionType.slide(begin: const Offset(-0.4, 0), end: const Offset(0, 0)),
      outgoingDuration: Durations.short4,
      reverseDuration: Durations.short4,
      curve: CustomCurves.defaultIosSpring,
      reverseCurve: CustomCurves.defaultIosSpring,
    ),
    duration: Durations.medium4,
    reverseDuration: Durations.medium1,

    child: child,
  );
}

class Routes {
  static final GoRouter mainRouter = _router;

  static final GoRouter _router = GoRouter(
    initialLocation: RoutesStrings.authView,
    navigatorKey: rootNavigatorKey,
    observers: [HeroineController()],
    routes: [
      ...AuthRoutes.routes,
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
              type: TransitionType.rightToLeft,
              duration: Durations.extralong1,
              reverseDuration: Durations.medium1,
              curve: CustomCurves.defaultIosSpring,
              child: const SettingsView(),
            ),
      ),
    ],
  );
}


