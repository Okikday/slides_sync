import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:slides_sync/core/utils/file_utils.dart';
import 'package:slides_sync/core/utils/result.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/data/models/course_model/course_model.dart';
import 'package:slides_sync/data/repos/course_repo.dart';
import 'package:slides_sync/routes/routes.dart';

class ModifyCollectionActions {
  /// Add collection to course
  Future<String?> _addCollectionToCourse(int courseDbId, String title) async {
    final CourseModel? courseModel = await CourseRepo.getCourseByDbId(courseDbId);
    if (courseModel == null) {
      return "Couldn't find course!";
    }
    final newCollection = CourseSubCollection.create(parentId: courseModel.courseId, collectionTitle: title);
    if (courseModel.subCollections.any((c) => c.collectionTitle == title)) {
      return "Collection title already exists, try using a different name";
    }
    final newCollections = courseModel.subCollections.where((cm) => cm.collectionId != newCollection.collectionId).toList();
    newCollections.add(newCollection);
    await CourseRepo.addCourse(courseModel.copyWith(subCollections: newCollections));
    return null;
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

  Future<String?> renameCollectionAction({required String newText, required int courseDbId, required String collectionId}) async {
    if (newText.isEmpty && newText.length < 2 && newText.length > 256) return "Invalid input!";
    final CourseModel? currCourseModel = await CourseRepo.getCourseByDbId(courseDbId);
    if (currCourseModel == null) return "Couldn't find course!";
    final CourseSubCollection? newCollection = currCourseModel.subCollections.firstWhereOrNull(
      (e) => e.collectionId == collectionId || e.collectionTitle == newText,
    );
    if (newCollection == null) return "Couldn't find collection!";
    if (newCollection.collectionTitle == newText) return "Collection title already exists, try using a different name";

    final Result<String?> renameOutcome = await Result.tryRunAsync<String?>(() async {
      final newCollections = currCourseModel.subCollections.where((cm) => cm.collectionId != newCollection.collectionId).toList();
      newCollections.add(newCollection);
      await CourseRepo.addCourse(currCourseModel.copyWith(subCollections: newCollections));
      return null;
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
    required CourseSubCollection collection,
  }) async {
    if (newText.isNotEmpty && newText != collection.collectionTitle && newText.length >= 2 && newText.length <= 64) {
      final String? outcome = await renameCollectionAction(newText: newText, courseDbId: courseDbId, collectionId: collection.collectionId);
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

  Future<void> onDeleteCollection(BuildContext context, {required int courseDbId, required CourseSubCollection collection}) async {
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
        backgroundColor: Colors.red.shade100,
        blurSigma: Offset(2, 2),
      );

      final CourseModel? currCourseModel = await CourseRepo.getCourseByDbId(courseDbId);
      if (currCourseModel == null) {
        rootNavigatorKey.currentContext?.pop();
        if (context.mounted) await UiUtils.showFlushBar(newContext, msg: "Couldn't find collection");
      } else {
        final Result<String?> deleteOutcome = await Result.tryRunAsync(() async {
          await FileUtils.deleteFromAppDirectory(relativePath: collection.absolutePath);
          await CourseRepo.addCourse(
            currCourseModel.copyWith(
              subCollections: currCourseModel.subCollections.where((cm) => cm.collectionId != collection.collectionId).toList(),
            ),
          );
          return null;
        });
        rootNavigatorKey.currentContext?.pop();
        if (deleteOutcome.isSuccess && deleteOutcome.data == null) {
          if (newContext.mounted) {
            await UiUtils.showFlushBar(
              newContext,
              msg: "Successfully removed ${collection.collectionTitle} from ${currCourseModel.courseTitle}",
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
}
