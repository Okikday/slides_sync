import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/core/models/app_ui_model.dart';
import 'package:slides_sync/shared/styles/app_ui_context.dart';

class ContentsSectionHeader extends ConsumerWidget {
  const ContentsSectionHeader({
    super.key,
    required this.scaffoldBgColor,
    
    required this.onTapHeader,
  });

  final Color scaffoldBgColor;
  
  final void Function() onTapHeader;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PinnedHeaderSliver(
      child: GestureDetector(
        onTap: onTapHeader,
        child: ColoredBox(
          color: context.scaffoldBackgroundColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                Expanded(child: CustomText("Contents", fontSize: 18, fontWeight: FontWeight.bold,)),


                CustomElevatedButton(
                  backgroundColor: Colors.transparent,
                  shape: CircleBorder(),
                  child: Icon(Iconsax.add_circle_copy),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}