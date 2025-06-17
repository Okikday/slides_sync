import 'dart:developer';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/data/models/course_model/course_model.dart';
import 'package:slides_sync/data/repos/course_repo.dart';
import 'package:slides_sync/routes/routes.dart';

class ModifyCollectionActions {
  Future<void> onCreateNewCollection(BuildContext context, {required String text, required int courseDbId}) async {
    if (text.isNotEmpty && text.length > 1 && text.length < 256) {
      try {
        final CourseModel? courseModel = await CourseRepo.getCourseByDbId(courseDbId);
        if (courseModel == null) {
          if (context.mounted) CustomDialog.hide(context);
          return;
        }
        CourseRepo.addCourse(
          courseModel.copyWith(subCollections: [CourseSubCollection.create(collectionTitle: text), ...courseModel.subCollections]),
        );
        if (context.mounted) {
          CustomDialog.hide(context);
          await UiUtils.showFlushBar(context, msg: "Added $text to Collections");
        }
      } catch (e) {
        log("$e");
        if (context.mounted) {
          CustomDialog.hide(context);
          await UiUtils.showFlushBar(context, msg: "An error occured while adding to collections");
        }
      }
    }
  }

  Future<bool?> renameCollectionAction({required String newText, required int courseDbId, required CourseSubCollection collection}) async {
    final CourseModel? currCourseModel = await CourseRepo.getCourseByDbId(courseDbId);
    if (currCourseModel == null) {
      return null;
    } else {
      try {
        await CourseRepo.addCourse(
          currCourseModel.copyWith(
            subCollections: [
              ...currCourseModel.subCollections.where((cm) => cm.collectionId != collection.collectionId),
              collection.copyWith(collectionTitle: newText),
            ],
          ),
        );
        return true;
      } catch (e) {
        log("$e");
        return false;
      }
    }
  }

  Future<void> onRenameCollection(
    BuildContext context, {
    required String newText,
    required int courseDbId,
    required CourseSubCollection collection,
  }) async {
    if (newText.isNotEmpty && newText != collection.collectionTitle && newText.length >= 2 && newText.length <= 64) {
      final outcome = await renameCollectionAction(newText: newText, courseDbId: courseDbId, collection: collection);
      if (context.mounted) CustomDialog.hide(context);
      if (context.mounted) {
        switch (outcome) {
          case null:
            await UiUtils.showFlushBar(context, msg: "Couldn't find collection", vibe: FlushbarVibe.warning);

          case true:
            await UiUtils.showFlushBar(context, msg: "Updated collection title from ${collection.collectionTitle} to $newText");
          case false:
            await UiUtils.showFlushBar(context, msg: "Error renaming collection", vibe: FlushbarVibe.error);
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
      CustomDialog.showLoadingDialog(
        newContext,
        canPop: true,
        msg: "Deleting collection",
        barrierColor: Colors.black.withValues(alpha: 0.6),
        transitionDuration: Durations.medium2,
      );

      final CourseModel? currCourseModel = await CourseRepo.getCourseByDbId(courseDbId);
      if (currCourseModel == null) {
        rootNavigatorKey.currentContext?.pop();
        if (context.mounted) await UiUtils.showFlushBar(newContext, msg: "Couldn't find collection");
      } else {
        try {
          await CourseRepo.addCourse(
            currCourseModel.copyWith(
              subCollections: currCourseModel.subCollections.where((cm) => cm.collectionId != collection.collectionId).toList(),
            ),
          );
          rootNavigatorKey.currentContext?.pop();

          if (newContext.mounted) await UiUtils.showFlushBar(newContext, msg: "Successfully removed collection");
        } catch (e) {
          log("$e");
          rootNavigatorKey.currentContext?.pop();

          if (newContext.mounted) await UiUtils.showFlushBar(newContext, msg: "Error deleting collection");
        }
      }
    }
  }
}
