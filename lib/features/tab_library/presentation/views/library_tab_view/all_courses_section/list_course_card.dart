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
          color: (isDarkMode ? AppColors.deepBlue : AppColors.lightGray),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(width: 2, color: Colors.lightBlueAccent.withAlpha(15)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(50),
              blurRadius: 8,
              offset: Offset(0, 0),
              blurStyle: BlurStyle.inner,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          children: [
            Badge(
              isLabelVisible: isStarred,
              backgroundColor: Colors.transparent,
              label: CircleAvatar(
                radius: 10.5,
                backgroundColor: isDarkMode ? Color(0xff0e1d27) : AppColors.lightGray,
                child: Icon(Iconsax.star_1, size: 16, color: Colors.deepPurple),
              ),
              offset: Offset(0, -2),
              child: ClipRSuperellipse(
                borderRadius: BorderRadius.circular(13),
                child: Container(
                  padding: EdgeInsets.all(2),
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    color: context.isDarkMode ? context.theme.cardColor.withValues(alpha: 0.1) : context.theme.cardColor.withAlpha(100),
                  ),
                  child: ClipRSuperellipse(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox.square(
                      dimension: context.deviceWidth < context.deviceHeight ? context.deviceWidth * 0.16 : context.deviceHeight * 0.16,
                      child: courseImageWidget,
                    ),
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
                      padding: const EdgeInsets.only(left: 13.0),
                      child: CustomTextButton(
                        backgroundColor: Colors.deepPurple.withAlpha(80),
                        pixelHeight: 24,
                        borderRadius: 12,
                        contentPadding: EdgeInsets.symmetric(horizontal: 7.0),
                        child: CustomText(courseCode, fontSize: 12, fontWeight: FontWeight.bold, color: Colors.deepPurpleAccent),
                      ),
                    ),

                  if (courseCode.isNotEmpty) ConstantSizing.columnSpacing(6.0),

                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: CustomText(courseName, fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),

                  ConstantSizing.columnSpacingSmall,

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: CustomText(
                      "${categoriesCount < 1 ? "No" : categoriesCount} categories",
                      fontSize: 12,
                      color: context.isDarkMode ? Colors.grey : Colors.deepPurple,
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
                    backgroundColor: context.isDarkMode ? Colors.lightBlueAccent.withAlpha(50) : AppColors.background.withAlpha(100),
                    overlayColor: Colors.lightBlueAccent.withAlpha(50),
                    onClick: () {},
                    child: CustomText(
                      "64%",
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: context.isDarkMode ? context.theme.cardColor : Colors.lightBlue,
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
                        backgroundColor: context.theme.cardColor.withAlpha(80),
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
