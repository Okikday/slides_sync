import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/domain/models/course_model/sub/course_collection.dart';
import 'package:slides_sync/features/manage_all/manage_contents/presentation/views/add_contents/add_contents_bottom_sheet.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

class AddContentFAB extends ConsumerWidget {
  final CourseCollection collection;
  const AddContentFAB({super.key, required this.collection});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.theme;
    return FloatingActionButton(
      backgroundColor: theme.primaryColor,
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
      child: Icon(Iconsax.add_copy, color: theme.onPrimary),
    );
  }
}
