import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:slides_sync/data/models/course_model/course_model.dart';
import 'package:slides_sync/shared/models/type_defs.dart';
import 'package:slides_sync/shared/strings/routes_strings.dart';

class AppNavigator {
  final BuildContext context;
  final bool _isPushedAsReplacement;
  AppNavigator(this.context, {bool isPushedAsReplacement = false}) : _isPushedAsReplacement = isPushedAsReplacement;
  static AppNavigator to(BuildContext context, {bool isPushedAsReplacement = false}) {
    return AppNavigator(context, isPushedAsReplacement: isPushedAsReplacement);
  }

  void _push(String location, {Object? extra}) => context.push(location, extra: extra);

  void _pushAsReplacement(String location, {Object? extra}) => context.go(location, extra: extra);

  void courseDetailsRoute(CourseModel courseModel) =>
      _isPushedAsReplacement
          ? _pushAsReplacement(RoutesStrings.courseDetailsView, extra: courseModel)
          : _push(RoutesStrings.courseDetailsView, extra: courseModel);

  void createCourseRoute() {
    final route = RoutesStrings.createCourseView;
    _isPushedAsReplacement ? _pushAsReplacement(route) : _push(route);
  }

  void modifyCourseRoute(CourseModel courseModel) {
    final route = RoutesStrings.modifyCourseView;
    _isPushedAsReplacement ? _pushAsReplacement(route, extra: courseModel) : _push(route, extra: courseModel);
  }

  // void modifyExistingCoursesRoute(){
  //   final route = RoutesStrings.selectToModifyCourseView;
  //   _isPushedAsReplacement ? _pushAsReplacement(route) : _push(route);
  // }

  void modifyCollectionsRoute(CourseModel courseModel) {
    final route = "${RoutesStrings.modifyCourseView}/${RoutesStrings.modifyCollectionsView}";
    _isPushedAsReplacement ? _pushAsReplacement(route, extra: courseModel) : _push(route, extra: courseModel);
  }

  void modifyContentsRoute(ContentRecord record) {
    final route = "${RoutesStrings.modifyCourseView}/${RoutesStrings.modifyCollectionsView}/${RoutesStrings.modifyContentsView}";
    _isPushedAsReplacement ? _pushAsReplacement(route, extra: record) : _push(route, extra: record);
  }

  // void courseMaterialsPageRoute(){
  //   final route =
  // }
}
