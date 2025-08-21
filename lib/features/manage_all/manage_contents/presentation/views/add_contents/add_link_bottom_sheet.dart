import 'package:another_flushbar/flushbar.dart';
import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/domain/models/course_model/course.dart';
import 'package:slides_sync/shared/common_widgets/input_text_bottom_sheet.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:slides_sync/shared/styles/colors.dart';

class AddLinkBottomSheet extends ConsumerWidget {
  final CourseCollection collection;
  const AddLinkBottomSheet({super.key, required this.collection});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        InputTextBottomSheet(
          title: "Add link",
          hintText: "www.youtube.com/learn",
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
            decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(16)),
          ).animate(onComplete: (controller) => controller.repeat()).shimmer(duration: Durations.extralong4),
        ),
        Positioned(
          right: 12,
          bottom: context.bottomPadding + 120,
          child: CustomElevatedButton(
            label: "Paste from Clipboard",
            backgroundColor: ref.theme.secondaryText.withValues(alpha: .1),
            textColor: AppColors.primaryText(context),
            onClick: () {
              UiUtils.showFlushBar(context, msg: "Not available!", flushbarPosition: FlushbarPosition.TOP);
            },
          ),
        ),
      ],
    ).animate().fadeIn().slideY(begin: .4, end: 0, duration: Duration(milliseconds: 200), curve: CustomCurves.decelerate);
  }
}
