
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/domain/models/course_model/sub/course_content_type.dart';
import 'package:slides_sync/domain/models/course_model/sub/course_collection.dart';
import 'package:slides_sync/features/manage_all/manage_contents/presentation/views/add_contents/adding_content_overlay.dart';
import 'package:slides_sync/features/manage_all/manage_contents/usecases/add_contents_uc.dart';
import 'package:slides_sync/core/routes/routes.dart';


class AddContentsActions {
  static void onClickToAddContent(WidgetRef ref, {required CourseCollection collection, required CourseContentType type}) async {
    final context = ref.context;
    ValueNotifier<String> valueNotifier = ValueNotifier("Loading...");
    final entry = OverlayEntry(
      builder:
          (context) =>
              ValueListenableBuilder(valueListenable: valueNotifier, builder: (context, value, child) => LoadingOverlay(message: value)),
    );
    if (context.mounted) {
      Overlay.of(context).insert(entry);
    }
    final List<AddContentResultModel> result = await AddContentsUc.addToCollection(ref, collection: collection, type: type, valueNotifier: valueNotifier);

    entry.remove();
    valueNotifier.dispose();

    if (result.isNotEmpty) {
      await UiUtils.showFlushBar(rootNavigatorKey.currentContext!, msg: "Successfully added course contents!", vibe: FlushbarVibe.success);
    } else if (result.isEmpty) {
      await UiUtils.showFlushBar(
        rootNavigatorKey.currentContext!,
        msg: "An error was encountered while adding contents!",
        flushbarPosition: FlushbarPosition.TOP,
        vibe: FlushbarVibe.warning,
      );
    } else {
      await UiUtils.showFlushBar(rootNavigatorKey.currentContext!, msg: "An error occured while adding contents", vibe: FlushbarVibe.error);
    }
  }
}
