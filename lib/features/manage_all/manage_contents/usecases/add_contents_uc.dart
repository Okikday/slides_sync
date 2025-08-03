import 'dart:convert';
import 'dart:developer';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:slides_sync/core/models/file_details.dart';
import 'package:slides_sync/core/utils/result.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/data/models/course_model/course.dart';
import 'package:slides_sync/data/repos/course_content_repo.dart';
import 'package:slides_sync/features/manage_all/manage_contents/usecases/create_contents_uc/select_contents_uc.dart';
import 'package:slides_sync/features/manage_all/manage_contents/usecases/create_contents_uc/store_contents_uc.dart';
import 'package:slides_sync/routes/routes.dart';

class AddContentsUc {
  static Future<String?> addToCollection(
    BuildContext context, {
    required CourseCollection collection,
    required CourseContentType type,
    ValueNotifier<String>? valueNotifier,
  }) async {
    final Result<String?> outcome = await Result.tryRunAsync<String?>(() async {
      valueNotifier?.value = "Consulting system selection";
      if (rootNavigatorKey.currentContext!.mounted) {
        // ignore: use_build_context_synchronously
        Navigator.pop(rootNavigatorKey.currentContext!);
      }
      final scu = SelectContentsUc(collection);
      UiUtils.showLoadingDialog(rootNavigatorKey.currentContext!, message: "Consulting system selection", backgroundColor: Colors.white10);

      final selectedContents = await scu.referToAddContents(type);
      valueNotifier?.value = "Loading contents";
      if (rootNavigatorKey.currentContext!.mounted) {
        // ignore: use_build_context_synchronously
        Navigator.pop(rootNavigatorKey.currentContext!);
      }
      if (selectedContents == null) return "No content was selected!";

      final RootIsolateToken? rootIsolateToken = RootIsolateToken.instance;
      if (rootIsolateToken == null) return "Unable to process adding content in background";
      valueNotifier?.value = "Adding contents";
      String? result = await compute(StoreContentsUc.storeCourseContents, <String, dynamic>{
        'rootIsolateToken': rootIsolateToken,
        'collectionJson': collection.toJson(),
        'selectedContentsPaths': <String>[for (final value in selectedContents) value.path],
      });

      return result;
    });

    if (outcome.isSuccess && outcome.data == null) {
      return null;
    } else if (outcome.isSuccess) {
      return outcome.data;
    } else {
      log("${outcome.message}");
      return "An error occurred while adding to collection!";
    }
  }

  static Future<CourseContent?> createNote(CourseCollection collection, {String defaultNote = '', String title = '', List<String> tags = const []}) async {
    final parentId = collection.collectionId;
    final contentHash = sha256.convert(defaultNote.codeUnits).bytes.toString();
    final path = collection.absolutePath;

    CourseContent newContent = CourseContent.create(
      contentHash: contentHash,
      parentId: parentId,
      title: title,
      description: defaultNote,
      path: FileDetails(filePath: path),
      courseContentType: CourseContentType.note,
      metadataJson: jsonEncode({'tags': tags.toString()}),
    );

    final dbId = await CourseContentRepo.add(newContent);
    final note = await CourseContentRepo.getByDbId(dbId);
    return note;
  }
}
