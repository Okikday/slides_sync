import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/domain/models/course_model/course.dart';
import 'package:slides_sync/domain/models/file_details.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:slides_sync/shared/styles/colors.dart';
import 'package:slides_sync/shared/widgets/build_image_path_widget.dart';

class ListCourseCard extends ConsumerWidget {
  const ListCourseCard(
    this.course, {
    super.key,
    this.progress = 0.0,
    this.dotColor = Colors.transparent,
    this.isStarred = false,
    required this.onTapIcon,
  });
  final Course course;
  final double progress;
  final Color dotColor;
  final bool isStarred;
  final void Function() onTapIcon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.theme;
    final isDarkMode = ref.isDarkMode;
    return Badge(
      backgroundColor: Colors.transparent,
      label: CircleAvatar(radius: 5, backgroundColor: dotColor),
      offset: Offset(-12, 12),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        constraints: BoxConstraints(minHeight: 100, maxHeight: 140),
        decoration: BoxDecoration(
          color: theme.background.blendColor(isDarkMode ? 0.09 : 0.91),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            width: 2,
            color: theme.background.blendColor(isDarkMode ? 0.1 : 0.9),
          ),
          //   image: DecorationImage(
          //   image: AssetImage(Assets.images.instance.bookSparkleTransparentBg),
          //   opacity: 0.05,
          //   fit: BoxFit.cover,
          //   colorFilter: ColorFilter.mode(ref.theme.primaryColor, BlendMode.srcIn),
          // ),
        ),
        child: Row(
          children: [
            ListCourseCardIcon(
              onTapIcon: onTapIcon,
              isStarred: isStarred,
              fileDetails: course.imageLocationJson.fileDetails,
              courseCode: course.courseCode,
            ),

            Expanded(
              child: ListCourseCardTitleColumn(
                courseCode: course.courseCode,
                courseName: course.courseName,
                categoriesCount: course.collections.length,
                hasImage: course.imageLocationJson.fileDetails.containsFilePath,
              ),
            ),

            ListCourseCardProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

class ListCourseCardIcon extends ConsumerWidget {
  const ListCourseCardIcon({
    super.key,
    required this.fileDetails,
    this.courseCode = '',
    required this.isStarred,
    required this.onTapIcon,
  });

  final FileDetails fileDetails;
  final String courseCode;
  final bool isStarred;
  final void Function() onTapIcon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.theme;
    final dimension =
        context.deviceWidth < context.deviceHeight
            ? context.deviceWidth * 0.16
            : context.deviceHeight * 0.16;
    return InkWell(
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      onTap: onTapIcon,
      child: Badge(
        isLabelVisible: isStarred,
        backgroundColor: Colors.transparent,
        label: CircleAvatar(
          radius: 10.5,
          backgroundColor: Color(0xff0e1d27),
          child: Icon(Iconsax.star_1, size: 16, color: theme.primaryColor),
        ),
        offset: Offset(0, -2),
        child: Container(
          height: dimension,
          width: dimension,
          padding: EdgeInsets.all(2),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color:  theme.background.blendColor(context.isDarkMode ? 0.15 : 0.85),
            borderRadius: BorderRadius.circular(20),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: BuildImagePathWidget(
              height: dimension,
              width: dimension,
              fileDetails: fileDetails,
              fallbackWidget: Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                    courseCode.isEmpty
                        ? Icon(
                          Iconsax.document_1,
                          color: context.theme.colorScheme.primary,
                        )
                        : Center(
                          child: CustomText(
                            courseCode.substring(
                              0,
                              courseCode.length.clamp(0, 8),
                            ),
                            fontSize:
                                context.deviceWidth < context.deviceHeight
                                    ? context.deviceWidth * 0.025
                                    : context.deviceHeight * 0.025,
                            fontWeight: FontWeight.bold,
                            textAlign: TextAlign.center,
                            color: context.theme.colorScheme.primary,
                          ),
                        ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ListCourseCardTitleColumn extends ConsumerWidget {
  const ListCourseCardTitleColumn({
    super.key,
    required this.courseCode,
    required this.hasImage,
    required this.courseName,
    required this.categoriesCount,
  });

  final String courseCode;
  final bool hasImage;
  final String courseName;
  final int categoriesCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.theme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (courseCode.isNotEmpty && hasImage)
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: CustomTextButton(
              backgroundColor: theme.altBackgroundPrimary,
              pixelHeight: 24,
              borderRadius: 8,
              contentPadding: EdgeInsets.symmetric(horizontal: 5.0),
              child: CustomText(
                courseCode,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
            ),
          ),

        if (courseCode.isNotEmpty) ConstantSizing.columnSpacing(6.0),

        Flexible(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: CustomText(
              courseName,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: theme.primaryText,
            ),
          ),
        ),

        ConstantSizing.columnSpacing(4.0),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: CustomText(
            "${categoriesCount < 1 ? "No" : categoriesCount} ${categoriesCount == 1 ? "category" : "categories"}",
            fontSize: 11,
            color: theme.secondaryText.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }
}

class ListCourseCardProgressIndicator extends ConsumerWidget {
  const ListCourseCardProgressIndicator({super.key, this.progress = 0.0});

  final double? progress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.theme;
    return SizedBox.square(
      dimension: 40,
      child: Stack(
        children: [
          CustomElevatedButton(
            pixelWidth: 46,
            pixelHeight: 46,
            contentPadding: EdgeInsets.zero,
            shape: CircleBorder(),
            backgroundColor: theme.background,
            overlayColor: theme.altBackgroundSecondary,
            onClick: () {},
            child: CustomText(
              "${((progress?.clamp(0, 100) ?? 0.0) * 100.0).toInt()}%",
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: theme.secondaryText.withValues(alpha: 0.5),
            ),
          ),

          Positioned.fill(
            child: IgnorePointer(
              child: CircularProgressIndicator(
                value: progress?.clamp(0.01, 1.0),
                strokeCap: StrokeCap.round,
                color: theme.primaryColor,
                backgroundColor: theme.altBackgroundPrimary.withValues(
                  alpha: 0.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
