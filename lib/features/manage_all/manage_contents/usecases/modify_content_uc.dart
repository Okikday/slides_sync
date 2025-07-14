import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:slides_sync/core/models/file_details.dart';
import 'package:slides_sync/core/utils/file_utils.dart';
import 'package:slides_sync/core/utils/result.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/data/models/course_model/course_model.dart';
import 'package:slides_sync/data/repos/course_repo.dart';
import 'package:slides_sync/routes/routes.dart';

class ModifyContentUc {
  Future<String?> onDeleteContent(CourseContent content, {int? courseDbId, required String collectionId}) async {
    if (rootNavigatorKey.currentContext!.mounted) {
      UiUtils.showLoadingDialog(rootNavigatorKey.currentContext!, message: "Deleting content...");
    }
    final Result<String?> delOutcome = await Result.tryRunAsync(
      () async => await _deleteContentAction(content, collectionId: collectionId, courseDbId: courseDbId),
    );
    Navigator.pop(rootNavigatorKey.currentContext!);

    if (delOutcome.isSuccess) {
      return delOutcome.data;
    } else {
      return "An error occured while deleting content!";
    }
  }

  Future<String?> _deleteContentAction(CourseContent content, {int? courseDbId, required String collectionId}) async {
    final CourseModel? course;
    if (courseDbId == null) {
      course = await CourseRepo.getCourseById(content.courseId);
    } else {
      course = await CourseRepo.getCourseByDbId(courseDbId);
    }
    if (course == null) return "Couldn't find course!";

    final CourseSubCollection? loadedCollection = course.subCollections.firstWhereOrNull((e) => e.collectionId == collectionId);
    if (loadedCollection == null) return "Collection doesn't exist!";

    final List<CourseContent> newContents = loadedCollection.courseContents.where((e) => e.id != content.id).toList();
    final newCollection = loadedCollection.copyWith(courseContents: newContents);
    final filteredCollections = course.subCollections.where((e) => e.collectionId != newCollection.collectionId).toList();
    await FileUtils.deleteFileAtPath(content.path.filePath);
    await CourseRepo.addCourse(course.copyWith(subCollections: [...filteredCollections, newCollection]));
    return null;
  }

  // Future<String?> deleteContentsInIsolate() {
  //   log("Hello");
  // }
}
