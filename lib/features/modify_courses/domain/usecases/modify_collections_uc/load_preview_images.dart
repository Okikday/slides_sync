import 'dart:developer';
import 'dart:io';

import 'package:slides_sync/core/models/file_details.dart';
import 'package:slides_sync/core/utils/image_utils.dart';
import 'package:slides_sync/core/utils/result.dart';
import 'package:slides_sync/data/models/course_model/sub/course_content.dart';

Future<void> addPreviewImageTask(Map<String, dynamic> arg, void Function(void) emitProgress, void Function(void) emitResult) async {
  final result = await Result.tryRunAsync(() async {
    final List<CourseContent> imageContents =
        (arg['courseContentsJsons'] as List<String>)
            .where((test) => CourseContent.fromJson(test).courseContentType == CourseContentType.image)
            .toList()
            .map((toElement) => CourseContent.fromJson(toElement))
            .toList();
    for (final content in imageContents) {
      final FileDetails fileDetails = FileDetails.fromJson(content.path);
      final String path = fileDetails.filePath;

      if (File(path).existsSync()) {
        final int stopIndex = path.split(Platform.pathSeparator).lastIndexOf(Platform.pathSeparator);
        log("fullPath: ${path}");
        final String basePath = path.substring(0, stopIndex.clamp(0, stopIndex));
        log("basePath: ${basePath}");
        // final String previewPath =
        //     "${path.isEmpty ? '' : path.substring(0, stopIndex.clamp(0, stopIndex))}${Platform.pathSeparator}previews${Platform.pathSeparator}${content.id}";
        // final bool previewExists = await File(previewPath).exists();
        // if (previewExists) {
        //   continue;
        // } else {
        //   final Result<File> result = await ImageUtils().compressImage(inputFile: File(path), targetMB: 0.05);
        //   if (result.isSuccess) {
        //     await result.data!.copy(previewPath);
        //     await result.data!.delete();
        //   }
        // }
      }
    }
  });
  if (result.isSuccess) {
    log("Added preview files");
  } else {
    log("An exception occured! - ghtslkld");
  }
  emitResult("");
  return;
}
