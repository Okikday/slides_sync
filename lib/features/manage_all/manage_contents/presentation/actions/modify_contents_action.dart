
import 'package:flutter/material.dart';
import 'package:slides_sync/core/utils/result.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/domain/models/course_model/sub/course_content.dart';
import 'package:slides_sync/features/manage_all/manage_contents/usecases/modify_content_uc.dart';
import 'package:slides_sync/core/routes/routes.dart';

class ModifyContentsAction {
  Future<String?> onDeleteContent(CourseContent content, {int? courseDbId}) async {
    if (rootNavigatorKey.currentContext!.mounted) {
      UiUtils.showLoadingDialog(rootNavigatorKey.currentContext!, message: "Deleting content...");
    }
    final Result<String?> delOutcome = await Result.tryRunAsync(() async => await ModifyContentUc().deleteContentAction(content));
    Navigator.pop(rootNavigatorKey.currentContext!);

    if (delOutcome.isSuccess) {
      return delOutcome.data;
    } else {
      return "An error occured while deleting content!";
    }
  }

  Future<String?> onRenameContent(CourseContent content, {required String newTitle}) async {
    if (newTitle.isEmpty || newTitle == content.title || newTitle.length < 2) return "Try inputting a valid title!";
    if (rootNavigatorKey.currentContext!.mounted) {
      UiUtils.showLoadingDialog(rootNavigatorKey.currentContext!, message: "Renaming content...");
    }
    final Result<String?> renameOutcome = await Result.tryRunAsync(
      () async {
        return await ModifyContentUc().renameContentAction(content, newTitle);
      },
    );
    Navigator.pop(rootNavigatorKey.currentContext!);

    if (renameOutcome.isSuccess) {
      return renameOutcome.data;
    } else {
      return "An error occured while renaming content!";
    }
  }
}
