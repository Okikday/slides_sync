import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/shared/styles/external/ui_styles.dart';

class GridCourseCard extends ConsumerWidget {
  const GridCourseCard({
    super.key,
    required this.courseCode,
    required this.courseName,
    required this.categoriesCount,
    required this.progress,
    required this.isDarkMode,
    this.dotColor = Colors.transparent,
  });

  final String courseCode;
  final String courseName;
  final int categoriesCount;
  final double progress;
  final bool isDarkMode;
  final Color dotColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Badge(
      backgroundColor: Colors.transparent,
      label: CircleAvatar(radius: 5, backgroundColor: dotColor),
      offset: Offset(-12, 12),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: UiStyles.getBlueThemedBoxDecoration(isDarkMode),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(padding: const EdgeInsets.only(top: 4), child: CustomText(courseCode, fontSize: 15, fontWeight: FontWeight.bold)),

            ConstantSizing.columnSpacing(8),

            CustomText(courseName, fontSize: 11, fontWeight: FontWeight.bold),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // CustomText("This is a Content."),
                  CustomText("$categoriesCount categories", fontSize: 14),
                ],
              ),
            ),

            ConstantSizing.columnSpacing(16),
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    minHeight: 16,
                    borderRadius: BorderRadius.circular(36),
                    value: progress,
                    backgroundColor: Colors.black.withAlpha(40),
                    color: Colors.deepPurple, //.withAlpha(40)
                  ),
                ),
                ConstantSizing.rowSpacing(8),
                CustomText("${(progress * 100).truncate()}%", fontSize: 12),
              ],
            ),
          ],
        ),
      ),
    );
  }
}