import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:slides_sync/core/utils/basic_utils.dart';
import 'package:slides_sync/domain/models/course_model/sub/course_collection.dart';
import 'package:slides_sync/domain/models/course_model/sub/course_content.dart';
import 'package:slides_sync/domain/models/file_details.dart';
import 'package:slides_sync/domain/repos/course_repo/course_collection_repo.dart';
import 'package:slides_sync/features/manage_all/manage_contents/domain/repos/get_content_repo/get_content_repo.dart';
import 'package:super_clipboard/super_clipboard.dart';



class AddLinkActions {
  static Future<bool> onAddLinkContent(
    String link, {
    required String parentId,
    required PreviewLinkDetails previewLinkDetails,
  }) async {
    log("previewLinkDetails: $previewLinkDetails");
    if(parentId.isEmpty) return false;
    final collection = await CourseCollectionRepo.getById(parentId);
    if(collection == null) return false;
    final contentHash = BasicUtils.calculateStringHash(link);
    final CourseContent? sameHashedContent = await CourseCollectionRepo.findFirstDuplicateContentByHash(
      collection,
      contentHash,
    );
    final CourseContent newContent;
    if (sameHashedContent != null) {
      if (contentHash == sameHashedContent.contentHash && link == sameHashedContent.path.fileDetails.urlPath) {
        log("They are the same, modify");
        newContent = sameHashedContent.copyWith(
          contentHash: contentHash,
          title: previewLinkDetails.title != "Unknown link" ? previewLinkDetails.title : "Unknown link",
          description: previewLinkDetails.description != '' ? previewLinkDetails.description : '',
          metadataJson: jsonEncode({
            ...jsonDecode(sameHashedContent.metadataJson),
            'previewUrl': previewLinkDetails.previewUrl,
          }),
        );
        return await CourseCollectionRepo.addContent(newContent);
      }
    } else {
      newContent = CourseContent.create(
        contentHash: contentHash,
        parentId: collection.collectionId,
        title: previewLinkDetails.title ?? "Unknown link",
        description: previewLinkDetails.description ?? '',
        path: FileDetails(urlPath: link),
        courseContentType: CourseContentType.link,
        metadataJson: jsonEncode({'previewUrl': previewLinkDetails.previewUrl}),
      );
      return await CourseCollectionRepo.addContent(newContent);
    }
    return false;
  }

  static void pasteFromClipboard(TextEditingController linkInputController) async {
    final clipboard = SystemClipboard.instance;
    if (clipboard == null) return;

    final reader = await clipboard.read();

    // Check for URI first (links have priority)
    if (reader.canProvide(Formats.uri)) {
      final NamedUri? namedUri = await reader.readValue(Formats.uri);
      if (namedUri != null && namedUri.uri.toString().isNotEmpty) {
        linkInputController.text = namedUri.uri.toString();
        return;
      }
    }

    // Fallback to plain text and validate if it's a link
    if (reader.canProvide(Formats.plainText)) {
      final String? clipboardText = await reader.readValue(Formats.plainText);
      if (clipboardText != null && clipboardText.isNotEmpty) {
        final text = clipboardText.trim();

        // Try to extract link from text
        final extractedLink = _extractLinkFromText(text);
        if (extractedLink != null) {
          linkInputController.text = extractedLink;
          return;
        }

        // If no link found but text exists, use it as fallback
        linkInputController.text = text;
      }
    }
  }

  static String? _extractLinkFromText(String text) {
    // Check if entire text is a valid URL
    final uri = Uri.tryParse(text);
    if (uri != null && _isValidWebUrl(uri)) {
      return text;
    }

    // Look for URLs within the text using regex
    final urlRegex = RegExp(r'https?://[^\s<>"{}|\\^`\[\]]+', caseSensitive: false, multiLine: true);

    final matches = urlRegex.allMatches(text);
    if (matches.isNotEmpty) {
      // Return the most recent (last) link found
      return matches.last.group(0);
    }

    // Look for www. patterns and add https://
    final wwwRegex = RegExp(r'www\.[^\s<>"{}|\\^`\[\]]+', caseSensitive: false, multiLine: true);

    final wwwMatches = wwwRegex.allMatches(text);
    if (wwwMatches.isNotEmpty) {
      return 'https://${wwwMatches.last.group(0)}';
    }

    return null;
  }

  static bool _isValidWebUrl(Uri uri) {
    return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https' || uri.scheme == 'ftp') && uri.hasAuthority;
  }
}
