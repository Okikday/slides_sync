import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/shared/styles/app_ui_context.dart';

class InputCourseCodeField extends ConsumerWidget {
  final TextEditingController courseCodeController;
  const InputCourseCodeField({super.key, required this.courseCodeController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: CustomTextfield(
            backgroundColor: Colors.lightBlueAccent.withAlpha(40),
            cursorColor: CustomText("").effectiveStyle(context).color ?? Colors.white,
            selectionHandleColor: Colors.deepPurple,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: context.isDarkMode ? Colors.lightBlueAccent.withAlpha(80) : Colors.deepPurple.withAlpha(20)),
            ),
            onTapOutside: () {},
            constraints: BoxConstraints(maxWidth: 180),
            pixelHeight: 60,
            inputContentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 18),
            hint: "Enter course code",
            inputTextStyle: CustomText("", fontSize: 16).effectiveStyle(context),
          ),
        ),

        Positioned(
          left: 4,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 32,
                width: 4,
                decoration: BoxDecoration(color: Colors.grey.withAlpha(40), borderRadius: BorderRadius.circular(12)),
              ),
              Container(
                width: context.deviceWidth - 48 - 180,
                height: 4,
                decoration: BoxDecoration(color: Colors.grey.withAlpha(40), borderRadius: BorderRadius.circular(12)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
