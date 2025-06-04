import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/core/models/file_location.dart';
import 'package:slides_sync/shared/styles/app_ui_context.dart';
import 'package:slides_sync/shared/widgets/build_image_path_widget.dart';

class CollectionCardTile extends ConsumerWidget {
  final String title;
  final int subCollectionCount;
  final int contentCount;

  /// This entails on click the icon or on long press
  final void Function()? onSelected;
  final void Function()? onTap;
  const CollectionCardTile({
    super.key,
    required this.title,
    this.subCollectionCount = 0,
    this.contentCount = 0,
    this.onSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ClipRSuperellipse(
      borderRadius: BorderRadius.circular(16),
      child: ColoredBox(
        color: context.isDarkMode ? Color.fromARGB(255, 52, 33, 79) : Color(0xFFDBF3FF),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: CustomElevatedButton(
            onClick: () {
              if (onTap != null) onTap!();
            },
            onLongClick: () {
              if (onSelected != null) onSelected!();
            },
            borderRadius: 12,
            contentPadding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 16),
            backgroundColor: context.isDarkMode ? Color.fromARGB(255, 46, 29, 70) : Color(0xFFDBF3FF).withValues(alpha: 0.89),
            child: Row(
              spacing: ConstantSizing.spaceMedium,
              children: [
                CustomElevatedButton(
                  onClick: () {
                    if (onSelected != null) onSelected!();
                  },
                  contentPadding: EdgeInsets.all(8.0),
                  backgroundColor: Colors.lightBlueAccent.withAlpha(25),
                  child: BuildImagePathWidget(
                    fileLocation: FileLocation(),
                    fallbackWidget: Icon(
                      Iconsax.document,
                      size: 22,
                      color: context.isDarkMode ? Colors.deepPurpleAccent : Colors.deepPurple,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(title, fontWeight: FontWeight.bold),
                      ConstantSizing.columnSpacing(4),
                      if (subCollectionCount > 0 || contentCount > 0)
                        CustomText(
                          "${subCollectionCount < 1 ? '' : "$subCollectionCount collections"}${(contentCount > 0 && subCollectionCount > 0) ? ", " : ''}${contentCount < 1 ? '' : "$contentCount items"}",
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
