import 'dart:ui';

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
      child: ClipRSuperellipse(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: UiStyles.getBlueThemedBoxDecoration(isDarkMode),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
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
          
                ConstantSizing.columnSpacingSmall,
          
                CustomText("${categoriesCount < 1 ? "No" : categoriesCount} categories", fontSize: 12, color: context.isDarkMode ? Colors.grey : Colors.deepPurple),
          
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
        ),
      ),
    );
  }
}
