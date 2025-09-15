import 'package:slides_sync/domain/models/file_details.dart';
import 'package:slides_sync/core/utils/file_utils.dart';
import 'package:slides_sync/core/utils/result.dart';
import 'package:slides_sync/domain/models/course_model/course.dart';
import 'package:slides_sync/domain/repos/course_repo/course_collection_repo.dart';
import 'package:slides_sync/domain/repos/course_repo/course_content_repo.dart';
import 'package:slides_sync/domain/repos/progress_track_repo.dart';
import 'package:slides_sync/features/all_tabs/tab_home/presentation/actions/recent_dialog_actions.dart';
import 'package:slides_sync/features/manage_all/manage_contents/usecases/create_contents_uc/create_content_preview_image.dart';

class ModifyContentUc {
  Future<String?> deleteContentAction(CourseContent content) async {
    final bool dupHashExists = await CourseContentRepo.doesDuplicateHashExists(content.contentHash);
    await CourseCollectionRepo.deleteContent(content);
    await RecentDialogActions.removeIdFromRecents(content.contentId);
    await ProgressTrackRepo.deleteByContentId(content.contentId);

    if (!dupHashExists) {
      await FileUtils.deleteFileAtPath(content.path.filePath);
      await FileUtils.deleteFileAtPath(CreateContentPreviewImage.genPreviewImagePath(filePath: content.path.filePath));
    }

    return null;
  }

  // Future<String?> deleteContentsAction(List<CourseContent> contents) async {
  //   String? latestMsg;
  //   for (var item in contents) {
  //     latestMsg = await deleteContentAction(item);
  //   }

  //   return latestMsg;
  // } // too intensive

  Future<String?> renameContentAction(CourseContent content, String newTitle) async {
    return (await Result.tryRunAsync(() async {
      CourseContent? stContent = await CourseContentRepo.getByDbId(content.id);
      if (stContent == null) {
        stContent = await CourseContentRepo.getByContentId(content.contentId);
        if (stContent == null) return;
      }

      await CourseContentRepo.add(stContent.copyWith(contentHash: content.contentHash, title: newTitle));
      return null;
    })).data;
  }

  // Future<String?> deleteContentsInIsolate() {
  //   log("Hello");
  // }
}
