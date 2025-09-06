import 'dart:developer';

import 'package:another_flushbar/flushbar.dart';
import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_link_previewer/flutter_link_previewer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/domain/models/course_model/course.dart';
import 'package:slides_sync/domain/models/file_details.dart';
import 'package:slides_sync/shared/common_widgets/input_text_bottom_sheet.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:slides_sync/shared/styles/colors.dart';
import 'package:slides_sync/shared/widgets/build_image_path_widget.dart';

class AddLinkBottomSheet extends ConsumerStatefulWidget {
  final CourseCollection collection;
  const AddLinkBottomSheet({super.key, required this.collection});

  @override
  ConsumerState<AddLinkBottomSheet> createState() => _AddLinkBottomSheetState();
}

class _AddLinkBottomSheetState extends ConsumerState<AddLinkBottomSheet> {
  late final TextEditingController linkInputController;
  late final ValueNotifier<String?> previewDataNotifier;

  @override
  void initState() {
    super.initState();
    linkInputController = TextEditingController();
    previewDataNotifier = ValueNotifier(null);
    linkInputController.addListener(updateLinkInput);
  }

  void updateLinkInput() => previewDataNotifier.value = linkInputController.text;

  @override
  void dispose() {
    linkInputController.dispose();
    previewDataNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InputTextBottomSheet(
          title: "Add link",
          hintText: "https.youtube.com/learn",
          textEditingController: linkInputController,
          onSubmitted: (String text) async {
            // if (text.isEmpty) return;
            // await CreateNoteUc().createNote(collection, defaultNote: text);
            // Navigator.pop(rootNavigatorKey.currentContext!);
          },
        ),
        Positioned(
          left: 24,
          bottom: context.bottomPadding + 120,
          child: Container(
            width: 100,
            height: 100,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: ref.theme.primaryText.withValues(alpha: 0.2))],
            ),
            child: ValueListenableBuilder(
              valueListenable: previewDataNotifier,
              builder: (context, value, child) {
                log("value: $value");
                return FutureBuilder(
                  future: getPreviewData(value ?? ''),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != null && snapshot.data?.image != null) {
                      return BuildImagePathWidget(
                        fileDetails: FileDetails(urlPath: snapshot.data!.image!.url),
                        fit: BoxFit.cover,
                        width: 100,
                        height: 100,
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                );
              },
            ),
          ).animate(onComplete: (controller) => controller.repeat()).shimmer(duration: Durations.extralong4),
        ),
        Positioned(
          right: 12,
          bottom: context.bottomPadding + 120,
          child: CustomElevatedButton(
            label: "Paste from Clipboard",
            backgroundColor: ref.theme.secondaryText,
            textColor: ref.theme.onSecondaryText,
            onClick: () {
              UiUtils.showFlushBar(context, msg: "Not available!", flushbarPosition: FlushbarPosition.TOP);
            },
          ),
        ),
      ],
    ).animate().fadeIn().slideY(
      begin: .4,
      end: 0,
      duration: Duration(milliseconds: 200),
      curve: CustomCurves.decelerate,
    );
  }
}
