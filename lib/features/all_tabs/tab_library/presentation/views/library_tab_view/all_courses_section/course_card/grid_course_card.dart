import 'dart:math';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/domain/models/course_model/course.dart';
import 'package:slides_sync/domain/models/file_details.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:slides_sync/shared/styles/colors.dart';
import 'package:slides_sync/shared/widgets/build_image_path_widget.dart';

class GridCourseCard extends ConsumerWidget {
  const GridCourseCard(this.course,{
    super.key,
    this.dimension,
    this.progress = 0.0,
    this.dotColor = Colors.transparent,
    this.isStarred = false,
    required this.onTapIcon
  });

  final Course course;
  final double? dimension;
  final double progress;
  final Color dotColor;
  final bool isStarred;
  final void Function() onTapIcon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.theme;
    final courseCode = course.courseCode;
    final categoriesCount = course.collections.length;
    final isDarkMode = context.isDarkMode;
    // final double dimension = (context.deviceWidth > context.deviceHeight ? context.deviceWidth * 0.12 : context.deviceWidth * 0.12);
    final dimension = 50;
    return Badge(
      backgroundColor: Colors.transparent,
      label: CircleAvatar(radius: 5, backgroundColor: dotColor),
      offset: Offset(-12, 12),
      child: Container(
        clipBehavior: Clip.hardEdge,
        constraints: BoxConstraints(maxWidth: 200, maxHeight: 200),
        decoration: BoxDecoration(
          color: theme.background.blendColor(isDarkMode ? 0.09 : 0.91),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(width: 2, color: AppColors.bgBlendColor(context, .88, .12)),
          //   image: DecorationImage(
          //     image: Assets.images.bookSparkleTransparentBg.asImageProvider,
          //   opacity: 0.05,
          //     colorFilter: ColorFilter.mode(
          //       ref.theme.primaryColor,
          //       BlendMode.srcIn,
          //     ),
          // ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 6, 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      customBorder: const CircleBorder(),
                      onTap: onTapIcon,
                      child: CircleAvatar(
                        radius: dimension / 2 - 3,
                        backgroundColor: context.theme.cardColor.withAlpha(80),
                        child: ClipOval(
                          child: CircleAvatar(
                            radius: dimension / 2 - 4,
                            // backgroundColor: AppColors.bgBlendColor(context, .88, .12),
                            backgroundColor: theme.altBackgroundPrimary,
                            child: SizedBox.square(dimension: dimension - 8, child: BuildImagePathWidget(
                    fileDetails: course.imageLocationJson.fileDetails,
                    fallbackWidget: Icon(Iconsax.document_1, size: 16, color: isDarkMode ? Colors.white : Colors.black),
                  ),),
                          ),
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
                              backgroundColor: theme.altBackgroundPrimary,
                              pixelHeight: 24,
                              borderRadius: 8,
                              contentPadding: EdgeInsets.symmetric(horizontal: 5.0),
                              child: CustomText(
                                courseCode,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: ref.theme.primaryColor.withAlpha(200),
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
                      course.courseName,
                      overflow: TextOverflow.fade,
                      fontWeight: FontWeight.bold,
                      fontSize: 13.5,
                      color: ref.theme.primaryText,
                    ),
                  ),
                ),
              ),

              ConstantSizing.columnSpacing(4.0),

              if (categoriesCount > 0)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: CustomText(
                    "${categoriesCount < 1 ? "No" : categoriesCount} ${categoriesCount == 1 ? "collection" : "collections"}",
                    fontSize: 12,
                    color: ref.theme.secondaryText.withValues(alpha: 0.8),
                  ),
                ),

              ConstantSizing.columnSpacing(14),

              LinearProgressIndicator(
                minHeight: 12,
                
                value: (progress).clamp(0.1, 1.0),
                backgroundColor: theme.altBackgroundPrimary.withValues(alpha: 0.2),
                // color: AppColors.bgBlendColor(context, .88, .12), //.withAlpha(40)
                color: theme.altBackgroundPrimary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
