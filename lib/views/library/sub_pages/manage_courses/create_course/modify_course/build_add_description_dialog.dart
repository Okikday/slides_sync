import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/app/models/app_ui_model.dart';
import 'package:slides_sync/use_cases/library/models/course_model.dart';
import 'package:slides_sync/views/library/sub_pages/manage_courses/create_course/modify_course.dart';

class BuildAddDescriptionDialog extends ConsumerStatefulWidget {
  final AppUiModel appUiModel;
  final String title;
  final NotifierProvider<ModifyCourseModelNotifier, CourseModel> courseProvider;

  const BuildAddDescriptionDialog({super.key, required this.appUiModel, required this.title, required this.courseProvider});

  @override
  ConsumerState<BuildAddDescriptionDialog> createState() => _BuildAddDescriptionDialogState();
}

class _BuildAddDescriptionDialogState extends ConsumerState<BuildAddDescriptionDialog> {
  late final TextEditingController textEditingController;

  @override
  initState() {
    super.initState();
    textEditingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final Color scaffoldBgColor = Theme.of(context).scaffoldBackgroundColor;

    return Align(
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(color: scaffoldBgColor, borderRadius: BorderRadius.circular(12)),
              // height: appUiModel.deviceWidth > appUiModel.deviceHeight ? appUiModel.deviceHeight * 0.75 : appUiModel.deviceWidth * 0.75,
              width:
                  widget.appUiModel.deviceWidth > widget.appUiModel.deviceHeight
                      ? widget.appUiModel.deviceHeight * 0.85
                      : widget.appUiModel.deviceWidth * 0.85,
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: CustomText(widget.title, fontWeight: FontWeight.bold, fontSize: 15, textAlign: TextAlign.center),
                  ),
                  ConstantSizing.columnSpacingMedium,
                  Divider(color: widget.appUiModel.isDarkMode ? Colors.lightBlue.withAlpha(40) : Colors.grey.withAlpha(40)),
                  ConstantSizing.columnSpacingMedium,
                  CustomTextfield(
                    backgroundColor: Colors.grey.withAlpha(40),
                    cursorColor: CustomText("").effectiveStyle(context).color ?? Colors.white,
                    selectionHandleColor: Colors.deepPurple,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: widget.appUiModel.isDarkMode ? Colors.lightBlueAccent.withAlpha(80) : Colors.deepPurple.withAlpha(20),
                      ),
                    ),
                    pixelWidth: widget.appUiModel.deviceWidth,
                    constraints: BoxConstraints(minHeight: 60, maxHeight: 120),
                    maxLines: 8,
                    inputContentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    hint: "Enter description",
                    controller: textEditingController,
                    inputTextStyle: CustomText("", fontSize: 16).effectiveStyle(context),
                  ),
                  ConstantSizing.columnSpacingLarge,
                  CustomElevatedButton(
                    label: "Add description",
                    textColor: Colors.white,
                    textSize: 14,
                    pixelHeight: 48,
                    backgroundColor: Colors.deepPurple,
                    onClick: () {
                      final String text = textEditingController.text;
                      if (text.isEmpty || text.length < 4 || text.length > 128) return;
                      final CourseModel currentCourseModel = ref.watch(widget.courseProvider);
                      ref.read(widget.courseProvider.notifier).update(currentCourseModel.copyWith(description: text));
                      LoadingDialog.hideLoadingDialog(context);
                    },
                  ),
                ],
              ),
            ).animate().moveY(begin: -48, end: 0, curve: CustomCurves.defaultIosSpring, duration: Durations.extralong3).fadeIn(),

            Positioned(
              top: 8,
              right: 8,
              child: CustomElevatedButton(
                shape: CircleBorder(),
                onClick: () {
                  Navigator.of(context).pop();
                },
                backgroundColor: Colors.transparent,
                child: Icon(Iconsax.close_circle, size: 30),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
