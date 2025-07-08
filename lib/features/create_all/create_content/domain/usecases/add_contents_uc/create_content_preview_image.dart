import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:slides_sync/core/models/file_details.dart';
import 'package:slides_sync/core/utils/image_utils.dart';
import 'package:slides_sync/core/utils/result.dart';
import 'package:slides_sync/data/models/course_model/sub/course_content.dart';

typedef PreviewImagePathRecord<Record> = ({String previewDirPath, String previewPath});

class CreateContentPreviewImage {
  /// Returns the preview path where the image file is stored at after making a compressed version of the image
  static Future<String?> _createForTypeImage(String path, PreviewImagePathRecord previewPathRecord) async {
    log("Creating preview for Type Image");
    final Result<File> result = await ImageUtils.compressImage(inputFile: File(path), targetMB: 0.05, outputFormat: 'png');
    if (result.isSuccess) {
      final String cachePath = result.data!.path;
      await Directory(previewPathRecord.previewDirPath).create();
      final file = File(cachePath);
      final copyToPath = previewPathRecord.previewPath;
      await file.copy(copyToPath);
      await file.delete();
      return copyToPath;
    }
    return null;
  }

  void createForTypeDocument() {}
  void createForTypeLink() {}

  static Future<void> createPreviewImageForContent(
    String path, {
    required CourseContentType courseContentType,
    required PreviewImagePathRecord genPreviewPathRecord,
  }) async {
    switch (courseContentType) {
      case CourseContentType.image:
        await _createForTypeImage(path, genPreviewPathRecord);
        break;
      default:
        break;
    }
    return;
  }

  static String genPreviewImagePath({required String filePath, required String contentId}) =>
      genPreviewImagePathRecord(filePath: filePath, contentId: contentId).previewPath;

  static PreviewImagePathRecord genPreviewImagePathRecord({required String filePath, required String contentId}) {
    final int lastIndexOfPathSep = filePath.lastIndexOf(Platform.pathSeparator);
    if (lastIndexOfPathSep == -1) {
      return (previewPath: '', previewDirPath: '');
    } else {
      final sep = Platform.pathSeparator;
      final previewDirPath =
          "${filePath.substring(0, lastIndexOfPathSep.clamp(0, filePath.length))}$sep"
          "preview_images";
      final previewPath = "$previewDirPath$sep$contentId";
      return (previewPath: previewPath, previewDirPath: previewDirPath);
    }
  }

  static FileDetails fileDetailsFromJson(String source) => FileDetails.fromJson(source);
  static CourseContent courseContentFromJson(String source) => CourseContent.fromJson(source);

  /// Adding lots of contents image preview in Background/Isolate
  static Future<void> createPreviewImagesTask(Map<String, dynamic> args) async {
    final Result<bool?> outcome = await Result.tryRunAsync<bool>(() async {
      final RootIsolateToken rootIsolateToken = args['rootIsolateToken'] as RootIsolateToken;
      BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);

      final List<CourseContent> allContents = (args['courseContentsJsons'] as List<String>).map((e) => courseContentFromJson(e)).toList();

      for (int i = 0; i < allContents.length; i++) {
        final content = allContents[i];
        final String path = fileDetailsFromJson(content.path).filePath;
        final bool fileExists = await File(path).exists();
        if (fileExists) {
          final genPreviewPathRecord = genPreviewImagePathRecord(filePath: path, contentId: content.id);
          final previewPath = genPreviewPathRecord.previewPath;

          final bool previewExists = await File(previewPath).exists();
          if (previewExists) {
            continue;
          } else {
            log("Creating preview image");

            await createPreviewImageForContent(
              path,
              courseContentType: content.courseContentType,
              genPreviewPathRecord: genPreviewPathRecord,
            );
          }
        }
      }
      return true;
    });
    if (outcome.isSuccess) {
      log("Loaded image previews");
    } else {
      log("An exception occured!");
    }
  }

  static Future<List<CourseContent>> filterContentsWithoutPreview(List<CourseContent> courseContents) async {
    final List<CourseContent> nonExistingPreviewCourseContents = [];
    for (final content in courseContents) {
      final String previewPath = genPreviewImagePath(filePath: content.path.filePath, contentId: content.id);
      if (previewPath.isEmpty) continue;
      if (!(await File(previewPath).exists())) {
        nonExistingPreviewCourseContents.add(content);
      }
    }
    return nonExistingPreviewCourseContents;
  }
}
