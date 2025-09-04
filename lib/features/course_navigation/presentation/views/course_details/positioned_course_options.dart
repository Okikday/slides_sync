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
            backgroundColor: ref.theme.bgSupportText.withAlpha(10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 4,
              children: [
                Flexible(
                  child: Icon(Iconsax.play, color: ref.theme.secondaryText),
                ),
                Flexible(
                  child: CustomText(
                    "Continue from last content",
                    fontSize: 13,
                    color: ref.theme.primaryText,
                  ),
                ),
              ],
            ),
          ),
    
          CustomElevatedButton(
            pixelHeight: 48,
            pixelWidth: 48,
            borderRadius: 16,
            backgroundColor: ref.theme.altBackgroundPrimary,
            child: Icon(Icons.download_rounded, color: ref.theme.secondaryText),
          ),
        ],
      ),
    );
  }
}
