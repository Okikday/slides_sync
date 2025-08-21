
import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

class SelectedItemsCountPopUp extends ConsumerWidget {
  final int? selectedItemsCount;
  const SelectedItemsCountPopUp({super.key,this.selectedItemsCount});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    return Container(
      height: 48,
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      margin: EdgeInsets.symmetric(horizontal: 16.0,),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: ref.theme.primaryColor.withValues(alpha: .4),
        border: Border.fromBorderSide(BorderSide(color: context.theme.colorScheme.secondary.withAlpha(20))),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 4.0,
        children: [
          Icon(Iconsax.check, size: 18, color: context.theme.colorScheme.secondary.withAlpha(80)),
         if(selectedItemsCount != null) CustomText('$selectedItemsCount ${selectedItemsCount! <= 1 ? "item" : "items"} selected!'),
        ],
      ),
    )
    // .animate().slideY(begin: -1, curve: CustomCurves.bouncySpring, duration: Durations.extralong4).fadeIn()
    ;
  }
}
