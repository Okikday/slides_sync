import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/features/course_mgmt/presentation/views/course_collections/create_collection_bottom_sheet.dart';
import 'package:slides_sync/shared/styles/app_ui_context.dart';

class AddCollectionActionButton extends StatelessWidget {
  final int courseDbId;
  const AddCollectionActionButton({super.key, required this.courseDbId});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: context.isDarkMode ? Color.fromARGB(255, 52, 33, 79) : Colors.deepPurple,
      onPressed: () async {
        CustomDialog.show(
          context,
          canPop: true,
          barrierColor: Colors.black.withAlpha(150),
          child: CreateCollectionBottomSheet(courseDbId: courseDbId),
        );
      },
      label: CustomText("Add a collection", fontWeight: FontWeight.w600, color: Colors.white),
      icon: Icon(Iconsax.add_copy, size: 32, color: Colors.white),
    );
  }
}
