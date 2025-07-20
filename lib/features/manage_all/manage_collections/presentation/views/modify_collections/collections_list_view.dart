import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/core/utils/app_navigator.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/data/models/course_model/course.dart';
import 'package:slides_sync/features/manage_all/manage_collections/presentation/views/modify_collections/collections_list_view/mod_collection_card_tile.dart';
import 'package:slides_sync/features/manage_all/manage_collections/presentation/views/modify_collections/collections_list_view/mod_collection_dialog.dart';

class CollectionsListView extends ConsumerWidget {
  const CollectionsListView({super.key, required this.courseDbId, required this.collections});
  final int courseDbId;
  final List<CourseCollection> collections;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 12),
      sliver: SliverList.builder(
        itemCount: collections.length,
        itemBuilder: (context, index) {
          final CourseCollection collection = collections[index];
          return ModCollectionCardTile(
            title: collection.collectionTitle,
            contentCount: collection.contents.length,
            onSelected: () {
              UiUtils.showCustomDialog(context, child: ModCollectionDialog(courseDbId: courseDbId, collection: collection));
            },
            onTap: () {
              AppNavigator.to(context).modifyContentsRoute((
                collection: collection,
                courseDbId: courseDbId,
                courseTitle: (courseCode: "", courseName: "CourseName"),
              ));
            },
          ).animate().slideY(
            begin: double.parse((0.2 * (index + (collections.length / 2) / collections.length)).toStringAsFixed(2)),
            end: 0,
            curve: CustomCurves.bouncySpring,
            duration: Durations.extralong4,
          );
        },
      ),
    );
  }
}
