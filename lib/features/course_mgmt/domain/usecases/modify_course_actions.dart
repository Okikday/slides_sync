import 'package:slides_sync/core/models/image_location.dart';
import 'package:slides_sync/core/utils/file_utils.dart';
import 'package:slides_sync/core/utils/result.dart';
import 'package:slides_sync/features/course_mgmt/data/models/course_model/course_model.dart';
import 'package:slides_sync/features/course_mgmt/data/repos/course_repo.dart';
import 'package:slides_sync/features/course_mgmt/domain/usecases/create_course_action.dart';

class ModifyCourseActions {
  static String? checkIfCanUpdateCourse({
    required String courseName,
    required String courseCode,
    required String description,
    required bool isVisible,
  }) {
    if (courseName.isEmpty || courseName.length < 2 || courseName.length > 64 || double.tryParse(courseName) != null) {
      if (courseName.isEmpty) return "Kindly fill the course title field!";
      if (courseName.length < 2) return "Course title too short!";
      if (courseName.length > 64) return "Course title too long!";
      return "Kindly input a valid course title!";
    } else if (isVisible && (courseCode.length < 2 || courseCode.length > 12)) {
      return "Kindly input a valid course code or hide it";
    } else if (description.length > 1024) {
      return "Kindly input a valid description!";
    }
    return null;
  }

  static Future<void> onDeleteCourse({required int id, required String courseId}) async {
    await CourseRepo.deleteCourse(id);
    await FileUtils.deleteAppDirectory(relativePath: "courses/$courseId");
  }

  static Future<Result> modifyCourseImageAction({required int id, required File newImageFile}) async {
    final Result<bool?> createCourseOutcome = await Result.tryRunAsync<bool>(() async {
      CourseModel? courseModel = await CourseRepo.getCourseById(id);
      if (courseModel == null) return false;
      if (courseModel.imageLocation.containsAnyImagePath) {
        await FileUtils.deleteFileAtPath(courseModel.imageLocation.filePath);
      }
      final String? newPath = await compressCourseImageAsFile(newImageFile.path, folderPath: "courses/${courseModel.courseId}");
      if (newPath != null) {
        courseModel = courseModel.copyWith(imageLocation: ImageLocation(filePath: newPath));
        await CourseRepo.addCourse(courseModel);
        return true;
      }
      return false;
    });

    if (createCourseOutcome.isSuccess) {
      return Result.success(createCourseOutcome.data!);
    }
    return Result.error("Unable to create course");
  }
}
