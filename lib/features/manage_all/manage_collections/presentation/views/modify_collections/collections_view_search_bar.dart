import 'dart:ui';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:slides_sync/shared/styles/colors.dart';

class CollectionsViewSearchBar extends ConsumerWidget {
  const CollectionsViewSearchBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ClipRRect(
      child: ColoredBox(
        color: context.scaffoldBackgroundColor.withValues(alpha: 0.6),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 24.0, top: 12.0),
            child: Row(
              spacing: 12.0,
              children: [
                Expanded(
                  child: ClipRSuperellipse(
                    borderRadius: BorderRadius.circular(10.0),
                    child: CustomTextfield(
                      hint: "Search collections",
                      hintStyle: TextStyle(color: AppColors.secondaryText(context)),
                      selectionHandleColor: ref.theme.primaryColor,
                      inputTextStyle: TextStyle(fontSize: 15, color: AppColors.primaryText(context)),
                      backgroundColor: ref.theme.stepUpBackground,
                      border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.zero),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 12.0, right: 10.0, top: 12.0, bottom: 12.0),
                        child: Icon(Iconsax.search_normal_copy, size: 20, color: AppColors.secondaryText(context)),
                      ),
                    ),
                  ),
                ),
    
                CustomElevatedButton(
                  pixelHeight: 48,
                  shape: CircleBorder(),
                  backgroundColor: ref.theme.altBackgroundPrimary,
                  child: Icon(Iconsax.filter_copy, size: 20, color: AppColors.secondaryText(context)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
