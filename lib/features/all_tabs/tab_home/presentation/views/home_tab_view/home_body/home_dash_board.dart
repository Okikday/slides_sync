import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:slides_sync/shared/strings/asset_strings.dart';
import 'package:slides_sync/shared/styles/colors.dart';

class HomeDashBoard extends ConsumerWidget {
  const HomeDashBoard({
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
    return Container(
      constraints: BoxConstraints(maxHeight: 100, maxWidth: 400),
      width: context.deviceWidth,
      clipBehavior: Clip.hardEdge,
      padding: EdgeInsets.only(left: 12, right: 12, top: 16, bottom: 12),
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: AppColors.bgBlendColor(context),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(width: 2, color: AppColors.bgBlendColor(context, .88, .12)),
        image: DecorationImage(
          image: AssetImage(AssetStrings.instance.bookSparkleTransparentBg),
          fit: BoxFit.cover,
          opacity: 0.03,
          colorFilter: ColorFilter.mode(context.theme.primaryColor, BlendMode.srcIn),
        ),
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
                child: FittedBox(
                  child: CustomText(courseName, fontSize: 16, fontWeight: FontWeight.bold, color: context.theme.colorScheme.tertiary),
                ),
              ),
            ),
          ),
          if (detail.isNotEmpty) ConstantSizing.columnSpacingSmall,
          if (detail.isNotEmpty) CustomText(detail, fontSize: 13, color: context.theme.colorScheme.onTertiary),
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
          //           color: context.theme.primaryColor.withValues(alpha: 0.6),
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
                child: CustomElevatedButton(
                  pixelHeight: 48,
                  elevation: 100,
                  borderRadius: 12,
                  overlayColor: context.theme.colorScheme.onPrimary.withAlpha(20),
                  backgroundColor: context.theme.colorScheme.primary,
                  child: CustomText(
                    completed != null ? (completed! ? "Read next slide" : "Continue reading...") : "Start Reading",
                    fontSize: 15,
                    color: context.theme.colorScheme.tertiary,
                  ),
                  onClick: () {
                    if (onReadingBtnTapped != null) onReadingBtnTapped!();
                  },
                ),
              ),

              // ConstantSizing.rowSpacing(4),
              Stack(
                children: [
                  CustomElevatedButton(
                    pixelWidth: 46,
                    pixelHeight: 46,
                    contentPadding: EdgeInsets.zero,
                    shape: CircleBorder(),
                    backgroundColor: context.theme.colorScheme.surface,
                    onClick: () {},
                    child: CustomText("50%", fontSize: 11, fontWeight: FontWeight.bold, color: context.theme.colorScheme.tertiary),
                  ),

                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: IgnorePointer(
                      child: CircularProgressIndicator(value: 0.5, strokeCap: StrokeCap.round, color: context.theme.primaryColor),
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
              //   backgroundColor: context.isDarkMode ? context.theme.primaryColor.withAlpha(160) : Colors.black,
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
