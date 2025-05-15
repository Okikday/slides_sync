import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/core/models/app_ui_model.dart';
import 'package:slides_sync/shared/models/course_model/course_model.dart';

class CourseDescriptionDialog extends ConsumerWidget {
  const CourseDescriptionDialog({
    super.key,
    required this.scaffoldBgColor,
    required this.appUiModel,
    required this.courseModel,
  });

  final Color scaffoldBgColor;
  final AppUiModel appUiModel;
  final CourseModel courseModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        Positioned.fill(
            child: GestureDetector(
          onTap: () => LoadingDialog.hideLoadingDialog(context),
        )),
        Align(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(color: scaffoldBgColor.withValues(alpha: 0.9), borderRadius: BorderRadius.circular(12)),
              width:
              appUiModel.deviceWidth > appUiModel.deviceHeight
                  ? appUiModel.deviceHeight * 0.85
                  : appUiModel.deviceWidth * 0.85,
              height:
              appUiModel.deviceWidth > appUiModel.deviceHeight
                  ? appUiModel.deviceHeight * 0.75
                  : appUiModel.deviceWidth * 0.75,
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              child: Column(
                children: [
                  ConstantSizing.columnSpacingSmall,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: CustomText("Course description", fontWeight: FontWeight.bold, fontSize: 18, textAlign: TextAlign.center),
                  ),
                  ConstantSizing.columnSpacingSmall,
                  Divider(color: appUiModel.isDarkMode ? Colors.lightBlue.withAlpha(40) : Colors.grey.withAlpha(40)),
                  Expanded(child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                      child: CustomText(courseModel.description, fontSize: 15, fontWeight: FontWeight.w600,))),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}