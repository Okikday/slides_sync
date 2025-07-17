import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

/// COLLECTION SECTION HEADER
class CollectionsSectionHeader extends ConsumerWidget {
  const CollectionsSectionHeader({
    super.key,
    required this.scaffoldBgColor,
    
    this.onClickAddIcon
  });

  final Color scaffoldBgColor;
  

  final void Function()? onClickAddIcon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverToBoxAdapter(
      child: ColoredBox(
        color: context.scaffoldBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
          child: Row(
            children: [
              Expanded(child: CustomText("Collections", fontSize: 18, fontWeight: FontWeight.bold, color: context.theme.colorScheme.tertiary)),

             if(onClickAddIcon != null) CustomElevatedButton(
                contentPadding: EdgeInsets.all(12),
                backgroundColor: context.theme.colorScheme.secondary.withAlpha(40),
                shape: CircleBorder(),
                child: Icon(Iconsax.add_circle_copy, size: 20, color: context.isDarkMode ? Colors.white : Colors.black),
              ),
              ConstantSizing.rowSpacingMedium,

              // CustomElevatedButton(
              //   contentPadding: EdgeInsets.all(12),
              //   backgroundColor: context.theme.colorScheme.secondary.withAlpha(40),
              //   shape: CircleBorder(),
              //   onClick: onTapGridToggle,
              //   child: Icon(
              //     isPlainView ? Iconsax.menu : Icons.list_outlined,
              //     size: 20,
              //     color: context.isDarkMode ? Colors.white : Colors.black,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}