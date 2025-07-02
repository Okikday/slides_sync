import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:slides_sync/core/models/file_details.dart';
import 'package:slides_sync/core/utils/image_utils.dart';
import 'package:slides_sync/core/utils/result.dart';
import 'package:slides_sync/data/models/course_model/sub/course_content.dart';

FileDetails fileDetailsFromJson(String source) => FileDetails.fromJson(source);
CourseContent courseContentFromJson(String source) => CourseContent.fromJson(source);

Future<void> addPreviewImageTask(Map<String, dynamic> args) async {
  final Result<bool?> outcome = await Result.tryRunAsync<bool>(() async {
    final RootIsolateToken rootIsolateToken = args['rootIsolateToken'] as RootIsolateToken;
    BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);
    await Future.delayed(Durations.extralong1);
    final List<CourseContent> allContents = (args['courseContentsJsons'] as List<String>).map((e) => courseContentFromJson(e)).toList();
    final List<CourseContent> imageContents = allContents.where((test) => test.courseContentType == CourseContentType.image).toList();
    for (final content in imageContents) {
      final FileDetails fileDetails = fileDetailsFromJson(content.path);
      final String path = fileDetails.filePath;
      final bool fileExists = await File(path).exists();
      if (fileExists) {
        final int stopIndex = path.lastIndexOf(Platform.pathSeparator);
        final String basePath = path.substring(0, stopIndex.clamp(0, path.length));
        final previewDirPath = "$basePath${Platform.pathSeparator}previews";
        final String previewPath = "$previewDirPath${Platform.pathSeparator}${content.id}.${p.basename(path).split('.').last}";
        final bool previewExists = await File(previewPath).exists();
        if (previewExists) {
          log("Preview exists");
          continue;
        } else {
          log("Creating image previews");

          final Result<File> result = await ImageUtils.compressImage(inputFile: File(path), targetMB: 0.05);
          if (result.isSuccess) {

            final String cachePath = result.data!.path;
            await Directory(previewDirPath).create();
            final file = File(cachePath);
            await file.copy(previewPath);
            await file.delete();
          }
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
