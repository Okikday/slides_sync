import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/data/models/course_model/sub/course_collection.dart';
import 'package:slides_sync/features/manage_all/manage_contents/presentation/views/add_contents/add_contents_bottom_sheet.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

class AddContentFAB extends StatelessWidget {
  final CourseCollection collection;
  const AddContentFAB({super.key, required this.collection});
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: context.theme.colorScheme.onSurface,
      shape: CircleBorder(),
      onPressed: () {
        CustomDialog.show(
          context,
          transitionType: TransitionType.cupertinoDialog,
          transitionDuration: Durations.medium1,
          reverseTransitionDuration: Durations.short1,
          barrierColor: Colors.black45,
          blurSigma: Offset(2, 2),
          child: AddContentsBottomSheet(collection: collection),
        );
      },
      child: Icon(Iconsax.add_copy),
    );
  }
}
