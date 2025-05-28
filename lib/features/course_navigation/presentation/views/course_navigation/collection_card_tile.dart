import 'dart:ui';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class CollectionCardTile extends ConsumerWidget {
  final bool isDarkMode;
  final String title;
  final IconData iconData;
  final int subCollectionCount;
  final int contentCount;

  /// This entails on click the icon or on long press
  final void Function()? onSelected;
  final void Function()? onTap;
  const CollectionCardTile(
    this.isDarkMode, {
    super.key,
    required this.title,
    this.iconData = Iconsax.book,
    this.subCollectionCount = 0,
    this.contentCount = 0,
    this.onSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: ColoredBox(
          color: isDarkMode ? Color(0xFF143850) : Color(0xFFDBF3FF),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: () {
                  if (onTap != null) onTap!();
                },
                onLongPress: () {
                  if (onSelected != null) onSelected!();
                },
                overlayColor: WidgetStatePropertyAll(Colors.blueGrey),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 16),
                  //Color(0xFF485BAD)
                  decoration: BoxDecoration(
                    color: isDarkMode ? Color(0xFF163343).withValues(alpha: 0.89) : Color(0xFFDBF3FF).withValues(alpha: 0.89),

                    borderRadius: BorderRadius.circular(12),
                    border: Border.fromBorderSide(BorderSide.none),
                  ),
                  child: Row(
                    children: [
                      CustomElevatedButton(
                        onClick: () {
                          if (onSelected != null) onSelected!();
                        },
                        contentPadding: EdgeInsets.all(8.0),
                        backgroundColor: Colors.lightBlueAccent.withAlpha(25),
                        child: Icon(iconData, size: 24, color: isDarkMode ? Colors.white : Colors.black),
                      ),
                      ConstantSizing.rowSpacingMedium,
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
                      ConstantSizing.rowSpacingMedium,
                      Icon(Iconsax.arrow_right, color: isDarkMode ? Colors.white : Colors.black),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
