import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/core/routes/app_route_navigator.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/domain/models/course_model/course.dart';
import 'package:slides_sync/features/course_navigation/presentation/views/course_details/course_details_collection_section.dart';
import 'package:slides_sync/features/manage_all/manage_collections/presentation/views/modify_collections/collections_list_view/mod_collection_card_tile.dart';
import 'package:slides_sync/features/manage_all/manage_collections/presentation/views/modify_collections/collections_list_view/mod_collection_dialog.dart';
import 'package:slides_sync/features/manage_all/manage_collections/presentation/views/modify_collections/create_collection_bottom_sheet.dart';
import 'package:slides_sync/features/manage_all/manage_collections/presentation/views/modify_collections/empty_collections_view.dart';

class CollectionsListView extends ConsumerWidget {
  const CollectionsListView({
    super.key,
    required this.courseDbId,
    required this.asyncCourseValue,
    required this.searchCollectionTextNotifier,
  });
  final int courseDbId;
  final AsyncValue<Course> asyncCourseValue;
  final ValueNotifier<String> searchCollectionTextNotifier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ValueListenableBuilder(
      valueListenable: searchCollectionTextNotifier,
      builder: (context, value, child) {
        return asyncCourseValue.when(
          data: (data) {
            final searchText = searchCollectionTextNotifier.value;
            final collections =
                (searchText.isEmpty
                        ? data.collections
                        : data.collections.where(
                          (e) => e.collectionTitle.toLowerCase().contains(
                            searchCollectionTextNotifier.value.toLowerCase(),
                          ),
                        ))
                    .toList();
            if (data.collections.isEmpty) {
              return EmptyCollectionsView(
                onClickAddCollection: () async {
                  // AppRouteNavigator.to(context).modifyCollectionsRoute(course);
                  // await Future.delayed(Durations.short1);
                  if (context.mounted) {
                    CustomDialog.show(
                      context,
                      canPop: true,
                      barrierColor: Colors.black.withAlpha(150),
                      child: CreateCollectionBottomSheet(courseDbId: data.id),
                    );
                  }
                },
              );
            }
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
                      UiUtils.showCustomDialog(
                        context,
                        child: ModCollectionDialog(courseDbId: courseDbId, collection: collection),
                      );
                    },
                    onTap: () {
                      AppRouteNavigator.to(context).modifyContentsRoute((
                        collection: collection,
                        courseDbId: courseDbId,
                        courseTitle: (courseCode: "", courseName: "CourseName"),
                      ));
                    },
                  ).animate().fadeIn().slideY(
                    begin: (index / collections.length + 1) * 0.4,
                    end: 0,
                    curve: Curves.fastEaseInToSlowEaseOut,
                    duration: Durations.extralong2,
                  );
                },
              ),
            );
          },
          error:
              (error, st) => SliverToBoxAdapter(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RotatedBox(quarterTurns: 2, child: Icon(Iconsax.info_circle, size: 48)),
                    CustomText("Error loading course!"),
                  ],
                ),
              ),
          loading:
              () => SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverToBoxAdapter(child: LoadingShimmerListView()),
              ),
        );
      }
    );
  }
}
