import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:slides_sync/core/models/file_details.dart';
import 'package:slides_sync/core/utils/file_utils.dart';
import 'package:slides_sync/core/utils/result.dart';
import 'package:slides_sync/core/utils/smart_isolate.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/data/models/course_model/course_model.dart';
import 'package:slides_sync/features/manage_all/manage_contents/usecases/add_contents_uc/prepare_contents_uc.dart';
import 'package:slides_sync/features/manage_all/manage_contents/usecases/add_contents_uc/select_contents_uc.dart';
import 'package:slides_sync/features/manage_all/manage_contents/presentation/views/add_contents/adding_content_overlay.dart';
import 'package:slides_sync/routes/routes.dart';

class AddContentsUc {
  static void onClickToAddContent(BuildContext context, {required CourseSubCollection collection, required ContentType type}) async {
    ValueNotifier<String> valueNotifier = ValueNotifier("Loading...");
    final entry = OverlayEntry(
      builder:
          (context) =>
              ValueListenableBuilder(valueListenable: valueNotifier, builder: (context, value, child) => LoadingOverlay(message: value)),
    );
    if (context.mounted) {
      Overlay.of(context).insert(entry);
    }
    final String? result = await AddContentsUc.addToCollection(context, collection: collection, type: type, valueNotifier: valueNotifier);

    entry.remove();
    valueNotifier.dispose();

    if (result == null) {
      await UiUtils.showFlushBar(rootNavigatorKey.currentContext!, msg: "Successfully added course contents!", vibe: FlushbarVibe.success);
    } else if (!result.contains("error")) {
      await UiUtils.showFlushBar(
        rootNavigatorKey.currentContext!,
        msg: result,
        flushbarPosition: FlushbarPosition.TOP,
        vibe: FlushbarVibe.warning,
      );
    } else {
      await UiUtils.showFlushBar(rootNavigatorKey.currentContext!, msg: result, vibe: FlushbarVibe.error);
    }
  }

  static Future<String?> addToCollection(
    BuildContext context, {
    required CourseSubCollection collection,
    required ContentType type,
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
      String? result = await compute(PrepareContentsUc.storeCourseContents, <String, dynamic>{
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
}
