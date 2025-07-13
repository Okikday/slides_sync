import 'dart:ui';
import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

class ModifyContentsHeader extends StatelessWidget {
  final void Function() onSelect;
  final void Function() onClickFilter;
  final void Function() onSearch;
  const ModifyContentsHeader({super.key, required this.onSelect, required this.onClickFilter, required this.onSearch});

  @override
  Widget build(BuildContext context) {
    final hPadding = context.hPadding;
    final padding4 = hPadding * .4;
    final padding2 = hPadding * .2;
    final padding7 = hPadding * .7;
    final padding6 = hPadding * .6;

    final btnDimension = context.defaultBtnDimension * .8;
    return PinnedHeaderSliver(
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
          child: ColoredBox(
            color: context.scaffoldBackgroundColor.withAlpha(225),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: padding7),
              child: Column(
                children: [
                  ConstantSizing.columnSpacing(padding4),
                  Row(
                    spacing: 12.0,
                    children: [
                      CustomElevatedButton(
                        pixelHeight: btnDimension,
                        backgroundColor: context.theme.colorScheme.onSurface,
                        contentPadding: EdgeInsets.symmetric(horizontal: padding7),
                        borderRadius: ConstantSizing.borderRadiusCircle,
                        onClick: onSelect,
                        child: CustomText("Select", color: context.theme.colorScheme.onTertiary),
                      ),
                      CustomElevatedButton(
                        pixelHeight: btnDimension,
                        backgroundColor: context.theme.colorScheme.onSurface,
                        contentPadding: EdgeInsets.symmetric(horizontal: padding6),
                        borderRadius: ConstantSizing.borderRadiusCircle,
                        onClick: onClickFilter,
                        child: Row(
                          spacing: padding2,
                          children: [
                            Icon(Icons.keyboard_arrow_down, size: 22, color: context.theme.colorScheme.onTertiary),
                            CustomText("Filter", color: context.theme.colorScheme.onTertiary),
                          ],
                        ),
                      ),

                      CustomElevatedButton(
                        pixelHeight: btnDimension,
                        pixelWidth: btnDimension,
                        shape: CircleBorder(),
                        backgroundColor: context.theme.colorScheme.onSurface,
                        contentPadding: EdgeInsets.all(padding4),
                        borderRadius: ConstantSizing.borderRadiusCircle,
                        onClick: onSearch,
                        child: Icon(Iconsax.search_normal_copy, color: context.theme.colorScheme.onTertiary),
                      ),
                    ],
                  ),
                  ConstantSizing.columnSpacingSmall,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
