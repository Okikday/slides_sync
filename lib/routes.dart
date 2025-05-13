import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:heroine/heroine.dart';
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
    ],
  );
}
