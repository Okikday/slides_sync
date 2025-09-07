import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

class PositionedCourseOptions extends ConsumerWidget {
  const PositionedCourseOptions({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.theme;
    return Positioned(
      bottom: context.bottomPadding + 16,
      left: 10,
      right: 10,
      child: Row(
        spacing: 12,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CustomElevatedButton(
            borderRadius: 16,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            backgroundColor: theme.supportingText.withAlpha(10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 4,
              children: [
                Flexible(
                  child: Icon(Iconsax.play, color: theme.supportingText),
                ),
                Flexible(
                  child: CustomText(
                    "Continue from last content",
                    fontSize: 13,
                    color: theme.onBackground,
                  ),
                ),
              ],
            ),
          ),
    
          CustomElevatedButton(
            pixelHeight: 48,
            pixelWidth: 48,
            borderRadius: 16,
            backgroundColor: theme.altBackgroundPrimary,
            child: Icon(Icons.download_rounded, color: theme.supportingText),
          ),
        ],
      ),
    );
  }
}
