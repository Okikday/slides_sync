import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/domain/models/course_model/course.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

class EditCourseInputDescriptionField extends ConsumerWidget {
  const EditCourseInputDescriptionField({
    super.key,
    required this.descriptionTextController,
    required this.course,
    required this.descriptionFocusNode,
  });

  final TextEditingController descriptionTextController;
  final Course course;
  final FocusNode? descriptionFocusNode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.theme;
    return SliverToBoxAdapter(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 6.0,
        children: [
          CustomText("Description", fontSize: 13, color: theme.primaryText),
          SizedBox(
            width: context.deviceWidth,
            child: CustomTextfield(
              ontap: () {
                final descriptionText = descriptionTextController.text;
                if (descriptionText == course.description) {
                  descriptionTextController.selection = TextSelection(
                    baseOffset: 0,
                    extentOffset: descriptionText.length,
                  );
                }
              },
              onchanged: (text) {},
              // onTapOutside: () {},
              focusNode: descriptionFocusNode,
              controller: descriptionTextController,
              backgroundColor: theme.altBackgroundPrimary.withValues(alpha: 0.8),
              cursorColor: theme.primaryColor,
              selectionHandleColor: theme.primaryColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: theme.altBackgroundPrimary),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: theme.primaryColor),
              ),
              hintStyle: TextStyle(color: theme.secondaryText.withAlpha(80)),
              maxLength: 1024,
              counterText: null,

              pixelWidth: context.deviceWidth,
              minLines: 3,
              maxLines: 6,
              inputContentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              hint: "Enter new description",
              inputTextStyle: TextStyle(color: theme.primaryText),
            ),
          ),
        ],
      ),
    );
  }
}
