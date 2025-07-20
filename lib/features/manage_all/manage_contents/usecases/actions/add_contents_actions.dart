
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/data/models/course_model/sub/course_content_type.dart';
import 'package:slides_sync/data/models/course_model/sub/course_collection.dart';
import 'package:slides_sync/features/manage_all/manage_contents/presentation/views/add_contents/adding_content_overlay.dart';
import 'package:slides_sync/features/manage_all/manage_contents/usecases/add_contents_uc.dart';
import 'package:slides_sync/routes/routes.dart';


class AddContentsActions {
  static void onClickToAddContent(BuildContext context, {required CourseCollection collection, required CourseContentType type}) async {
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
}
