import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:slides_sync/shared/models/course_model/course_model.dart';
import 'package:slides_sync/shared/strings/routes_strings.dart';

class AppNavigator {
  final BuildContext context;
  final bool _isPushedAsReplacement;
  AppNavigator(this.context, {bool isPushedAsReplacement = false}) : _isPushedAsReplacement = isPushedAsReplacement;
  static AppNavigator of(BuildContext context, {bool isPushedAsReplacement = false}) {
    return AppNavigator(context, isPushedAsReplacement: isPushedAsReplacement);
  }

  void _push(String location, {Object? extra}) => context.push(location, extra: extra);

  void _pushAsReplacement(String location, {Object? extra}) => context.go(location, extra: extra);

  void courseDetailsPageRoute(CourseModel courseModel) =>
      _isPushedAsReplacement
          ? _pushAsReplacement(RoutesStrings.courseDetailsView, extra: courseModel)
          : _push(RoutesStrings.courseDetailsView, extra: courseModel);

  // void manageCoursesPageRoute(){}

  void createCoursePageRoute() =>
      _isPushedAsReplacement ? _pushAsReplacement(RoutesStrings.createCoursePage) : _push(RoutesStrings.createCoursePage);

  void modifyCourseViewRoute(CourseModel courseModel) =>
      _isPushedAsReplacement
          ? _pushAsReplacement(RoutesStrings.modifyCoursePage, extra: courseModel)
          : _push(RoutesStrings.modifyCoursePage, extra: courseModel);



}
