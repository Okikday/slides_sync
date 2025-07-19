import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:slides_sync/shared/styles/colors.dart';

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
    required this.hasImage,
    this.courseImageWidget,
    required this.onTapIcon
  });

  final String courseCode;
  final String courseName;
  final int categoriesCount;
  final double progress;
  final bool isDarkMode;
  final Color dotColor;
  final bool isStarred;
  final bool hasImage;
  final Widget? courseImageWidget;
  final void Function() onTapIcon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Badge(
      backgroundColor: Colors.transparent,
      label: CircleAvatar(radius: 5, backgroundColor: dotColor),
      offset: Offset(-12, 12),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        constraints: BoxConstraints(minHeight: 100, maxHeight: 140),
        decoration: BoxDecoration(
          color: AppColors.bgBlendColor(context),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(width: 2, color: AppColors.bgBlendColor(context, .88, .12)),
        ),
        child: Row(
          children: [
            InkWell(
              customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              onTap: onTapIcon,
              child: Badge(
                isLabelVisible: isStarred,
                backgroundColor: Colors.transparent,
                label: CircleAvatar(
                  radius: 10.5,
                  backgroundColor: Color(0xff0e1d27),
                  child: Icon(Iconsax.star_1, size: 16, color: context.theme.primaryColor),
                ),
                offset: Offset(0, -2),
                child: Container(
                  padding: EdgeInsets.all(2),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: context.theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SizedBox.square(
                    dimension: context.deviceWidth < context.deviceHeight ? context.deviceWidth * 0.16 : context.deviceHeight * 0.16,
                    child: courseImageWidget,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (courseCode.isNotEmpty && hasImage)
                    Padding(
                      padding: const EdgeInsets.only(left: 6.0),
                      child: CustomTextButton(
                        backgroundColor: context.theme.primaryColor.withAlpha(80),
                        pixelHeight: 24,
                        borderRadius: 12,
                        contentPadding: EdgeInsets.symmetric(horizontal: 7.0),
                        child: CustomText(courseCode, fontSize: 12, fontWeight: FontWeight.bold, color: context.theme.colorScheme.outline),
                      ),
                    ),

                  if (courseCode.isNotEmpty) ConstantSizing.columnSpacing(6.0),

                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: CustomText(courseName, fontSize: 14, fontWeight: FontWeight.bold, color: context.theme.colorScheme.tertiary),
                    ),
                  ),

                  ConstantSizing.columnSpacing(4.0),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: CustomText(
                      "${categoriesCount < 1 ? "No" : categoriesCount} ${categoriesCount == 1 ? "category" : "categories"}",
                      fontSize: 11,
                      color: context.theme.colorScheme.onTertiary.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox.square(
              dimension: 40,
              child: Stack(
                children: [
                  CustomElevatedButton(
                    pixelWidth: 46,
                    pixelHeight: 46,
                    contentPadding: EdgeInsets.zero,
                    shape: CircleBorder(),
                    backgroundColor: context.theme.colorScheme.surface,
                    overlayColor: context.theme.colorScheme.secondary.withAlpha(50),
                    onClick: () {},
                    child: CustomText(
                      "64%",
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: context.theme.colorScheme.onTertiary.withValues(alpha: 0.5),
                    ),
                  ),

                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: IgnorePointer(
                      child: CircularProgressIndicator(
                        value: 0.64,
                        strokeCap: StrokeCap.round,
                        color: context.theme.primaryColor,
                        backgroundColor: context.theme.colorScheme.onSurface,
                      ),
                    ),
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
