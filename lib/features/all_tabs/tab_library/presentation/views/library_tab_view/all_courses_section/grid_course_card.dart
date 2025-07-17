import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:slides_sync/shared/styles/colors.dart';
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
    required this.dimension,
  });

  final String courseCode;
  final String courseName;
  final int categoriesCount;
  final double progress;
  final bool isDarkMode;
  final Color dotColor;
  final Widget? courseImageWidget;
  final double dimension;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Badge(
      backgroundColor: Colors.transparent,
      label: CircleAvatar(radius: 5, backgroundColor: dotColor),
      offset: Offset(-12, 12),
      child: Container(
        decoration: BoxDecoration(
          color: HSLColor.fromColor(context.theme.scaffoldBackgroundColor).withLightness(0.1).toColor(),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(width: 2, color: HSLColor.fromColor(context.theme.scaffoldBackgroundColor).withLightness(0.12).toColor()),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: dimension / 2 - 3,
                      backgroundColor: context.theme.cardColor.withAlpha(80),
                      child: ClipOval(
                        child: CircleAvatar(
                          radius: dimension / 2 - 4,
                          backgroundColor: HSLColor.fromColor(context.theme.scaffoldBackgroundColor).withLightness(0.12).toColor(),
                          child: SizedBox.square(dimension: dimension - 8, child: courseImageWidget),
                        ),
                      ),
                    ),
                    if (courseCode.isNotEmpty)
                      Flexible(
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: CustomTextButton(
                              backgroundColor: context.theme.primaryColor.withAlpha(40),
                              pixelHeight: 24,
                              borderRadius: 6,
                              contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: CustomText(
                                courseCode,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: context.theme.primaryColor.withAlpha(200),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: CustomText(
                      courseName,
                      overflow: TextOverflow.fade,
                      fontWeight: FontWeight.bold,
                      color: context.theme.colorScheme.tertiary,
                    ),
                  ),
                ),
              ),

              ConstantSizing.columnSpacing(4.0),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: CustomText(
                  "${categoriesCount < 1 ? "No" : categoriesCount} ${categoriesCount == 1 ? "collection" : "collections"}",
                  fontSize: 12,
                  color: context.theme.colorScheme.onTertiary.withValues(alpha: 0.8),
                ),
              ),

              ConstantSizing.columnSpacing(14),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  spacing: 8.0,
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        minHeight: 12,
                        borderRadius: BorderRadius.circular(36),
                        value: (progress).clamp(0.1, 1.0),
                        backgroundColor: Colors.black.withAlpha(40),
                        color: context.theme.primaryColor, //.withAlpha(40)
                      ),
                    ),
                    // CustomText("${(progress * 100).truncate()}%", fontSize: 10, fontWeight: FontWeight.bold),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
