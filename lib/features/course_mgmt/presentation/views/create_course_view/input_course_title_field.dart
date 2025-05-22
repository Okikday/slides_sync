import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:slides_sync/shared/styles/app_ui_context.dart';

class InputCourseTitleField extends StatelessWidget {
  const InputCourseTitleField({
    super.key,
    required this.courseNameController,
  });

  final TextEditingController courseNameController;

  @override
  Widget build(BuildContext context) {
    return CustomTextfield(
      controller: courseNameController,
      backgroundColor: Colors.grey.withAlpha(40),
      cursorColor: CustomText("").effectiveStyle(context).color ?? Colors.white,
      selectionHandleColor: Colors.deepPurple,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: context.isDarkMode ? Colors.lightBlueAccent.withAlpha(80) : Colors.deepPurple.withAlpha(20),
        ),
      ),
      pixelWidth: context.deviceWidth,
      pixelHeight: 60,
      inputContentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 18),
      hint: "Enter course title",
      inputTextStyle: CustomText("", fontSize: 16).effectiveStyle(context),
      onTapOutside: () {},
    
      suffixIcon: CustomElevatedButton(
        pixelWidth: 50,
        pixelHeight: 50,
        borderRadius: 12,
        overlayColor: Colors.deepPurple.withAlpha(40),
        onClick: () {},
        backgroundColor: Colors.transparent,
        child: Icon(Icons.keyboard_arrow_down_rounded, size: 30),
      ),
      alwaysShowSuffixIcon: true,
    );
  }
}