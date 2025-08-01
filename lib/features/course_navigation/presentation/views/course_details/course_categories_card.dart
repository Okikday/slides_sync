import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:slides_sync/shared/styles/colors.dart';

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
        decoration: BoxDecoration(
          color: AppColors.bgBlendColor(context, .96, .04),
          border: Border.all(color: AppColors.bgBlendColor(context)),
          borderRadius: BorderRadius.circular(12)
        ),
        child: Padding(
          padding: EdgeInsets.all(16),

          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                clipBehavior: Clip.hardEdge,
                padding: EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: AppColors.primary(context).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                  border: Border.fromBorderSide(BorderSide(color: AppColors.primary(context).withAlpha(40), width: 1.0)),
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
                    CustomText(title, fontSize: 15, color: context.theme.colorScheme.tertiary),
                    CustomText(
                      "${contentCount == 0 ? "No" : "$contentCount"} ${contentCount == 1 ? "item" : "items"}",
                      fontSize: 12,
                      color: context.theme.colorScheme.onTertiary,
                    ),
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
