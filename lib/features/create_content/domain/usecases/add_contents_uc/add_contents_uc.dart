import 'dart:io';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:slides_sync/core/models/file_details.dart';
import 'package:slides_sync/core/utils/file_utils.dart';
import 'package:slides_sync/core/utils/result.dart';
import 'package:slides_sync/data/models/course_model/course_model.dart';
import 'package:slides_sync/features/create_content/domain/usecases/add_contents_uc/prepare_contents_uc.dart';
import 'package:slides_sync/features/create_content/domain/usecases/add_contents_uc/select_contents_uc.dart';

class AddContentsUc {
  static Future<Result<bool>> addToCollection(BuildContext context, {required CourseSubCollection collection, required ContentType type}) async {
    final Result<bool?> outcome = await Result.tryRunAsync<bool>(() async {
      final scu = SelectContentsUc(collection);
      CustomDialog.showLoadingDialog(context, msg: "Consulting system selection", backgroundColor: Colors.transparent);

      final selectedContents = await scu.referToAddContents(type);
      if (context.mounted) {
        CustomDialog.hide(context);
      } else {
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      }
      if (selectedContents == null) return false;
      CustomDialog.showLoadingDialog(context, msg: "Adding Contents...", backgroundColor: Colors.transparent);
      bool result = await PrepareContentsUc().storeCourseContents(collection, selectedContents);
      if (context.mounted) {
        CustomDialog.hide(context);
      } else {
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      }
      return result;
    });

    if (outcome.isSuccess) {
      return Result.success(outcome.data!);
    }
    return Result.error(outcome.message!);
  }
}
