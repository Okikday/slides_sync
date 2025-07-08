import 'dart:developer';
import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:slides_sync/core/models/file_details.dart';
import 'package:slides_sync/core/utils/file_utils.dart';
import 'package:slides_sync/core/utils/result.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/data/models/course_model/course_model.dart';
import 'package:slides_sync/features/create_all/create_content/domain/usecases/add_contents_uc/prepare_contents_uc.dart';
import 'package:slides_sync/features/create_all/create_content/domain/usecases/add_contents_uc/select_contents_uc.dart';
import 'package:slides_sync/routes/routes.dart';

class AddContentsUc {
  static void onClickToAddContent(BuildContext context, {required CourseSubCollection collection, required ContentType type}) async {
    final String? result = await AddContentsUc.addToCollection(collection: collection, type: type);
    Navigator.pop(rootNavigatorKey.currentContext!);
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

  static Future<String?> addToCollection({required CourseSubCollection collection, required ContentType type}) async {
    final Result<String?> outcome = await Result.tryRunAsync<String?>(() async {
      final scu = SelectContentsUc(collection);
      UiUtils.showLoadingDialog(
        rootNavigatorKey.currentContext!,
        message: "Consulting system selection",
        backgroundColor: Colors.white10,
        blurSigma: Offset(2, 2),
      );

      final selectedContents = await scu.referToAddContents(type);
      if (rootNavigatorKey.currentContext!.mounted) {
        CustomDialog.hide(rootNavigatorKey.currentContext!);
      } else {
        // ignore: use_build_context_synchronously
        Navigator.pop(rootNavigatorKey.currentContext!);
      }
      if (selectedContents == null) return "No content was selected!";
      if (rootNavigatorKey.currentContext!.mounted) {
        UiUtils.showLoadingDialog(
          rootNavigatorKey.currentContext!,
          message: "Adding Content...",
          barrierColor: Colors.black38,
          backgroundColor: Colors.white10,
          blurSigma: Offset(2, 2),
        );
      }
      String? result = await PrepareContentsUc().storeCourseContents(collection, selectedContents);
      Navigator.pop(rootNavigatorKey.currentContext!);
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
