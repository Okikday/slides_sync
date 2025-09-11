import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:slides_sync/core/routes/app_route_navigator.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/domain/models/course_model/sub/course_content.dart';

class ContentViewGateActions {
  static Future<void> redirectToViewer(BuildContext context, CourseContent content) async {
    await Future.delayed(Durations.medium4);
    if (!context.mounted) return;
    switch (content.courseContentType) {
      case CourseContentType.document:
        AppRouteNavigator.to(context, isPushedAsReplacement: true).documentViewerRoute(content);
        break;
      case CourseContentType.image:
        AppRouteNavigator.to(context, isPushedAsReplacement: true).imageViewerRoute(content);
      default:
        UiUtils.showFlushBar(context, msg: "This content is not supported right now!");
    }
  }
}
