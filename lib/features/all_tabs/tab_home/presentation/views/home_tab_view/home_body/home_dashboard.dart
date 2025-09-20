import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/shared/assets/assets.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:slides_sync/shared/styles/colors.dart';

class HomeDashboard extends ConsumerWidget {
  const HomeDashboard({
    super.key,
    required this.courseName,
    required this.detail,
    required this.progressValue,
    this.completed,
    this.onReadingBtnTapped,
    this.onShareTapped,
    this.isFirst
  });

  final String courseName;
  final String detail;
  final double progressValue;
  final bool? completed;
  final void Function()? onReadingBtnTapped;
  final void Function()? onShareTapped;

  final bool? isFirst;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.theme;
    return Container(
      constraints: BoxConstraints(maxHeight: 160, maxWidth: 400),
      width: context.deviceWidth,
      clipBehavior: Clip.antiAlias,
      padding: EdgeInsets.only(left: 12, right: 12, top: 16, bottom: 12),
      // margin: EdgeInsets.only(left: isFirst  == null ? 8 : 12, right: isFirst == null ? 0 : (isFirst! ? 0 : 12)),
      margin: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: theme.adjustBgAndPrimaryWithLerp,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          width: 2,
          color: theme.adjustBgAndPrimaryWithLerpExtra,
        ),
        // image: DecorationImage(
        //   image: Assets.images.bookSparkleTransparentBg.asImageProvider,
        //   fit: BoxFit.cover,
        //   opacity: 0.03,
        //   colorFilter: ColorFilter.mode(
        //     theme.primaryColor,
        //     BlendMode.srcIn,
        //   ),
        // ),
        // boxShadow: [BoxShadow(color: HSLColor.fromColor(context.theme.scaffoldBackgroundColor).withLightness(0.1).toColor(), blurRadius: 4, spreadRadius: 2)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Tooltip(
                  message: courseName,
                  triggerMode: TooltipTriggerMode.tap,
                  child: CustomText(
                    courseName,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: theme.onBackground,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ),
          if (detail.isNotEmpty) ConstantSizing.columnSpacingSmall,
          if (detail.isNotEmpty)
            CustomText(
              detail,
              fontSize: 13,
              color: theme.supportingText.withValues(alpha: 0.9),
            ),
          ConstantSizing.columnSpacingSmall,

          // Row(
          //   children: [
          //     Expanded(
          //       child: Badge(
          //         backgroundColor: Colors.transparent,
          //         // offset: Offset(-32, 10),
          //         // label: CustomText("${(progressValue * 100).truncate()}%", fontWeight: FontWeight.bold, fontSize: 13),
          //         child: LinearProgressIndicator(
          //           minHeight: 36,
          //           borderRadius: BorderRadius.circular(36),
          //           value: progressValue,
          //           backgroundColor: Colors.black.withAlpha(40),
          //           color: theme.primaryColor.withValues(alpha: 0.6),
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
          ConstantSizing.columnSpacingLarge,

          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            spacing: 10,
            children: [
              Expanded(
                child: ClipRSuperellipse(
                  borderRadius: BorderRadiusGeometry.circular(12),
                  child: CustomElevatedButton(
                    pixelHeight: 48,
                    elevation: 100,
                    borderRadius: 0,
                    overlayColor: context.theme.colorScheme.onPrimary.withAlpha(20),
                    backgroundColor: theme.primaryColor,
                    child: CustomText(
                      completed != null ? (completed! ? "Read next slide" : "Continue reading...") : "Start Reading",
                      fontSize: 15,
                      color: theme.onPrimary,
                    ),
                    onClick: () {
                      if (onReadingBtnTapped != null) onReadingBtnTapped!();
                    },
                  ),
                ),
              ),

              // ConstantSizing.rowSpacing(4),
              if (completed != null)
                Stack(
                children: [
                  CustomElevatedButton(
                    pixelWidth: 46,
                    pixelHeight: 46,
                    contentPadding: EdgeInsets.zero,
                    shape: CircleBorder(),
                    backgroundColor: theme.background,
                    onClick: () {},
                    child: CustomText(
                        "${((progressValue.clamp(0, 100)) * 100.0).toInt()}%",
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: theme.onBackground,
                    ),
                  ),

                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: IgnorePointer(
                      child: CircularProgressIndicator(
                          value: ((progressValue.clamp(0, 100))).toDouble(),
                        strokeCap: StrokeCap.round,
                        color: theme.primaryColor,
                        backgroundColor: theme.altBackgroundSecondary
                            .withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                ],
              ),
              // CustomElevatedButton(
              //   pixelHeight: 48,
              //   pixelWidth: 48,
              //   borderRadius: 12,
              //   elevation: 10,
              //   overlayColor: Colors.white.withAlpha(50),
              //   backgroundColor: context.isDarkMode ? theme.primaryColor.withAlpha(160) : Colors.black,
              //   onClick: () {
              //     if (onShareTapped != null) onShareTapped!();
              //   },
              //   child: Icon(Icons.share_rounded, color: Colors.white),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
