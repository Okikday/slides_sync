import 'package:slides_sync/core/models/file_details.dart';
import 'package:slides_sync/core/utils/file_utils.dart';
import 'package:slides_sync/data/models/course_model/course.dart';
import 'package:slides_sync/data/repos/course_collection_repo.dart';

class ModifyContentUc {
  Future<String?> deleteContentAction(CourseContent content, {int? courseDbId, required String collectionId}) async {
    await FileUtils.deleteFileAtPath(content.path.filePath);
    await CourseCollectionRepo.deleteContent(content);
    return null;
  }

  // Future<String?> deleteContentsInIsolate() {
  //   log("Hello");
  // }
}
