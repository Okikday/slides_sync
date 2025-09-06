import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:slides_sync/core/utils/app_navigator.dart';
import 'package:slides_sync/domain/models/course_model/course.dart';
import 'package:slides_sync/features/course_navigation/presentation/views/course_details/course_categories_card.dart';
import 'package:slides_sync/features/course_navigation/presentation/views/course_materials_view.dart';
import 'package:slides_sync/features/manage_all/manage_collections/presentation/views/modify_collections/create_collection_bottom_sheet.dart';
import 'package:slides_sync/features/manage_all/manage_collections/presentation/views/modify_collections/empty_collections_view.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

class CourseDetailsCollectionSection extends ConsumerWidget {
  const CourseDetailsCollectionSection({super.key, required this.courseAsyncValue});

  final AsyncValue<Course> courseAsyncValue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return courseAsyncValue.when(
      data: (data) {
        final course = data;
        final collections = course.collections;
        if (collections.isEmpty) {
          return EmptyCollectionsView(
            onClickAddCollection: () async {
              // AppNavigator.to(context).modifyCollectionsRoute(course);
              // await Future.delayed(Durations.short1);
              if (context.mounted) {
                CustomDialog.show(
                  context,
                  canPop: true,
                  barrierColor: Colors.black.withAlpha(150),
                  child: CreateCollectionBottomSheet(courseDbId: course.id),
                );
              }
            },
          );
        }

        return SliverList.builder(
          itemCount: collections.length,
          itemBuilder: (context, index) {
            final list = collections.toList();
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0, left: 16.0, right: 16.0),
              child: CourseCategoriesCard(
                isDarkMode: context.isDarkMode,
                title: list[index].collectionTitle,
                contentCount: list[index].contents.length,

                onTap: () {
                  // Navigator.of(context).push(
                  //     PageTransition(
                  //       type: PageTransitionType.rightToLeftWithFade,
                  //       duration: Durations.extralong3,
                  //       reverseDuration: Durations.medium1,
                  //       curve: CustomCurves.snappySpring,
                  //       child: InteractiveCourseMaterialView(collection: list[index]),
                  //     ),
                  //   );

                  AppNavigator.to(context).courseMaterialsRoute(list[index]);
                },
              ).animate().fadeIn().slideY(
                begin: (index / collections.length + 1) * 0.4,
                end: 0,
                curve: Curves.fastEaseInToSlowEaseOut,
                duration: Durations.extralong2,
              ),
            );
          },
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
}

class LoadingShimmerListView extends ConsumerWidget {
  const LoadingShimmerListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemCount: 4,
      shrinkWrap: true,
      itemBuilder:
          (context, index) => Skeletonizer(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: CourseCategoriesCard(isDarkMode: ref.isDarkMode, title: "_", onTap: () {}),
            ),
          ),
    );
  }
}
