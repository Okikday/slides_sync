import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:slides_sync/features/course_mgmt/data/models/course_model/course_model.dart';
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

  void courseDetailsViewRoute(CourseModel courseModel) =>
      _isPushedAsReplacement
          ? _pushAsReplacement(RoutesStrings.courseDetailsView, extra: courseModel)
          : _push(RoutesStrings.courseDetailsView, extra: courseModel);

  void createCoursePageRoute() {
    final route = "${RoutesStrings.manageCoursesView}/${RoutesStrings.createCoursePage}";
    _isPushedAsReplacement ? _pushAsReplacement(route) : _push(route);
  }

  void modifyCoursePageRoute(CourseModel courseModel) {
    final route = "${RoutesStrings.manageCoursesView}/${RoutesStrings.modifyCoursePage}";
    _isPushedAsReplacement ? _pushAsReplacement(route, extra: courseModel) : _push(route, extra: courseModel);
  }

  void modifyExistingCoursesRoute(){
    final route = "${RoutesStrings.manageCoursesView}/${RoutesStrings.selectToModifyCoursePage}";
    _isPushedAsReplacement ? _pushAsReplacement(route) : _push(route);
  }

  // void courseMaterialsPageRoute(){
  //   final route =
  // }

}
