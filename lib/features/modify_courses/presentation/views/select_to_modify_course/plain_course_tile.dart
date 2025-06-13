import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/core/models/file_location.dart';
import 'package:slides_sync/shared/helpers/widget_helper.dart';
import 'package:slides_sync/shared/styles/app_ui_context.dart';
import 'package:slides_sync/shared/styles/external/ui_styles.dart';
import 'package:slides_sync/shared/widgets/build_image_path_widget.dart';

class PlainCourseTile extends ConsumerWidget {
  const PlainCourseTile({
    super.key,
    required this.isDarkMode,
    required this.courseName,
    required this.courseCode,
    required this.categoriesCount,
    required this.syncImagePath,
    required this.selectionState,
    required this.onTap,
    required this.onSelected,
  });
  final bool isDarkMode;
  final String courseName;
  final String courseCode;
  final int categoriesCount;
  final String syncImagePath;

  final ({bool selected, bool isSelecting}) selectionState;

  final void Function() onTap;
  final void Function() onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      onLongPress: onSelected,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        constraints: BoxConstraints(minHeight: 90, maxHeight: 140),
        decoration: UiStyles.getBlueThemedBoxDecoration(isDarkMode),
        child: Row(
          children: [
            ClipOval(
              // borderRadius: BorderRadius.circular(13),
              child: ColoredBox(
                color: Colors.deepPurple.withAlpha(80),
                child: Padding(
                  padding: EdgeInsets.all(2),
                  child: ClipOval(
                    child: SizedBox.square(dimension: 44, child: BuildImagePathWidget(fileLocation: syncImagePath.fileLocation)),
                  ),
                ),
              ),
            ).animate().fade(begin: selectionState.selected ? 1.0 : 0.5, end: selectionState.selected ? 0.5 : 1.0,),
            ConstantSizing.rowSpacingMedium,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (courseCode.isNotEmpty) CustomText(courseCode, fontSize: 13),

                  if (courseCode.isNotEmpty) ConstantSizing.columnSpacing(4),

                  Flexible(child: CustomText(courseName, fontSize: 14, fontWeight: FontWeight.bold)),

                  ConstantSizing.columnSpacing(4.0),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // CustomText("This is a Content."),
                      CustomText("$categoriesCount items", fontSize: 12, color: context.isDarkMode ? Colors.grey : Colors.deepPurple),
                    ],
                  ),
                ],
              ),
            ),

            ConstantSizing.rowSpacingMedium,

            SizedBox.square(
              dimension: 40,
              child: Icon(
                selectionState.isSelecting && !selectionState.selected ? Icons.circle_outlined : 
                (selectionState.isSelecting && selectionState.selected ? Iconsax.tick_circle : Iconsax.arrow_right),
                color:
                    selectionState.isSelecting && !selectionState.selected
                        ? Colors.grey
                        : (selectionState.isSelecting && selectionState.selected
                        ? Colors.deepPurple
                        : (isDarkMode ? Colors.white : Colors.black)),
                size: 32,
              ),
            ).animate().scale(begin: Offset(0, 0), end: Offset(1, 1), curve: CustomCurves.bouncySpring, duration: Durations.extralong4),
          ],
        ),
      ),
    );
  }
}
