import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/shared/styles/app_ui_context.dart';
import 'package:slides_sync/shared/styles/colors.dart';
import 'package:slides_sync/shared/styles/external/ui_styles.dart';

class ListCourseCard extends ConsumerWidget {
  const ListCourseCard({
    super.key,
    this.courseCode = '',
    required this.courseName,
    required this.categoriesCount,
    required this.progress,
    required this.isDarkMode,
    this.dotColor = Colors.transparent,
    this.isStarred = false,
  });

  final String courseCode;
  final String courseName;
  final int categoriesCount;
  final double progress;
  final bool isDarkMode;
  final Color dotColor;
  final bool isStarred;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Badge(
      backgroundColor: Colors.transparent,
      label: CircleAvatar(radius: 5, backgroundColor: dotColor),
      offset: Offset(-12, 12),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        constraints: BoxConstraints(minHeight: 120, maxHeight: 140),
        decoration: UiStyles.getBlueThemedBoxDecoration(isDarkMode),
        child: Row(
          children: [
            Badge(
              isLabelVisible: isStarred,
              backgroundColor: Colors.transparent,
              label: CircleAvatar(
                radius: 10.5,
                backgroundColor: isDarkMode ? Color(0xff0e1d27) : SlidesRepoColors.lightGray,
                child: Icon(Iconsax.star_1, size: 16, color: Colors.deepPurple),
              ),
              offset: Offset(0, -2),
              child: CustomElevatedButton(
                onClick: () {},
                pixelHeight: 48,
                pixelWidth: 48,
                borderRadius: 12,
                backgroundColor: Colors.lightBlueAccent.withAlpha(100),
                child: Icon(Iconsax.document_1, size: 26),
              ),
            ),
            ConstantSizing.rowSpacingMedium,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (courseCode.isNotEmpty) CustomText(courseCode, fontSize: 13),

                  if (courseCode.isNotEmpty) ConstantSizing.columnSpacing(4),

                  Flexible(child: CustomText(courseName, fontSize: 14, fontWeight: FontWeight.bold)),

                  ConstantSizing.columnSpacingSmall,

                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // CustomText("This is a Content."),
                      CustomText("$categoriesCount categories", fontSize: 12, color: context.isDarkMode ? Colors.grey : Colors.deepPurple),
                    ],
                  ),
                ],
              ),
            ),

            ConstantSizing.rowSpacingMedium,

            SizedBox.square(
              dimension: 40,
              child: Stack(
                clipBehavior: Clip.hardEdge,
                children: [
                  CircleAvatar(
                    radius: 20,
                    child: CircularProgressIndicator(
                      strokeCap: StrokeCap.round,
                      value: progress,
                      backgroundColor: Colors.black.withAlpha(40),
                    ),
                  ),

                  Align(alignment: Alignment.center, child: CustomText("${(progress * 100).truncate()}%", fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
