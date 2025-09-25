import 'dart:ui';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/domain/models/course_model/course.dart';
import 'package:slides_sync/domain/models/file_details.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:slides_sync/shared/styles/theme/app_theme_model.dart';
import 'package:slides_sync/shared/widgets/build_image_path_widget.dart';

class GridCourseCard extends ConsumerWidget {
  const GridCourseCard(
    this.course, {
    super.key,
    this.dimension,
    this.progress = 0.0,
    this.dotColor = Colors.transparent,
    this.isStarred = false,
    required this.onTapIcon,
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
    final isDarkMode = theme.isDarkTheme;
    final dimension = 50;
    return Container(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.all(1.5),

      constraints: BoxConstraints(maxWidth: 200, maxHeight: 200),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(22),
        // border: Border.all(width: 1, color: Colors.white),
        //   image: DecorationImage(
        //     image: Assets.images.bookSparkleTransparentBg.asImageProvider,
        //   opacity: 0.05,
        //     colorFilter: ColorFilter.mode(
        //       theme.primaryColor,
        //       BlendMode.srcIn,
        //     ),
        // ),
        boxShadow: [
          BoxShadow(
            color: AppThemeModel.lightenColor(theme.surface, 0.5).withAlpha(200),
            offset: Offset(-2.5, 2.2),
            spreadRadius: -2,
            blurRadius: 10,
            blurStyle: BlurStyle.inner,
          ),
          BoxShadow(
            color: AppThemeModel.lightenColor(theme.surface, 0.5).withAlpha(200),
            offset: Offset(2.1, -2.2),
            spreadRadius: -2,
            blurRadius: 10,
            blurStyle: BlurStyle.inner,
          ),
          ...(context.isDarkMode
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    offset: Offset(0, 1),
                    blurRadius: 3,
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    offset: Offset(0, 4),
                    blurRadius: 6,
                    spreadRadius: 0,
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.05),
                    offset: Offset(0, 1),
                    blurRadius: 2,
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.04),
                    offset: Offset(0, 6),
                    blurRadius: 12,
                    spreadRadius: -2,
                  ),
                ]),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          for (int i = 0; i < 3; i++)
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppThemeModel.lightenColor(
                  theme.surface.withValues(alpha: 0.4 + (i * 0.3)),
                  context.isDarkMode ? 0.3 : 0.75,
                ),
                borderRadius: BorderRadius.circular(20),
                // border: i == 2
                //     ? Border.all(color: AppThemeModel.lightenColor(theme.surface, 0.5).withAlpha(200))
                //     : null
              ),
              padding: EdgeInsets.all(12).copyWith(bottom: 40),
              margin: EdgeInsets.only(
                top: (10.0 * i) + 12,
                left: (10.0 * (3 - (i + 1))) + 12,
                right: (10.0 * (3 - (i + 1))) + 12,
                bottom: 24,
              ),
              child: Row(
                spacing: 8,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          // color: theme.surface.withAlpha(100),
                          color: context.isDarkMode
                              ? theme.surface.withAlpha(100)
                              : theme.adjustBgAndPrimaryWithLerpExtra.withValues(alpha: 0.5),
                          boxShadow: (context.isDarkMode
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.08),
                                    offset: Offset(0, 1),
                                    blurRadius: 3,
                                    spreadRadius: 0,
                                  ),
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.06),
                                    offset: Offset(0, 4),
                                    blurRadius: 6,
                                    spreadRadius: 0,
                                  ),
                                ]
                              : [
                                  BoxShadow(
                                    color: Colors.white.withValues(alpha: 0.05),
                                    offset: Offset(0, 1),
                                    blurRadius: 2,
                                    spreadRadius: 0,
                                  ),
                                  BoxShadow(
                                    color: Colors.white.withValues(alpha: 0.04),
                                    offset: Offset(0, 6),
                                    blurRadius: 12,
                                    spreadRadius: -2,
                                  ),
                                ]),
                        ),
                        // child: SizedBox(width: 40, height: 40),
                        child: SizedBox.square(
                          dimension: 40,
                          child: BuildImagePathWidget(
                            width: 40,
                            height: 40,
                            fileDetails: course.imageLocationJson.fileDetails,
                            fallbackWidget: Icon(
                              Iconsax.star,
                              size: 16,
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (courseCode.isNotEmpty)
                    Flexible(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: theme.altBackgroundSecondary.withAlpha(100),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: FittedBox(
                            child: CustomText(
                              course.courseCode,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: theme.secondary,
                            ),
                          ),
                        ),
                      ),
                      // child: Column(
                      //   mainAxisSize: MainAxisSize.min,
                      //   spacing: 2.5,
                      //   children: [
                      //     for (int i = 0; i < 3; i++)
                      //       DecoratedBox(
                      //         decoration: BoxDecoration(
                      //           color: theme.altBackgroundSecondary,
                      //           borderRadius: BorderRadius.circular(4),
                      //         ),
                      //         child: SizedBox(height: 8, width: double.infinity),
                      //       ),
                      //   ],
                      // ),
                  ),
                ],
              ),
            ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 60,
              width: 200,
              clipBehavior: Clip.antiAlias,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.adjustBgAndPrimaryWithLerpExtra.withValues(alpha: 0.9),
                border: Border(top: BorderSide(color: AppThemeModel.lightenColor(theme.surface, 0.5).withAlpha(200))),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                child: Column(
                  children: [
                    Flexible(
                      child: CustomText(
                        course.courseName,
                        color: theme.onBackground,
                        fontWeight: FontWeight.bold,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.fade,
                        fontSize: 13,
                      ),
                    ),
                    CustomText(
                      "${categoriesCount < 1 ? "No" : categoriesCount} ${categoriesCount == 1 ? "collection" : "collections"}",
                      fontSize: 10,
                      color: theme.supportingText.withAlpha(200),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}




    // child: Padding(
      //   padding: const EdgeInsets.only(top: 8, bottom: 0),
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     mainAxisSize: MainAxisSize.min,
      //     children: [
      //       Padding(
      //         padding: const EdgeInsets.fromLTRB(8, 0, 6, 6),
      //         child: Row(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: [
      //             InkWell(
      //               customBorder: const CircleBorder(),
      //               onTap: onTapIcon,
      //               child: CircleAvatar(
      //                 radius: dimension / 2 - 3,
      //                 backgroundColor: context.theme.cardColor.withAlpha(80),
      //                 child: ClipOval(
      //                   child: CircleAvatar(
      //                     radius: dimension / 2 - 4,
      //                     // backgroundColor: theme.bgLightenColor(.88, .12),
      //                     backgroundColor: theme.altBackgroundPrimary,
      //                     child: SizedBox.square(
      //                       dimension: dimension - 8,
      //                       child: BuildImagePathWidget(
      //                         fileDetails: course.imageLocationJson.fileDetails,
      //                         fallbackWidget: Icon(
      //                           Iconsax.document_1,
      //                           size: 16,
      //                           color: isDarkMode ? Colors.white : Colors.black,
      //                         ),
      //                       ),
      //                     ),
      //                   ),
      //                 ),
      //               ),
      //             ),
      //             if (courseCode.isNotEmpty)
      //               Flexible(
      //                 child: Align(
      //                   alignment: Alignment.topRight,
      //                   child: Padding(
      //                     padding: const EdgeInsets.only(left: 8.0),
      //                     child: CustomTextButton(
      //                       backgroundColor: theme.altBackgroundPrimary,
      //                       pixelHeight: 24,
      //                       borderRadius: 14,
      //                       contentPadding: EdgeInsets.symmetric(horizontal: 6.0),
      //                       child: CustomText(
      //                         courseCode,
      //                         fontSize: 10,
      //                         fontWeight: FontWeight.bold,
      //                         color: theme.primaryColor.withAlpha(200),
      //                       ),
      //                     ),
      //                   ),
      //                 ),
      //               ),
      //           ],
      //         ),
      //       ),
      //       Expanded(
      //         child: Padding(
      //           padding: const EdgeInsets.symmetric(horizontal: 8.0),
      //           child: Align(
      //             alignment: Alignment.centerLeft,
      //             child: CustomText(
      //               course.courseName,
      //               overflow: TextOverflow.fade,
      //               fontWeight: FontWeight.bold,
      //               fontSize: 13.5,
      //               color: theme.onBackground,
      //             ),
      //           ),
      //         ),
      //       ),

      //       ConstantSizing.columnSpacing(4.0),

      //       // if (categoriesCount > 0)
      //       Padding(
      //         padding: const EdgeInsets.symmetric(horizontal: 10.0),
      //         child: CustomText(
      //           "${categoriesCount < 1 ? "No" : categoriesCount} ${categoriesCount == 1 ? "collection" : "collections"}",
      //           fontSize: 11,
      //           color: theme.supportingText,
      //         ),
      //       ),

      //       ConstantSizing.columnSpacing(8),

      //       LinearProgressIndicator(
      //         minHeight: 4,

      //         value: (progress).clamp(0.1, 1.0),
      //         backgroundColor: theme.altBackgroundPrimary.withValues(alpha: 0.2),
      //         // color: theme.bgLightenColor(.88, .12), //.withAlpha(40)
      //         color: theme.altBackgroundPrimary,
      //       ),
      //     ],
      //   ),
      // ),