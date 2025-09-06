import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/features/manage_all/manage_collections/presentation/views/modify_collections/create_collection_bottom_sheet.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

class AddCollectionActionButton extends ConsumerWidget {
  final int courseDbId;
  final void Function() onClickUp;
  final bool isScrolled;
  const AddCollectionActionButton({super.key, required this.courseDbId, required this.isScrolled, required this.onClickUp});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.theme;
    return FloatingActionButton.extended(
      shape: isScrolled ? CircleBorder() : null,
      backgroundColor: context.isDarkMode ? Colors.white : Colors.black,
      onPressed: () async {
        if (isScrolled) {
          onClickUp();
          return;
        }
        CustomDialog.show(
          context,
          canPop: true,
          barrierColor: Colors.black.withAlpha(150),
          child: CreateCollectionBottomSheet(courseDbId: courseDbId),
        );
      },
      extendedIconLabelSpacing: isScrolled ? 0 : null,
      label:
          isScrolled
              ? const SizedBox()
              : CustomText(
                "Add a collection",
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
      icon: Icon(
        isScrolled ? Iconsax.arrow_up : Iconsax.add_circle,
        size: 32,
        color: theme.primaryColor,
      ),
    );
  }
}
