import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/domain/models/course_model/course.dart';
import 'package:slides_sync/domain/models/file_details.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:slides_sync/shared/styles/colors.dart';
import 'package:slides_sync/shared/widgets/build_image_path_widget.dart';
import 'package:stacked_card_carousel/stacked_card_carousel.dart';

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
      clipBehavior: Clip.hardEdge,
      margin: const EdgeInsets.all(1.5),

      constraints: BoxConstraints(maxWidth: 200, maxHeight: 200),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(22),
        // border: Border.all(width: 2, color: theme.bgLightenColor(.88, .12)),
        //   image: DecorationImage(
        //     image: Assets.images.bookSparkleTransparentBg.asImageProvider,
        //   opacity: 0.05,
        //     colorFilter: ColorFilter.mode(
        //       theme.primaryColor,
        //       BlendMode.srcIn,
        //     ),
        // ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          for (int i = 0; i < 3; i++)
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: theme.onSurface.withValues(alpha: 0.4 + (i * 0.3)),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.only(
                top: (12.0 * i) + 12,
                left: (12.0 * (3 - (i + 1))) + 12,
                right: (12.0 * (3 - (i + 1))) + 12,
                bottom: 12,
              ),
              child: Row(
                spacing: 20,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.red.withAlpha(120)),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (int i = 0; i < 3; i++)
                          Container(
                            margin: EdgeInsets.only(bottom: 4),
                            decoration: BoxDecoration(
                              color: Colors.red.withAlpha(180),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            height: 8,
                            width: 100,
                          ),
                      ],
                    ),
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
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.adjustBgAndPrimaryWithLerp,
                border: Border(top: BorderSide(color: theme.onPrimary.withAlpha(40))),
              ),
              child: Column(
                spacing: 2,
                children: [
                  CustomText(course.courseName, color: theme.onBackground, fontWeight: FontWeight.bold),
                  CustomText(
                    "${categoriesCount < 1 ? "No" : categoriesCount} ${categoriesCount == 1 ? "collection" : "collections"}",
                    fontSize: 10,
                    color: theme.supportingText.withAlpha(200),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
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
    );
  }
}
