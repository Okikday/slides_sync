import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:slides_sync/domain/models/course_model/course.dart';
import 'package:slides_sync/shared/models/type_defs.dart';
import 'package:slides_sync/core/routes/routes_strings.dart';

class AppRouteNavigator {
  final BuildContext context;
  final bool _isPushedAsReplacement;
  const AppRouteNavigator(this.context, {bool isPushedAsReplacement = false})
    : _isPushedAsReplacement = isPushedAsReplacement;
  static AppRouteNavigator to(BuildContext context, {bool isPushedAsReplacement = false}) {
    return AppRouteNavigator(context, isPushedAsReplacement: isPushedAsReplacement);
  }

  void _push(String location, {Object? extra}) => context.push(location, extra: extra);

  void _pushAsReplacement(String location, {Object? extra}) => context.pushReplacement(location, extra: extra);

  void contentViewGateRoute(CourseContent content) =>
      _isPushedAsReplacement
          ? _pushAsReplacement(
            "${RoutesStrings.courseDetailsView}${RoutesStrings.courseMaterialsView}${RoutesStrings.contentViewGate}",
            extra: content,
          )
          : _push(
            "${RoutesStrings.courseDetailsView}${RoutesStrings.courseMaterialsView}${RoutesStrings.contentViewGate}",
            extra: content,
          );

  void courseDetailsRoute(Course course) =>
      _isPushedAsReplacement
          ? _pushAsReplacement(RoutesStrings.courseDetailsView, extra: course)
          : _push(RoutesStrings.courseDetailsView, extra: course);

  void courseMaterialsRoute(CourseCollection collection) =>
      _isPushedAsReplacement
          ? _pushAsReplacement(
            "${RoutesStrings.courseDetailsView}${RoutesStrings.courseMaterialsView}",
            extra: collection,
          )
          : _push("${RoutesStrings.courseDetailsView}${RoutesStrings.courseMaterialsView}", extra: collection);

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
    final route = "${RoutesStrings.modifyCourseView}${RoutesStrings.modifyCollectionsView}";
    _isPushedAsReplacement ? _pushAsReplacement(route, extra: course) : _push(route, extra: course);
  }

  void modifyContentsRoute(ContentRecord record) {
    final route =
        "${RoutesStrings.modifyCourseView}${RoutesStrings.modifyCollectionsView}${RoutesStrings.modifyContentsView}";
    _isPushedAsReplacement ? _pushAsReplacement(route, extra: record) : _push(route, extra: record);
  }

  void settingsRoute() {
    final route = RoutesStrings.settingsView;
    _isPushedAsReplacement ? _pushAsReplacement(route) : _push(route);
  }

  /// Viewers
  void pdfDocumentViewerRoute(CourseContent content) {
    // resolve viewer
    final route = RoutesStrings.pdfDocumentViewer;
    _isPushedAsReplacement ? _pushAsReplacement(route, extra: content) : _push(route, extra: content);
  }

  void imageViewerRoute(CourseContent content) {
    final route = RoutesStrings.imageViewer;
    _isPushedAsReplacement ? _pushAsReplacement(route, extra: content) : _push(route, extra: content);
  }

  void driveLinkViewerRoute(String content) {
    final route = RoutesStrings.driveLinkViewer;
    _isPushedAsReplacement ? _pushAsReplacement(route, extra: content) : _push(route, extra: content);
  }
}
