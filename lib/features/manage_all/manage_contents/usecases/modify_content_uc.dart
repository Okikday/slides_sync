import 'package:slides_sync/core/models/file_details.dart';
import 'package:slides_sync/core/utils/file_utils.dart';
import 'package:slides_sync/data/models/course_model/course.dart';
import 'package:slides_sync/data/repos/course_collection_repo.dart';
import 'package:slides_sync/data/repos/course_content_repo.dart';
import 'package:slides_sync/features/manage_all/manage_contents/usecases/add_contents_uc/create_content_preview_image.dart';

class ModifyContentUc {
  Future<String?> deleteContentAction(CourseContent content, {int? courseDbId, required String collectionId}) async {
    await CourseCollectionRepo.deleteContent(content);
    final CourseContent? sameHashedContent = await CourseContentRepo.getByHash(content.contentHash);
    if (sameHashedContent == null) {
      await FileUtils.deleteFileAtPath(content.path.filePath);
      await FileUtils.deleteFileAtPath(CreateContentPreviewImage.genPreviewImagePath(filePath: content.path.filePath));
    }
    
    return null;
  }

  

  // Future<String?> deleteContentsInIsolate() {
  //   log("Hello");
  // }
}
