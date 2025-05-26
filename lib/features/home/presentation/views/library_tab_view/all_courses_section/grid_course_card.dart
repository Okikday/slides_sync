import 'dart:developer';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/shared/styles/app_ui_context.dart';
import 'package:slides_sync/shared/styles/external/ui_styles.dart';

class GridCourseCard extends ConsumerWidget {
  const GridCourseCard({
    super.key,
    this.courseCode = '',
    required this.courseName,
    required this.categoriesCount,
    required this.progress,
    required this.isDarkMode,
    this.dotColor = Colors.transparent,
    this.courseImageWidget,
  });

  final String courseCode;
  final String courseName;
  final int categoriesCount;
  final double progress;
  final bool isDarkMode;
  final Color dotColor;
  final Widget? courseImageWidget;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Badge(
      backgroundColor: Colors.transparent,
      label: CircleAvatar(radius: 5, backgroundColor: dotColor),
      offset: Offset(-12, 12),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            decoration: UiStyles.getBlueThemedBoxDecoration(isDarkMode),
            child: Stack(
              children: [
                Positioned(
                  right: 12.0,
                  top: 12.0,
                  child: CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.deepPurple,
                    child: ClipOval(child: SizedBox.square(dimension: 20, child: courseImageWidget)),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                spacing: 8,
                                children: [
                                  if (courseCode.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: CustomText(courseCode, fontSize: 15, fontWeight: FontWeight.bold),
                                    ),

                                  Flexible(
                                    child: CustomText(
                                      courseName,
                                      fontSize: courseCode.isNotEmpty ? 12 : 14,
                                      fontWeight: courseCode.isEmpty ? FontWeight.bold : FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            ConstantSizing.rowSpacing(28),
                          ],
                        ),
                      ),

                      ConstantSizing.columnSpacingSmall,

                      CustomText(
                        "${categoriesCount < 1 ? "No" : categoriesCount} categories",
                        fontSize: 12,
                        color: context.isDarkMode ? Colors.grey : Colors.deepPurple,
                      ),

                      ConstantSizing.columnSpacing(16),

                      Row(
                        spacing: 8.0,
                        children: [
                          Expanded(
                            child: LinearProgressIndicator(
                              minHeight: 16,
                              borderRadius: BorderRadius.circular(36),
                              value: (progress).clamp(0.1, 1.0),
                              backgroundColor: Colors.black.withAlpha(40),
                              color: Colors.deepPurple, //.withAlpha(40)
                            ),
                          ),
                          CustomText("${(progress * 100).truncate()}%", fontSize: 12, fontWeight: FontWeight.bold),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
