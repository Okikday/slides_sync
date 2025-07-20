import 'package:flutter/material.dart';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/data/models/course_model/course.dart';
import 'package:slides_sync/features/manage_all/manage_contents/presentation/views/add_contents/add_contents_bottom_sheet.dart';

class AddContentsFAB extends ConsumerWidget {
  final CourseCollection collection;
  const AddContentsFAB({super.key, required this.collection});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      onPressed: () async {
        CustomDialog.show(
          context,
          transitionDuration: Durations.short1,
          reverseTransitionDuration: Durations.short1,
          barrierColor: Colors.black45,
          child: AddContentsBottomSheet(collection: collection),
        );
      },
      shape: CircleBorder(),
      child: Icon(Icons.add, color: Colors.white),
    );
  }
}
