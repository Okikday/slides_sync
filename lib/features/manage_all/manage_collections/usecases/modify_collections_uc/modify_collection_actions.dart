import 'dart:developer';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:slides_sync/core/utils/file_utils.dart';
import 'package:slides_sync/core/utils/result.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/domain/models/course_model/course.dart';
import 'package:slides_sync/domain/repos/course_repo/course_repo.dart';
import 'package:slides_sync/core/routes/routes.dart';

class ModifyCollectionActions {
  /// Add collection to course
  Future<String?> _addCollectionToCourse(int courseDbId, String title) async {
    final Course? course = await CourseRepo.getCourseByDbId(courseDbId);
    if (course == null) {
      return "Couldn't find course!";
    }
    final newCollection = CourseCollection.create(parentId: course.courseId, collectionTitle: title);
    final String? result = await CourseRepo.addCollectionNoDuplicateTitle(newCollection);
    return result;
  }

  Future<String?> onCreateNewCollection(BuildContext context, {required String text, required int courseDbId}) async {
    if (text.isNotEmpty && text.length > 1 && text.length < 256) {
      final Result<String?> createOutcome = await Result.tryRunAsync<String?>(() async => await _addCollectionToCourse(courseDbId, text));

      if (createOutcome.isSuccess && createOutcome.data == null) {
        return null;
      } else if (createOutcome.isSuccess) {
        return createOutcome.data;
      } else {
        log("${createOutcome.message}");
        return 'An error occured while adding to collections';
      }
    }
    return '';
  }

  Future<String?> renameCollectionAction(CourseCollection collection) async {
    final Result<String?> renameOutcome = await Result.tryRunAsync<String?>(() async {
      final String? result = await CourseRepo.addCollectionNoDuplicateTitle(collection);
      return (result == null ? result : "An error occured while renaming collection!");
    });
    if (renameOutcome.isSuccess && renameOutcome.data == null) {
      return null;
    } else if (renameOutcome.isSuccess) {
      return renameOutcome.data;
    } else {
      log("${renameOutcome.message}");
      return "An error occured whilst renaming collection!";
    }
  }

  Future<void> onRenameCollection(
    BuildContext context, {
    required String newText,
    required int courseDbId,
    required CourseCollection collection,
  }) async {
    if (newText.isNotEmpty && newText != collection.collectionTitle && newText.length >= 2 && newText.length < 256) {
      final String? outcome = await renameCollectionAction(collection.copyWith(collectionTitle: newText));
      if (context.mounted) CustomDialog.hide(context);
      if (context.mounted) {
        if (outcome == null) {
          await UiUtils.showFlushBar(context, msg: "Successfully renamed collection to $newText", vibe: FlushbarVibe.success);
        } else {
          await UiUtils.showFlushBar(context, msg: outcome, vibe: FlushbarVibe.warning);
        }
        return;
      }
    } else {
      CustomDialog.hide(context);
    }
  }

  Future<void> onDeleteCollection(BuildContext context, {required CourseCollection collection}) async {
    if (context.mounted) {
      CustomDialog.hide(context);
    } else {
      rootNavigatorKey.currentContext?.pop();
    }
    final BuildContext? newContext = rootNavigatorKey.currentContext;

    if (newContext != null) {
      UiUtils.showLoadingDialog(
        newContext,
        canPop: true,
        message: "Deleting collection",
        barrierColor: Colors.black.withValues(alpha: 0.6),
        backgroundColor: Colors.red.withAlpha(20),
        blurSigma: Offset(2, 2),
      );

      final Result<String?> deleteOutcome = await Result.tryRunAsync(() async {
          await FileUtils.deleteFromAppDirectory(relativePath: collection.absolutePath);
          final bool deleteOutcome = await CourseRepo.deleteCollection(collection);
          if (!deleteOutcome) return "An error occured while deleting!";
          return null;
        });
        rootNavigatorKey.currentContext?.pop();
        if (deleteOutcome.isSuccess && deleteOutcome.data == null) {
          if (newContext.mounted) {
            await UiUtils.showFlushBar(
              newContext,
              msg: "Successfully removed ${collection.collectionTitle}",
              vibe: FlushbarVibe.success,
            );
          }
        } else {
          log("${deleteOutcome.message}");
          if (newContext.mounted) await UiUtils.showFlushBar(newContext, msg: "Error deleting collection", vibe: FlushbarVibe.error);
        }
    }
  }
}
