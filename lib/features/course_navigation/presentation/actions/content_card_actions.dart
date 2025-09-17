import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:slides_sync/domain/models/course_model/course.dart';
import 'package:slides_sync/domain/models/file_details.dart';
import 'package:slides_sync/features/manage_all/manage_contents/domain/repos/get_content_repo/get_content_repo.dart';
import 'package:slides_sync/features/manage_all/manage_contents/presentation/actions/add_link_actions.dart';
import 'package:slides_sync/features/manage_all/manage_contents/usecases/create_contents_uc/create_content_preview_image.dart';

class ContentCardActions {
  static Future<FileDetails> resolvePreviewPath(CourseContent content) async {
    switch (content.courseContentType) {
      case CourseContentType.link:
        final String? previewUrl = jsonDecode(content.metadataJson)['previewUrl'] as String?;
        if (previewUrl == null || previewUrl.isEmpty) {
          final Map<String, String?>? previewMap = await compute(_fetchPreviewWorker, content.path.urlPath);
          if (previewMap == null) return FileDetails();
          final PreviewLinkDetails previewLinkDetails = (
            title: previewMap['title'],
            description: previewMap['description'],
            previewUrl: previewMap['previewUrl'],
          );
          if (previewLinkDetails.isEmpty || previewLinkDetails.previewUrl == null) {
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

  static Future<Map<String, String?>?> _fetchPreviewWorker(String url) async {
    final data = await GetContentRepo.getLinkPreviewData(url);
    if (data == null) return null;
    return {'title': data.title, 'description': data.description, 'previewUrl': data.previewUrl};
  }
}
