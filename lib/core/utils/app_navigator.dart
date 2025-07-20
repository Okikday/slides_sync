import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:slides_sync/data/models/course_model/course.dart';
import 'package:slides_sync/shared/models/type_defs.dart';
import 'package:slides_sync/routes/routes_strings.dart';

class AppNavigator {
  final BuildContext context;
  final bool _isPushedAsReplacement;
  AppNavigator(this.context, {bool isPushedAsReplacement = false}) : _isPushedAsReplacement = isPushedAsReplacement;
  static AppNavigator to(BuildContext context, {bool isPushedAsReplacement = false}) {
    return AppNavigator(context, isPushedAsReplacement: isPushedAsReplacement);
  }

  void _push(String location, {Object? extra}) => context.push(location, extra: extra);

  void _pushAsReplacement(String location, {Object? extra}) => context.go(location, extra: extra);

  void courseDetailsRoute(Course course) =>
      _isPushedAsReplacement
          ? _pushAsReplacement(RoutesStrings.courseDetailsView, extra: course)
          : _push(RoutesStrings.courseDetailsView, extra: course);

  void createCourseRoute() {
    final route = RoutesStrings.createCourseView;
    _isPushedAsReplacement ? _pushAsReplacement(route) : _push(route);
  }

  void modifyCourseRoute(Course course) {
    final route = RoutesStrings.modifyCourseView;
    _isPushedAsReplacement ? _pushAsReplacement(route, extra: course) : _push(route, extra: course);
  }

  void modifyExistingCoursesRoute() {
    final route = RoutesStrings.selectToModifyCourseView;
    _isPushedAsReplacement ? _pushAsReplacement(route) : _push(route);
  }

  void modifyCollectionsRoute(Course course) {
    final route = "${RoutesStrings.modifyCourseView}/${RoutesStrings.modifyCollectionsView}";
    _isPushedAsReplacement ? _pushAsReplacement(route, extra: course) : _push(route, extra: course);
  }

  void modifyContentsRoute(ContentRecord record) {
    final route = "${RoutesStrings.modifyCourseView}/${RoutesStrings.modifyCollectionsView}/${RoutesStrings.modifyContentsView}";
    _isPushedAsReplacement ? _pushAsReplacement(route, extra: record) : _push(route, extra: record);
  }

  void settingsRoute() {
    final route = RoutesStrings.settingsView;
    _isPushedAsReplacement ? _pushAsReplacement(route) : _push(route);
  }
}
