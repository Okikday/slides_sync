import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart' as p;
import 'package:pdfrx/pdfrx.dart';
import 'package:slides_sync/core/routes/app_route_navigator.dart';
import 'package:slides_sync/core/utils/result.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/domain/models/course_model/sub/course_content.dart';
import 'package:slides_sync/domain/models/file_details.dart';
import 'package:slides_sync/features/content_viewer/domain/services/drive_browser.dart';
import 'package:slides_sync/features/manage_all/manage_contents/usecases/create_contents_uc/handle_archive_uc.dart';
import 'package:url_launcher/url_launcher.dart';

class ContentViewGateActions {
  static Future<void> redirectToViewer(BuildContext context, CourseContent content) async {
    await Future.delayed(Durations.medium2);
    if (!context.mounted) return;
    switch (content.courseContentType) {
      case CourseContentType.document:
        final filePath = content.path.filePath;
        final urlPath = content.path.urlPath;
        final filenameExt = p.extension(filePath);

        if (filenameExt.toLowerCase().contains("pdf") || p.extension(urlPath).toLowerCase().contains("pdf")) {
          AppRouteNavigator.to(context, isPushedAsReplacement: true).pdfDocumentViewerRoute(content);
          return;
        }
        if(await HandleArchiveUc().isSupportedByArchive(File(filePath))){
          
        }
        return;
      case CourseContentType.image:
        AppRouteNavigator.to(context, isPushedAsReplacement: true).imageViewerRoute(content);
        return;

      case CourseContentType.link:
        final urlPath = content.path.urlPath;
        if (DriveBrowser.isGoogleDriveLink(urlPath)) {
          AppRouteNavigator.to(context, isPushedAsReplacement: true).driveLinkViewerRoute(urlPath);
          return;
        }
        context.pop();
        final bool launchResult =
            (await Result.tryRunAsync(() async => await launchUrl(Uri.parse(urlPath)))).data ?? false;

        if (!launchResult) {
          if (context.mounted) {
            UiUtils.showFlushBar(context, msg: "Unable to open link. Invalid link or try connecting to the internet");
          }
        }
        return;

      default:
        context.pop();
        UiUtils.showFlushBar(context, msg: "This content is not supported right now!");

        return;
    }
  }
}
