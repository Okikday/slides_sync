import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:slides_sync/domain/models/course_model/course.dart';
import 'package:slides_sync/domain/models/file_details.dart';
import 'package:slides_sync/features/content_viewer/domain/services/drive_browser.dart';
import 'package:slides_sync/features/manage_all/manage_contents/domain/repos/get_content_repo/get_content_repo.dart';
import 'package:slides_sync/features/manage_all/manage_contents/presentation/actions/add_link_actions.dart';
import 'package:slides_sync/features/manage_all/manage_contents/usecases/create_contents_uc/create_content_preview_image.dart';

class ContentCardActions {
  static Future<FileDetails> resolvePreviewPath(CourseContent content) async {
    log("Checking for link");
    switch (content.courseContentType) {
      case CourseContentType.link:
        final String? previewUrl = jsonDecode(content.metadataJson)['previewUrl'] as String?;
        if (previewUrl == null || previewUrl.isEmpty) {
          final args = <String, dynamic>{'url': content.path.urlPath, 'driveApiKey': dotenv.env['DRIVE_API_KEY']};
          log("args: $args");
          final Map<String, String?>? previewMap = await compute(_fetchPreviewWorker, args);
          log("After checking internet: $previewMap");
          if (previewMap == null) return FileDetails();
          final PreviewLinkDetails previewLinkDetails = (
            title: previewMap['title'],
            description: previewMap['description'],
            previewUrl: previewMap['previewUrl'],
          );
          if (previewLinkDetails.isEmpty) {
            return FileDetails();
          }
          await AddLinkActions.onAddLinkContent(
            content.path.urlPath,
            parentId: content.parentId,
            previewLinkDetails: previewLinkDetails,
          );

          return FileDetails(urlPath: previewLinkDetails.previewUrl!);
        } else {
          return FileDetails(urlPath: previewUrl);
        }
      default:
        return FileDetails(
          filePath: CreateContentPreviewImage.genPreviewImagePath(filePath: content.path.filePath),
          urlPath: content.path.urlPath,
        );
    }
  }

  static Future<Map<String, String?>?> _fetchPreviewWorker(Map<String, dynamic> args) async {
    final url = args['url'] ?? '';
    // final driveApiKey = args['driveApiKey'];
    // final isDriveLink = DriveBrowser.isGoogleDriveLink(url);
    final PreviewLinkDetails? data;
    data = await GetContentRepo.getLinkPreviewData(url);

    // if (isDriveLink) {
    //   final rawData = await DriveBrowser.fetchResourceFromLink(url, apiKey: driveApiKey);
    //   data = (
    //     title: rawData.file?.name,
    //     description: rawData.file?.description,
    //     previewUrl: rawData.file?.thumbnailLink ?? rawData.file?.iconLink,
    //   );
    // } else {
    //   data = await GetContentRepo.getLinkPreviewData(url);
    // }

    if (data == null) return null;
    return {'title': data.title, 'description': data.description, 'previewUrl': data.previewUrl};
  }
}
