// ignore: unused_import
import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/domain/models/file_details.dart';
import 'package:slides_sync/shared/common_widgets/modifying_list_tile.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:slides_sync/shared/styles/colors.dart';
import 'package:slides_sync/shared/widgets/build_image_path_widget.dart';

class ModCollectionCardTile extends ConsumerWidget {
  final String title;
  final int subCollectionCount;
  final int contentCount;

  /// This entails on click the icon or on long press
  final void Function()? onSelected;
  final void Function()? onTap;
  const ModCollectionCardTile({
    super.key,
    required this.title,
    this.subCollectionCount = 0,
    this.contentCount = 0,
    this.onSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.hPadding7),
      child: ModifyingListTile(
        leading: BuildImagePathWidget(
          fileDetails: FileDetails(),
          fallbackWidget: Icon(
            Iconsax.document,
            size: 22,
            color: ref.theme.primaryColor,
          ),
        ),
        trailing: CustomElevatedButton(backgroundColor:Colors.transparent, contentPadding: EdgeInsets.all(12), onClick: onSelected, child: Icon(Iconsax.edit_copy, size: 20)),
        title: title,
        subtitle:
            "${subCollectionCount < 1 ? '' : "$subCollectionCount collections"}"
            "${(contentCount > 0 && subCollectionCount > 0) ? ", " : ''}"
            "${contentCount == 0 ? 'No items' : "$contentCount items"}",
      
        onTapTile: () {
          if (onTap != null) onTap!();
        },
        onLongPressTile: onSelected,
      ),
    );
  }
}
