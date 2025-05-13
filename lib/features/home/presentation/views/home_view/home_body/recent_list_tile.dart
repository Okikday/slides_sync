
import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/components/colors.dart';

class RecentListTile extends ConsumerWidget {
  final bool isDarkMode;
  final String title;
  final String subtitle;
  final String extraContent;
  final double? progress;
  final int? level;
  final bool isStarred;
  final void Function()? onTapTile;
  final void Function()? onLongTapTile;
  final void Function()? onTapPlay;
  const RecentListTile({
    super.key,
    required this.title,
    required this.subtitle,
    this.extraContent = "",
    this.onTapTile,
    this.onTapPlay,
    required this.isDarkMode,
    this.isStarred = false,
    this.progress,
    this.level,
    this.onLongTapTile,
  });

  static Color _resolveLevelColor(int? level) {
    return level == 0 ? Colors.red : (level == 1 ? Colors.orange : (level == 2 ? Colors.green : Colors.deepPurple));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.only(top: 12, left: 8, right: 8),
      child: DecoratedBox(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), ),
        child: CustomElevatedButton(
          backgroundColor: (isDarkMode ? Color(0xff0e1d27) : SlidesRepoColors.lightGray),
          overlayColor: Colors.lightBlueAccent.withAlpha(50),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          borderRadius: 12,
          onClick: () {
            if (onTapTile != null) onTapTile!();
          },
          onLongClick: () {
            if (onLongTapTile != null) onLongTapTile!();
          },
          child: Row(
            children: [
              Badge(
                backgroundColor: Colors.transparent,
                isLabelVisible: isStarred,
                label: CircleAvatar(
                  radius: 10.5,
                    backgroundColor: isDarkMode ? Color(0xff0e1d27) : SlidesRepoColors.lightGray,
                    child: Icon(Iconsax.star_1, size: 16, color: Colors.deepPurple,)),
                offset:  Offset(0, -2),
                child: CustomElevatedButton(
                  onClick: () {
                    if (onLongTapTile != null) onLongTapTile!();
                  },
                  pixelHeight: 48,
                  pixelWidth: 48,
                  borderRadius: 12,
                  backgroundColor: Colors.lightBlueAccent.withAlpha(100),
                  child: Icon(Iconsax.document_1, size: 26),
                ),
              ),

              ConstantSizing.rowSpacingMedium,

              Expanded(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    spacing: 4.0,
                    children: [
                      Flexible(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxHeight: 30),
                          child: CustomText(title, fontSize: 14, fontWeight: FontWeight.bold, height: 1.0),
                        ),
                      ),
                      Flexible(child: CustomText(subtitle, fontSize: extraContent.isEmpty ? 14 : 12, color: SlidesRepoColors.textSecondary)),
                      if(extraContent.isNotEmpty) Flexible(child: CustomText(extraContent, fontSize: 13,)),
                    ],
                  ),
                ),
              ),

              ConstantSizing.rowSpacingMedium,

              Stack(
                children: [
                  CustomElevatedButton(
                    pixelWidth: 46,
                    pixelHeight: 46,
                    contentPadding: EdgeInsets.zero,
                    shape: CircleBorder(),
                    backgroundColor: Colors.black,
                    overlayColor: Colors.lightBlueAccent.withAlpha(50),
                    onClick: () {
                      if (onTapPlay != null) onTapPlay!();
                    },
                    child:
                    progress == null
                        ? Icon(Iconsax.play, color: Colors.white, size: 26)
                        : CustomText("${(progress! * 100).truncate()}%", fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                  ),

                  if (progress != null)
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: IgnorePointer(
                        child: CircularProgressIndicator(value: progress, strokeCap: StrokeCap.round, color: _resolveLevelColor(level)),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
