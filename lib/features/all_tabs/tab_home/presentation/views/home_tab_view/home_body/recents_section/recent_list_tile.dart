// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/features/all_tabs/tab_home/presentation/viewmodels/recent_list_tile_model.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

import 'package:slides_sync/shared/styles/colors.dart';

class RecentListTile extends ConsumerWidget {
  final bool isDarkMode;
  final double tilePadding;
  final RecentListTileModel dataModel;
  const RecentListTile({super.key, required this.isDarkMode, required this.dataModel, required this.tilePadding});

  Color _resolveLevelColor(BuildContext context, ProgressLevel level) {
    return level == ProgressLevel.danger
        ? Colors.red
        : (level == ProgressLevel.warning ? Colors.orange : (level == ProgressLevel.success ? Colors.green : context.theme.primaryColor));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.only(top: 12, left: 8, right: 8),
      child: CustomElevatedButton(
        backgroundColor: HSLColor.fromColor(context.theme.scaffoldBackgroundColor).withLightness(0.1).toColor(),
        overlayColor: HSLColor.fromColor(context.theme.scaffoldBackgroundColor).withLightness(0.12).toColor(),
        contentPadding: EdgeInsets.all(tilePadding),
        borderRadius: 12,
        onClick: () {
          if (dataModel.onTapTile != null) dataModel.onTapTile!();
        },
        onLongClick: () {
          if (dataModel.onLongTapTile != null) dataModel.onLongTapTile!();
        },
        child: Row(
          children: [
            Badge(
              backgroundColor: Colors.transparent,
              isLabelVisible: dataModel.isStarred,
              label: CircleAvatar(
                radius: 10.5,
                backgroundColor: isDarkMode ? Color(0xff0e1d27) : AppColors.lightGray,
                child: Icon(Iconsax.star_1, size: 16, color: context.theme.primaryColor),
              ),
              offset: Offset(0, -2),
              child: CustomElevatedButton(
                onClick: () {
                  if (dataModel.onLongTapTile != null) dataModel.onLongTapTile!();
                },
                pixelHeight: 48,
                pixelWidth: 48,
                borderRadius: 12,
                backgroundColor: context.theme.primaryColor.withValues(alpha: 0.1),
                child: Icon(Iconsax.document_1, size: 26, color: context.theme.primaryColor),
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
                        child: CustomText(
                          dataModel.title,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          height: 1.0,
                          color: context.theme.colorScheme.tertiary,
                        ),
                      ),
                    ),
                    Flexible(
                      child: CustomText(
                        dataModel.subtitle,
                        fontSize: dataModel.extraContent.isEmpty ? 14 : 12,
                        color: context.theme.colorScheme.onTertiary.withValues(alpha: 0.5),
                      ),
                    ),
                    if (dataModel.extraContent.isNotEmpty) Flexible(child: CustomText(dataModel.extraContent, fontSize: 13)),
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
                  backgroundColor: context.theme.colorScheme.surface,
                  overlayColor: context.theme.colorScheme.secondary.withAlpha(50),
                  onClick: () {
                    if (dataModel.onTapPlay != null) dataModel.onTapPlay!();
                  },
                  child:
                      dataModel.progress == null
                          ? Icon(Iconsax.play, color: context.theme.cardColor, size: 26)
                          : CustomText(
                            "${(dataModel.progress! * 100).truncate()}%",
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: context.theme.colorScheme.onTertiary.withValues(alpha: 0.5),
                          ),
                ),

                if (dataModel.progress != null)
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: IgnorePointer(
                      child: CircularProgressIndicator(
                        value: dataModel.progress,
                        strokeCap: StrokeCap.round,
                        color: _resolveLevelColor(context, dataModel.progressLevel),
                        backgroundColor: context.theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
