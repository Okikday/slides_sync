import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:slides_sync/shared/styles/external/ui_styles.dart';

class CourseCategoriesCard extends ConsumerWidget {
  final bool isDarkMode;
  final String title;
  final Widget icon;
  final int contentCount;
  final void Function() onTap;
  const CourseCategoriesCard({
    super.key,
    required this.isDarkMode,
    required this.title,
    required this.onTap,
    required this.icon,
    this.contentCount = 0,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: DecoratedBox(
        decoration: UiStyles.getBlueThemedBoxDecoration(isDarkMode),
        child: Padding(
          padding: EdgeInsets.all(16),

          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: context.theme.primaryColor.withAlpha(100),
                  shape: BoxShape.circle,
                  border: Border.fromBorderSide(BorderSide(color: Colors.deepPurpleAccent.withAlpha(40), width: 1.0)),
                ),
                child: icon,
              ),
              ConstantSizing.rowSpacingMedium,
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4.0,
                  children: [
                    CustomText(title, fontSize: 15),
                    CustomText("${contentCount == 0 ? "No" : "$contentCount"} ${contentCount == 1 ? "item" : "items"}", fontSize: 12, color: Colors.grey),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
