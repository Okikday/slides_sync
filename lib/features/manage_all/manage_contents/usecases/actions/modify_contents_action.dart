import 'package:flutter/material.dart';
import 'package:slides_sync/core/utils/result.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/data/models/course_model/sub/course_content.dart';
import 'package:slides_sync/features/manage_all/manage_contents/usecases/modify_content_uc.dart';
import 'package:slides_sync/routes/routes.dart';

class ModifyContentsAction {
  Future<String?> onDeleteContent(CourseContent content, {int? courseDbId, required String collectionId}) async {
    if (rootNavigatorKey.currentContext!.mounted) {
      UiUtils.showLoadingDialog(rootNavigatorKey.currentContext!, message: "Deleting content...");
    }
    final Result<String?> delOutcome = await Result.tryRunAsync(
      () async => await ModifyContentUc().deleteContentAction(content, collectionId: collectionId, courseDbId: courseDbId),
    );
    Navigator.pop(rootNavigatorKey.currentContext!);

    if (delOutcome.isSuccess) {
      return delOutcome.data;
    } else {
      return "An error occured while deleting content!";
    }
  }
}
