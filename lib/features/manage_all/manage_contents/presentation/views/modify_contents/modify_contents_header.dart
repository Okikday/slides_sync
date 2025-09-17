import 'dart:ui';
import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/features/manage_all/manage_contents/presentation/providers/modify_contents_view_providers.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

class ModifyContentsHeader extends ConsumerWidget {
  final void Function() onDelete;
  final ModifyContentsViewProviders mcvp;
  final int? collectionLength;
  const ModifyContentsHeader({super.key, required this.onDelete, required this.mcvp, this.collectionLength});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hPadding = context.hPadding;
    // final padding4 = hPadding * .4;
    // final padding2 = hPadding * .2;
    final padding7 = hPadding * .7;
    // final padding6 = hPadding * .6;

    final btnDimension = context.defaultBtnDimension * .8;
    // final theme = ref.theme;
    return ValueListenableBuilder(
      valueListenable: mcvp.selectedContentsNotifier,
      builder: (context, value, child) {
        if (value.isEmpty) return SliverToBoxAdapter();
        return PinnedHeaderSliver(
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: ColoredBox(
                color: context.scaffoldBackgroundColor.withAlpha(225),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16).copyWith(top: 4),
                  child: Row(
                    spacing: 12.0,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomElevatedButton(
                        pixelHeight: btnDimension,
                        backgroundColor: Colors.red.withAlpha(100),
                        contentPadding: EdgeInsets.symmetric(horizontal: padding7),
                        borderRadius: ConstantSizing.borderRadiusCircle,
                        onClick: onDelete,
                        child: Row(
                          spacing: 8,
                          children: [
                                Icon(Iconsax.trash, color: Colors.red), CustomText("Delete", color: Colors.red)],
                        ),
                      ),
        
                      CustomText("${value.length} selected"),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}
