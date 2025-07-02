import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:slides_sync/core/models/file_details.dart';
import 'package:slides_sync/data/models/course_model/sub/course_content.dart';

class ContentHelperUc {
  static Future<List<CourseContent>> resolveImgesWithoutPreview(List<CourseContent> courseContents) async {
    final imageCourseContents = courseContents.where((t) => t.courseContentType == CourseContentType.image);

    final List<CourseContent> nonExistingPreviewCourseContents = [];
    for (final content in imageCourseContents) {
      final String previewPath = getImagePreviewPath(content);
      if (previewPath.isEmpty) continue;
      if (!(await File(previewPath).exists())) {
        nonExistingPreviewCourseContents.add(content);
      }
    }
    return nonExistingPreviewCourseContents;
  }

  static String getImagePreviewPath(CourseContent content) {
    final String previewPath;
    if (content.courseContentType == CourseContentType.image) {
      final String path = content.path.fileDetails.filePath;
      final int pathSepIndex = path.lastIndexOf(Platform.pathSeparator);
      if (pathSepIndex == -1) return '';
      previewPath =
          "${path.substring(0, pathSepIndex)}${Platform.pathSeparator}previews${Platform.pathSeparator}${content.id}.${p.basename(path).split('.').last}";
    } else {
      previewPath = '';
    }
    return previewPath;
  }
}
