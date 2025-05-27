import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/shared/helpers/widget_helper.dart';
import 'package:slides_sync/shared/styles/app_ui_context.dart';
import 'package:slides_sync/shared/styles/external/ui_styles.dart';

class PlainCourseTile extends ConsumerWidget {
  const PlainCourseTile({
    super.key,
    required this.isDarkMode,
    required this.courseName,
    required this.courseCode,
    required this.categoriesCount,
    this.syncImagePath,
    required this.onTap,
  });
  final bool isDarkMode;
  final String courseName;
  final String courseCode;
  final int categoriesCount;
  final String? syncImagePath;
  final void Function() onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        constraints: BoxConstraints(minHeight: 100, maxHeight: 140),
        decoration: UiStyles.getBlueThemedBoxDecoration(isDarkMode),
        child: Row(
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: (){},
              child: ClipRSuperellipse(
                borderRadius: BorderRadius.circular(13),
                child: ColoredBox(
                  color: Colors.deepPurple.withAlpha(80),
                  child: Padding(
                    padding: EdgeInsets.all(2),
                    child: ClipRSuperellipse(
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox.square(dimension: 44, child: WidgetHelper.resolveImageWidget(syncImagePath)),
                    ),
                  ),
                ),
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

            SizedBox.square(dimension: 40, child: Icon(Iconsax.arrow_right, color: isDarkMode ? Colors.white : Colors.black, size: 32,)),
          ],
        ),
      ),
    );
  }
}
