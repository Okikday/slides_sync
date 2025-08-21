import 'package:slides_sync/domain/models/file_details.dart';
import 'package:slides_sync/core/utils/file_utils.dart';
import 'package:slides_sync/core/utils/result.dart';
import 'package:slides_sync/domain/models/course_model/course.dart';
import 'package:slides_sync/domain/repos/course_repo/course_collection_repo.dart';
import 'package:slides_sync/domain/repos/course_repo/course_content_repo.dart';
import 'package:slides_sync/features/manage_all/manage_contents/usecases/create_contents_uc/create_content_preview_image.dart';

class ModifyContentUc {
  Future<String?> deleteContentAction(CourseContent content) async {
    await CourseCollectionRepo.deleteContent(content);
    final CourseContent? sameHashedContent = await CourseContentRepo.getByHash(content.contentHash);
    if (sameHashedContent == null) {
      await FileUtils.deleteFileAtPath(content.path.filePath);
      await FileUtils.deleteFileAtPath(CreateContentPreviewImage.genPreviewImagePath(filePath: content.path.filePath));
    }

    return null;
  }

  Future<String?> renameContentAction(CourseContent content, String newTitle) async {
    return (await Result.tryRunAsync(() async {
      await CourseContentRepo.add(content.copyWith(contentHash: content.contentHash, title: newTitle));
      return null;
    })).data;
  }

  // Future<String?> deleteContentsInIsolate() {
  //   log("Hello");
  // }
}
