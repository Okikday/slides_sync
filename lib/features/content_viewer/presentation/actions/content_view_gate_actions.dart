import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart' as p;
import 'package:pdfrx/pdfrx.dart';
import 'package:slides_sync/core/routes/app_route_navigator.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/domain/models/course_model/sub/course_content.dart';
import 'package:slides_sync/domain/models/file_details.dart';

class ContentViewGateActions {
  static Future<void> redirectToViewer(BuildContext context, CourseContent content) async {
    await Future.delayed(Durations.medium2);
    if (!context.mounted) return;
    switch (content.courseContentType) {
      case CourseContentType.document:
        if(p.extension(content.path.filePath).toLowerCase().substring(1) == "pdf" || p.extension(content.path.urlPath).toLowerCase().substring(1) == "pdf"){
          AppRouteNavigator.to(context, isPushedAsReplacement: true).pdfDocumentViewerRoute(content);
          return;
        }
        return;
      case CourseContentType.image:
        AppRouteNavigator.to(context, isPushedAsReplacement: true).imageViewerRoute(content);
        return;
      default:
        UiUtils.showFlushBar(context, msg: "This content is not supported right now!");
        return;
    }
  }
}
