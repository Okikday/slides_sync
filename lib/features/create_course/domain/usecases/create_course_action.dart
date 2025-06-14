import 'dart:developer';

import 'package:slides_sync/core/models/file_location.dart';
import 'package:slides_sync/core/utils/file_utils.dart';
import 'package:slides_sync/core/utils/image_utils.dart';
import 'package:slides_sync/core/utils/result.dart';
import 'package:slides_sync/data/models/course_model/course_model.dart';
import 'package:slides_sync/data/repos/course_repo.dart';
import 'package:slides_sync/shared/helpers/course_formatter.dart';

Future<Result<CourseModel>> createCourseAction({String courseCode = '', required String courseName, String? courseImagePath}) async {
  final Result<CourseModel?> createCourseOutcome = await Result.tryRunAsync<CourseModel>(() async {
    CourseModel courseModel = CourseModel.create(courseTitle: CourseFormatter.joinCodeToTitle(courseCode, courseName));

    final String? newPath = await compressCourseImageAsFile(courseImagePath, folderPath: "courses/${courseModel.courseId}");
    if (newPath != null) {
      courseModel = courseModel.copyWith(imageLocation: FileLocation(filePath: newPath));
    }

    await CourseRepo.addCourse(courseModel);
    final CourseModel? getCourse = await CourseRepo.getCourseByDbId(courseModel.id);
    if (getCourse == null) return null;
    return getCourse;
  });

  if (createCourseOutcome.isSuccess) {
    return Result.success(createCourseOutcome.data!);
  }
  return Result.error("Unable to create course");
}

Future<String?> compressCourseImageAsFile(String? courseImagePath, {required String folderPath}) async {
  if (courseImagePath != null && courseImagePath.isNotEmpty) {
    final Result<File> result = await ImageUtils().compressImage(inputFile: File(courseImagePath), targetMB: 0.1);
    if (result.isSuccess) {
      final String path = await FileUtils.storeFile(file: result.data!, folderPath: folderPath);
      await result.data?.delete();
      return path;
    }
    log("Tried compress Image. \nResult: ${result.status}");
  }
  return null;
}
