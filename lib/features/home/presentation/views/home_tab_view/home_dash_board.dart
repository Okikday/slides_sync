import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/shared/styles/app_ui_context.dart';
import 'package:slides_sync/shared/styles/colors.dart';

class HomeDashBoard extends ConsumerWidget {
  const HomeDashBoard({
    super.key,
    required this.courseName,
    required this.detail,
    required this.progressValue,
    this.completed,
    this.onReadingBtnTapped,
    this.onShareTapped,
  });

  final String courseName;
  final String detail;
  final double progressValue;
  final bool? completed;
  final void Function()? onReadingBtnTapped;
  final void Function()? onShareTapped;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: ConstantSizing.spaceMedium),
      child: Container(
        constraints: BoxConstraints(maxHeight: 200),
        width: context.deviceWidth,
        padding: EdgeInsets.only(left: 12, right: 12, top: 16, bottom: 12),
        decoration: BoxDecoration(
          color: (context.isDarkMode ? SlidesRepoColors.deepBlue : SlidesRepoColors.lightGray),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(width: 2, color: Colors.lightBlueAccent.withAlpha(25)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FittedBox(child: CustomText(courseName, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            ConstantSizing.columnSpacingSmall,
            Row(
              children: [
                Expanded(
                  child: CustomText(
                    detail,
                    fontSize: 13,
                    color: context.isDarkMode ? SlidesRepoColors.darkTextSecondary : SlidesRepoColors.textSecondary,
                  ),
                ),
                ConstantSizing.rowSpacingHuge,
              ],
            ),
            ConstantSizing.columnSpacingMedium,
            Row(
              children: [
                Expanded(
                  child: Badge(
                    backgroundColor: Colors.transparent,
                    offset: Offset(-32, 10),
                    label: CustomText("${(progressValue * 100).truncate()}%", fontWeight: FontWeight.bold, fontSize: 13),
                    child: LinearProgressIndicator(
                      minHeight: 36,
                      borderRadius: BorderRadius.circular(36),
                      value: progressValue,
                      backgroundColor: Colors.black.withAlpha(40),
                      color: context.isDarkMode ? Colors.deepPurple.withAlpha(150) : Colors.deepPurple.withAlpha(200),
                    ),
                  ),
                ),
              ],
            ),

            ConstantSizing.columnSpacingMedium,

            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                spacing: 10,
                children: [
                  Expanded(
                    child: CustomElevatedButton(
                      pixelHeight: 48,
                      elevation: 100,
                      borderRadius: 12,
                      overlayColor: Colors.lightBlueAccent.withAlpha(50),
                      backgroundColor: context.isDarkMode ? Colors.black.withAlpha(40) : Colors.lightBlueAccent.withAlpha(40),
                      label: completed != null ? (completed! ? "Read next slide" : "Continue reading...") : "Start Reading",
                      textColor: context.isDarkMode ? Colors.white : SlidesRepoColors.darkBlue,
                      textSize: 15,
                      onClick: () {
                        if (onReadingBtnTapped != null) onReadingBtnTapped!();
                      },
                    ),
                  ),
                  CustomElevatedButton(
                    pixelHeight: 48,
                    pixelWidth: 48,
                    borderRadius: 12,
                    elevation: 10,
                    overlayColor: Colors.white.withAlpha(50),
                    backgroundColor: context.isDarkMode ? Colors.deepPurple.withAlpha(160) : Colors.black,
                    onClick: () {
                      if (onShareTapped != null) onShareTapped!();
                    },
                    child: Icon(Icons.share_rounded, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
