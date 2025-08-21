import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/shared/assets/assets.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:slides_sync/shared/styles/colors.dart';
import 'package:slides_sync/shared/styles/theme/themes.dart';

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
    required this.onTapIcon
  });

  final String courseCode;
  final String courseName;
  final int categoriesCount;
  final double progress;
  final bool isDarkMode;
  final Color dotColor;
  final Widget? courseImageWidget;
  final double dimension;
  final void Function() onTapIcon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.theme;
    return Badge(
      backgroundColor: Colors.transparent,
      label: CircleAvatar(radius: 5, backgroundColor: dotColor),
      offset: Offset(-12, 12),
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: AppColors.bgBlendColor(context),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(width: 2, color: AppColors.bgBlendColor(context, .88, .12)),
          image: DecorationImage(
            image: Assets.images.bookSparkleTransparentBg.asImageProvider,
          opacity: 0.05,
            colorFilter: ColorFilter.mode(
              ref.theme.primaryColor,
              BlendMode.srcIn,
            ),
        ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
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
                            backgroundColor: AppColors.bgBlendColor(context, .88, .12),
                            child: SizedBox.square(dimension: dimension - 8, child: courseImageWidget),
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
                      courseName,
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

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  spacing: 8.0,
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        minHeight: 12,
                        borderRadius: BorderRadius.circular(16),
                        value: (progress).clamp(0.1, 1.0),
                        backgroundColor: theme.altBackgroundSecondary
                            .withValues(alpha: 0.2),
                        color: ref.theme.primaryColor, //.withAlpha(40)
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
