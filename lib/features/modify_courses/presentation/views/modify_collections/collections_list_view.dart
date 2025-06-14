import 'dart:ui';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_transition/page_transition.dart';
import 'package:slides_sync/data/models/course_model/course_model.dart';
import 'package:slides_sync/features/course_navigation/presentation/views/course_materials_view.dart';
import 'package:slides_sync/features/modify_courses/presentation/views/modify_collections/collections_list_view/collection_card_tile.dart';
import 'package:slides_sync/features/modify_courses/presentation/views/modify_collections/collections_list_view/mod_collection_dialog.dart';
import 'package:slides_sync/shared/styles/app_ui_context.dart';

class CollectionsListView extends ConsumerWidget {
  const CollectionsListView({super.key, required this.courseDbId, required this.collections});
  final int courseDbId;
  final List<CourseSubCollection> collections;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 12),
      sliver: SliverList.builder(
        // itemCount: courseModel.subCollections.length,
        itemCount: collections.length,
        itemBuilder: (context, index) {
          final CourseSubCollection collection = collections[index];
          return Padding(
            padding: EdgeInsets.only(bottom: 16.0),
            child: CollectionCardTile(
              title: collection.collectionTitle,
              contentCount: collection.courseContents.length,
              onSelected: () {
                CustomDialog.show(
                  context,
                  blurSigma: Offset(3, 3),
                  barrierColor: Colors.black.withAlpha(150),
                  curve: CustomCurves.defaultIosSpring,
                  child: ModCollectionDialog(courseDbId: courseDbId, collection: collection),
                );
              },
              onTap: () {
                // if (context.mounted) {
                //   Navigator.of(context).push(
                //     PageTransition(
                //       type: PageTransitionType.rightToLeftWithFade,
                //       duration: Durations.extralong3,
                //       reverseDuration: Durations.medium1,
                //       curve: CustomCurves.snappySpring,
                //       child: CourseMaterialsView(),
                //     ),
                //   );
                // }

                
              },
            ),
          ).animate().slideY(
            begin: double.parse((0.5 * (index + (collections.length / 2) / collections.length)).toStringAsFixed(2)),
            end: 0,
            curve: CustomCurves.bouncySpring,
            duration: Durations.extralong4,
          );
        },
      ),
    );
  }
}
