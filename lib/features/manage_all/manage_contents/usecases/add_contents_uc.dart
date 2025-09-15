import 'dart:convert';
import 'dart:developer';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/core/utils/result.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/domain/models/course_model/course.dart';
import 'package:slides_sync/features/manage_all/manage_contents/usecases/create_contents_uc/select_contents_uc.dart';
import 'package:slides_sync/features/manage_all/manage_contents/usecases/create_contents_uc/store_contents_uc.dart';
import 'package:slides_sync/core/routes/routes.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

class AddContentResultModel {
  final bool hasDuplicate;
  final bool isSuccess;
  final String? contentId;
  final String fileName;

  AddContentResultModel({
    required this.hasDuplicate,
    required this.isSuccess,
    required this.contentId,
    required this.fileName,
  });
}

class AddContentsUc {
  static Future<List<AddContentResultModel>> addToCollection(
    WidgetRef ref, {
    required CourseCollection collection,
    required CourseContentType type,
    ValueNotifier<String>? valueNotifier,
  }) async {
    final Result<dynamic> outcome = await Result.tryRunAsync(() async {
      valueNotifier?.value = "Consulting system selection";
      if (rootNavigatorKey.currentContext!.mounted) {
        // ignore: use_build_context_synchronously
        Navigator.pop(rootNavigatorKey.currentContext!);
      }
      UiUtils.showLoadingDialog(
        rootNavigatorKey.currentContext!,
        message: "Consulting system selection",
        backgroundColor: ref.theme.background.withValues(alpha: 0.8),
      );

      // Redirect to add contents
      final selectedContents = await SelectContentsUc(collection).referToAddContents(type);
      valueNotifier?.value = "Scanning contents";
      if (rootNavigatorKey.currentContext!.mounted) {
        // ignore: use_build_context_synchronously
        Navigator.pop(rootNavigatorKey.currentContext!);
      }
      if (selectedContents == null) return "No content was selected!";

      final RootIsolateToken? rootIsolateToken = RootIsolateToken.instance;
      if (rootIsolateToken == null) return "Unable to process adding content in background";
      valueNotifier?.value = "Adding contents...";
      List<Map<String, dynamic>> result = await compute(StoreContentsUc.storeCourseContents, <String, dynamic>{
        'rootIsolateToken': rootIsolateToken,
        'collectionId': collection.collectionId,
        'selectedContentsPaths': <String>[for (final value in selectedContents) value.path],
      });

      return result
          .map(
            (element) => AddContentResultModel(
              hasDuplicate: element['duplicate'] as bool? ?? false,
              isSuccess: element['success'] as bool? ?? false,
              contentId: element['contentId'] as String?,
              fileName: element['fileName'] as String? ?? 'Unknown',
            ),
          )
          .toList();
    });

    if (outcome.isSuccess && outcome.data is List) {
      return outcome.data as List<AddContentResultModel>;
    } else {
      log("An error occurred while adding to collection! => ${outcome.data}");
      log("${outcome.message}");
      return [];
    }
  }
}
