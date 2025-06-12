import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/data/models/course_model/course_model.dart';
import 'package:slides_sync/features/modify_courses/presentation/views/modify_course/edit_course_bottom_sheet.dart';
import 'package:slides_sync/shared/styles/app_ui_context.dart';

class EditCourseInputDescriptionField extends ConsumerWidget {
  const EditCourseInputDescriptionField({
    super.key,
    required this.descriptionTextController,
    required this.courseModel,
    required this.descriptionFocusNode,
  });

  final TextEditingController descriptionTextController;
  final CourseModel courseModel;
  final FocusNode? descriptionFocusNode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverToBoxAdapter(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 6.0,
        children: [
          CustomText("Description", fontSize: 13),
          SizedBox(
            width: context.deviceWidth,
            child: CustomTextfield(
              ontap: () {
                final descriptionText = descriptionTextController.text;
                if (descriptionText == courseModel.description) {
                  descriptionTextController.selection = TextSelection(baseOffset: 0, extentOffset: descriptionText.length);
                }
              },
              onchanged: (text) {},
              // onTapOutside: () {},
              focusNode: descriptionFocusNode,
              controller: descriptionTextController,
              backgroundColor: Colors.grey.withAlpha(40),
              cursorColor: CustomText("").effectiveStyle(context).color ?? Colors.white,
              maxLength: 1024,
              counterText: null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: context.isDarkMode ? Colors.lightBlueAccent.withAlpha(80) : Colors.deepPurple.withAlpha(40)),
              ),
              pixelWidth: context.deviceWidth,
              minLines: 3,
              maxLines: 6,
              inputContentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              hint: "Enter new description",
              inputTextStyle: CustomText("", fontSize: 16).effectiveStyle(context),
            ),
          ),
        ],
      ),
    );
  }
}
