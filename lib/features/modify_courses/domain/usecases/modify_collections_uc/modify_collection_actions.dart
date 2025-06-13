import 'dart:developer';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/widgets.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/data/models/course_model/course_model.dart';
import 'package:slides_sync/data/repos/course_repo.dart';

class ModifyCollectionActions {
  Future<void> createNewCollection(BuildContext context, {required String text, required int courseDbId}) async {
    if (text.isNotEmpty && text.length > 4 && text.length < 256) {
      try {
        final CourseModel? courseModel = await CourseRepo.getCourseById(courseDbId);
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
}
