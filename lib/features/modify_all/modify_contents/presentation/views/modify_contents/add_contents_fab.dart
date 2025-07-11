import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/data/models/course_model/course_model.dart';
import 'package:slides_sync/features/create_all/create_content/presentation/views/add_contents_bottom_sheet.dart';
import 'package:slides_sync/shared/components/dialogs/app_action_dialog.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

class AddContentsFAB extends ConsumerWidget {
  final CourseSubCollection collection;
  const AddContentsFAB({super.key, required this.collection});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      onPressed: () {
        // CustomDialog.show(
        //   context,
        //   transitionDuration: Durations.short1,
        //   reverseTransitionDuration: Durations.short1,
        //   barrierColor: Colors.black38,
        //   child: AddContentsBottomSheet(collection: collection),
        // );

        CustomDialog.show(context, child: Container(width: 100, height: 100, color: Colors.amber));
      },
      shape: CircleBorder(),
      child: Icon(Icons.add, color: Colors.white),
    );
  }
}
