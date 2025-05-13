import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/app/models/app_ui_model.dart';

/// COLLECTION SECTION HEADER
class CollectionsSectionHeader extends ConsumerWidget {
  const CollectionsSectionHeader({
    super.key,
    required this.scaffoldBgColor,
    required this.appUiModel,
    this.onClickAddIcon
  });

  final Color scaffoldBgColor;
  final AppUiModel appUiModel;

  final void Function()? onClickAddIcon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverToBoxAdapter(
      child: ColoredBox(
        color: scaffoldBgColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
          child: Row(
            children: [
              Expanded(child: CustomText("Collections", fontSize: 18, fontWeight: FontWeight.bold)),

             if(onClickAddIcon != null) CustomElevatedButton(
                contentPadding: EdgeInsets.all(12),
                backgroundColor: Colors.lightBlueAccent.withAlpha(40),
                shape: CircleBorder(),
                child: Icon(Iconsax.add_circle_copy, size: 20, color: appUiModel.isDarkMode ? Colors.white : Colors.black),
              ),
              ConstantSizing.rowSpacingMedium,

              // CustomElevatedButton(
              //   contentPadding: EdgeInsets.all(12),
              //   backgroundColor: Colors.lightBlueAccent.withAlpha(40),
              //   shape: CircleBorder(),
              //   onClick: onTapGridToggle,
              //   child: Icon(
              //     isPlainView ? Iconsax.menu : Icons.list_outlined,
              //     size: 20,
              //     color: appUiModel.isDarkMode ? Colors.white : Colors.black,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}