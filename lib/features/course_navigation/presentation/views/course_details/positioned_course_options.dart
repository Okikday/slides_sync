import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

class PositionedCourseOptions extends StatelessWidget {
  const PositionedCourseOptions({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: context.bottomPadding + 8,
      left: 10,
      child: Row(
        spacing: 12,
        children: [
          CustomElevatedButton(
            borderRadius: 16,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            backgroundColor: context.theme.colorScheme.onTertiary,
            child: CustomText("Continue Reading", fontSize: 13, color: context.theme.scaffoldBackgroundColor),
          ),
    
          CustomElevatedButton(
            pixelHeight: 48,
            pixelWidth: 48,
            borderRadius: 16,
            backgroundColor: context.theme.colorScheme.onSurface.withValues(alpha: 0.8),
            child: Icon(Iconsax.note, color: context.theme.colorScheme.onTertiary),
          ),
        ],
      ),
    );
  }
}
