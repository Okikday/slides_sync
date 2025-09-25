// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/domain/models/file_details.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:slides_sync/shared/styles/colors.dart';
import 'package:slides_sync/shared/widgets/build_image_path_widget.dart';

class RecentListTile extends ConsumerWidget {
  final bool isDarkMode;
  final double tilePadding;
  final RecentListTileModel dataModel;
  const RecentListTile({super.key, required this.isDarkMode, required this.dataModel, required this.tilePadding});

  Color _resolveLevelColor(WidgetRef ref, ProgressLevel level) {
    return level == ProgressLevel.danger
        ? Colors.red
        : (level == ProgressLevel.warning
            ? Colors.orange
            : (level == ProgressLevel.success ? Colors.green : ref.theme.primaryColor));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.theme;
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: theme.onBackground.withAlpha(10))),
      ),

      child: InkWell(
        // backgroundColor: context.isDarkMode ? HSLColor.fromColor(context.theme.scaffoldBackgroundColor).withLightness(0.1).toColor() : HSLColor.fromColor(context.theme.scaffoldBackgroundColor).withLightness(0.9).toColor(),
        overlayColor: WidgetStatePropertyAll(theme.altBackgroundPrimary),
        onTap: () {
          if (dataModel.onTapTile != null) dataModel.onTapTile!();
        },
        onLongPress: () {
          if (dataModel.onLongTapTile != null) dataModel.onLongTapTile!();
        },
        child: Padding(
          padding: EdgeInsets.all(tilePadding).copyWith(left: tilePadding + 8, right: tilePadding + 8),
          child: Row(
            children: [
              Badge(
                backgroundColor: Colors.transparent,
                isLabelVisible: dataModel.isStarred,
                label: CircleAvatar(
                  radius: 10.5,
                  backgroundColor: Color(0xff0e1d27),
                  child: Icon(Iconsax.star_1, size: 16, color: theme.primaryColor),
                ),
                offset: Offset(0, -2),
                child: ClipOval(
                  child: CustomElevatedButton(
                    onClick: () {
                      if (dataModel.onLongTapTile != null) dataModel.onLongTapTile!();
                    },
                    pixelHeight: 48,
                    pixelWidth: 48,
                    shape: CircleBorder(),
                    contentPadding: EdgeInsets.zero,
                    backgroundColor: theme.altBackgroundPrimary.withValues(alpha: 1),
                    child: BuildImagePathWidget(
                      width: 48,
                      height: 48,
                      fileDetails: FileDetails(filePath: dataModel.previewPath ?? ''),
                      fallbackWidget: Icon(Iconsax.document_1, size: 26, color: ref.theme.primary),
                    ),
                  ),
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
                            color: theme.onBackground,
                          ),
                        ),
                      ),
                      Flexible(
                        child: CustomText(
                          dataModel.subtitle,
                          fontSize: dataModel.extraContent.isEmpty ? 14 : 12,
                          color: theme.supportingText.withValues(alpha: 0.8),
                        ),
                      ),
                      if (dataModel.extraContent.isNotEmpty)
                        Flexible(child: CustomText(dataModel.extraContent, fontSize: 13)),
                    ],
                  ),
                ),
              ),

              ConstantSizing.rowSpacingMedium,

              Stack(
                children: [
                  CustomElevatedButton(
                    pixelWidth: 40,
                    pixelHeight: 40,
                    contentPadding: EdgeInsets.zero,
                    shape: CircleBorder(),
                    backgroundColor: context.theme.colorScheme.surface,
                    overlayColor: context.theme.colorScheme.secondary.withAlpha(50),
                    onClick: () {
                      if (dataModel.onTapPlay != null) dataModel.onTapPlay!();
                    },
                    child: dataModel.progress == null
                        ? Icon(Iconsax.play, color: context.theme.cardColor, size: 26)
                        : CustomText(
                            "${(dataModel.progress! * 100).truncate()}%",
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: theme.supportingText.withValues(alpha: 0.5),
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
                          color: _resolveLevelColor(ref, dataModel.progressLevel),
                          backgroundColor: theme.altBackgroundSecondary.withValues(alpha: 0.4),
                        ),
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

enum ProgressLevel { neutral, warning, danger, success }

class RecentListTileModel {
  final String title;
  final String subtitle;
  final String extraContent;
  final String? previewPath;
  final double? progress;
  final ProgressLevel progressLevel;
  final bool isStarred;
  final void Function()? onTapTile;
  final void Function()? onLongTapTile;
  final void Function()? onTapPlay;

  RecentListTileModel({
    required this.title,
    required this.subtitle,
    this.extraContent = "",
    this.previewPath,
    this.progress,
    required this.progressLevel,
    required this.isStarred,
    this.onTapTile,
    this.onLongTapTile,
    this.onTapPlay,
  });

  RecentListTileModel copyWith({
    String? title,
    String? subtitle,
    String? extraContent,
    String? previewPath,
    double? progress,
    ProgressLevel? progressLevel,
    bool? isStarred,
    void Function()? onTapTile,
    void Function()? onLongTapTile,
    void Function()? onTapPlay,
  }) {
    return RecentListTileModel(
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      extraContent: extraContent ?? this.extraContent,
      previewPath: previewPath ?? this.previewPath,
      progress: progress ?? this.progress,
      progressLevel: progressLevel ?? this.progressLevel,
      isStarred: isStarred ?? this.isStarred,
      onTapTile: onTapTile ?? this.onTapTile,
      onLongTapTile: onLongTapTile ?? this.onLongTapTile,
      onTapPlay: onTapPlay ?? this.onTapPlay,
    );
  }

  @override
  bool operator ==(covariant RecentListTileModel other) {
    if (identical(this, other)) return true;

    return other.title == title &&
        other.subtitle == subtitle &&
        other.extraContent == extraContent &&
        other.previewPath == previewPath &&
        other.progress == progress &&
        other.progressLevel == progressLevel &&
        other.isStarred == isStarred &&
        other.onTapTile == onTapTile &&
        other.onLongTapTile == onLongTapTile &&
        other.onTapPlay == onTapPlay;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        subtitle.hashCode ^
        extraContent.hashCode ^
        previewPath.hashCode ^
        progress.hashCode ^
        progressLevel.hashCode ^
        isStarred.hashCode ^
        onTapTile.hashCode ^
        onLongTapTile.hashCode ^
        onTapPlay.hashCode;
  }
}
