import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/core/storage/hive_data/app_hive_data.dart';
import 'package:slides_sync/core/storage/hive_data/hive_data_paths.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/domain/models/file_details.dart';

import 'package:slides_sync/shared/components/dialogs/app_action_dialog.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:slides_sync/shared/widgets/build_image_path_widget.dart';

class RecentDialog extends ConsumerStatefulWidget {
  final RecentDialogModel recentDialogModel;

  const RecentDialog({super.key, required this.recentDialogModel});

  @override
  ConsumerState createState() => _RecentDialogState();
}

class _RecentDialogState extends ConsumerState<RecentDialog> {
  @override
  Widget build(BuildContext context) {
    final theme = ref.theme;
    var divider = Divider(color: theme.primaryColor.withAlpha(40), height: 0);
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: ColoredBox(
        color: Colors.transparent,
        child: Center(
          child: GestureDetector(
            onTap: () {},
            child: Container(
              clipBehavior: Clip.hardEdge,
              margin: EdgeInsets.symmetric(
                horizontal: 32,
                vertical: context.deviceHeight > context.deviceWidth ? 0 : 32,
              ),
              width: context.deviceHeight > context.deviceWidth ? context.deviceWidth : context.deviceWidth * 0.5,
              height:
                  context.deviceHeight > context.deviceWidth
                      ? (context.deviceWidth * 1.25) - 64
                      : context.deviceHeight * 0.9,
              constraints: BoxConstraints(maxHeight: 320, maxWidth: 320),
              decoration: BoxDecoration(
                color: theme.surface.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: theme.altBackgroundPrimary),
              ),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    ConstantSizing.columnSpacing(24),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            clipBehavior: Clip.hardEdge,
                            margin: EdgeInsets.only(left: 12),
                            decoration: BoxDecoration(
                              color: context.theme.colorScheme.onSecondary.withAlpha(40),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: widget.recentDialogModel.imagePreview,
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CustomElevatedButton(
                                  backgroundColor: context.theme.colorScheme.onSecondary.withAlpha(40),
                                  shape: CircleBorder(),
                                  contentPadding: EdgeInsets.all(12),
                                  child: Icon(Iconsax.star_copy, size: 26, color: theme.supportingText),
                                ),
                                CustomElevatedButton(
                                  backgroundColor: context.theme.colorScheme.onSecondary.withAlpha(40),
                                  shape: CircleBorder(),
                                  contentPadding: EdgeInsets.all(12),
                                  child: Icon(Iconsax.note_add_copy, size: 26, color: theme.supportingText),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    ConstantSizing.columnSpacingLarge,

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 24.0, right: 12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              widget.recentDialogModel.title,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: theme.onBackground,
                            ),
                            ConstantSizing.columnSpacingSmall,
                            CustomText("Short detail", fontSize: 12.0, color: theme.supportingText),
                          ],
                        ),
                      ),
                    ),

                    if (widget.recentDialogModel.description.isNotEmpty) ConstantSizing.columnSpacingSmall,

                    if (widget.recentDialogModel.description.isNotEmpty)
                      Padding(padding: const EdgeInsets.symmetric(horizontal: 12.0), child: divider),

                    if (widget.recentDialogModel.description.isNotEmpty)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 24, top: 8.0, right: 12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                "Description",
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: theme.onBackground,
                              ),
                              ConstantSizing.columnSpacingSmall,
                              CustomText(
                                widget.recentDialogModel.description
                                    .substring(0, widget.recentDialogModel.description.length.clamp(0, 128))
                                    .padRight(3, "."),
                                fontSize: 13,
                                color: theme.supportingText,
                              ),
                            ],
                          ),
                        ),
                      ),

                    ConstantSizing.columnSpacingMedium,

                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        divider,

                        BuildPlainActionButton(
                          title: "Continue reading",
                          icon: Icon(Iconsax.play_copy, size: 24, color: theme.supportingText),
                          textStyle: TextStyle(fontSize: 16, color: theme.onBackground),
                          onTap: () {
                            if (widget.recentDialogModel.onContinueReading != null) {
                              widget.recentDialogModel.onContinueReading!();
                            }
                          },
                        ),

                        divider,

                        BuildPlainActionButton(
                          title: "Share",
                          icon: Icon(Icons.share_outlined, size: 24, color: theme.supportingText),
                          textStyle: TextStyle(fontSize: 15, color: theme.onBackground),
                          onTap: () {},
                        ),

                        divider,

                        BuildPlainActionButton(
                          title: "Remove from recents",
                          icon: Icon(Iconsax.box_remove_copy, size: 24, color: Colors.redAccent),
                          textStyle: TextStyle(fontSize: 15, color: theme.onBackground),
                          onTap: () {
                            if (widget.recentDialogModel.onDelete != null) widget.recentDialogModel.onDelete!();
                          },
                        ),

                        // BuildPlainActionButton(
                        //   title: "Delete",
                        //   icon: Icon(Iconsax.trash_copy, size: 24, color: Colors.redAccent),
                        //   textStyle: TextStyle(fontSize: 16, color: Colors.redAccent),
                        //   onTap: () {},
                        // ),
                        divider,
                      ],
                    ),

                    ConstantSizing.columnSpacing(24),
                  ],
                ),
              ),
            ).animate().fadeIn().scaleXY(
              begin: 0.4,
              end: 1,
              duration: Duration(milliseconds: 800),
              curve: CustomCurves.bouncySpring,
            ),
          ),
        ),
      ),
    );
  }
}

class RecentDialogModel {
  final String contentId;
  final Widget? imagePreview;
  final bool isStarred;
  final String title;
  final String description;
  final void Function()? onContinueReading;
  final void Function()? onStar;
  final void Function()? onShare;
  final void Function()? onDelete;

  RecentDialogModel({
    required this.contentId,
    this.imagePreview,
    required this.isStarred,
    required this.title,
    this.description = '',
    this.onContinueReading,
    this.onShare,
    this.onDelete,
    this.onStar,
  });
}
