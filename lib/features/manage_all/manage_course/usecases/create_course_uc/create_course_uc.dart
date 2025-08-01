import 'dart:developer';

import 'package:slides_sync/core/models/file_details.dart';
import 'package:slides_sync/core/utils/file_utils.dart';
import 'package:slides_sync/core/utils/image_utils.dart';
import 'package:slides_sync/core/utils/result.dart';
import 'package:slides_sync/data/models/course_model/course.dart';
import 'package:slides_sync/data/repos/course_repo.dart';
import 'package:slides_sync/shared/helpers/course_formatter.dart';

class CreateCourseUc {
  Future<Result<Course>> createCourseAction({String courseCode = '', required String courseName, String? courseImagePath}) async {
    final Result<Course?> createCourseOutcome = await Result.tryRunAsync<Course>(() async {
      Course course = Course.create(courseTitle: CourseFormatter.joinCodeToTitle(courseCode, courseName));

      final String? previewImgPath = await compressCourseImageAsFile(courseImagePath, folderPath: "courses/${course.courseId}");
      if (previewImgPath != null) {
        course = course.copyWith(imageLocationJson: FileDetails(filePath: previewImgPath).toJson());
      }

      await CourseRepo.addCourse(course);
      final Course? getCourse = await CourseRepo.getCourseByDbId(course.id);
      if (getCourse == null) return null;
      return getCourse;
    });

    if (createCourseOutcome.isSuccess) {
      return Result.success(createCourseOutcome.data!);
    }
    return Result.error("Unable to create course");
  }

  static Future<String?> compressCourseImageAsFile(String? courseImagePath, {required String folderPath}) async {
    if (courseImagePath != null && courseImagePath.isNotEmpty) {
      final Result<File> result = await ImageUtils.compressImage(inputFile: File(courseImagePath), targetMB: 0.1, outputFormat: 'png');
      if (result.isSuccess) {
        final String output = await FileUtils.storeFile(file: result.data!, folderPath: folderPath);
        await result.data?.delete();
        return output;
      }
      log("Tried compress Image. \nResult: ${result.status}");
    }
    return null;
  }
}
