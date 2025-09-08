import 'dart:developer';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:slides_sync/domain/models/course_model/course.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/views/library_tab_view/courses_view.dart';
import 'package:slides_sync/features/course_navigation/presentation/actions/materials_view_actions.dart';
import 'package:slides_sync/features/course_navigation/presentation/providers/course_materials_providers.dart';
import 'package:slides_sync/features/course_navigation/presentation/views/course_materials/content_card.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:slides_sync/shared/widgets/loading_view.dart';

class MaterialsView extends ConsumerStatefulWidget {
  final CourseCollection collection;
  const MaterialsView({super.key, required this.collection});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MaterialsViewState();
}

class _MaterialsViewState extends ConsumerState<MaterialsView> {
  late final PagingController<int, CourseContent> pagingController;
  final int limit = 10;

  @override
  void initState() {
    super.initState();
    pagingController = PagingController(
      value: CourseMaterialsProviders.pagingState,
      getNextPageKey: MaterialsViewActions.getNextPageKey,
      fetchPage:
          (pageKey) async => await MaterialsViewActions.fetchPage(pageKey, limit, widget.collection.collectionId),
    );
  }

  @override
  void dispose() {
    pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isListView = ref.watch(CourseMaterialsProviders.isListLayout).value ?? false;

    final isGrid = !isListView;

    ref.listen<AsyncValue<void>>(CourseMaterialsProviders.of(widget.collection.collectionId).watchChanges, (
      previous,
      next,
    ) {
      if (next.hasValue) {
        log("refreshing page controller!");
        pagingController.refresh();
      }
    });

    return SliverPadding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 12),
      sliver: PagingListener(
        controller: pagingController,
        builder: (context, state, fetchNextPage) {
          if (!isGrid) {
            return PagedSliverList(
              state: state,
              fetchNextPage: fetchNextPage,
              builderDelegate: PagedChildBuilderDelegate(
                // noItemsFoundIndicatorBuilder: (context) => EmptyLibraryView(asSliver: false),
                newPageProgressIndicatorBuilder: (context) => LoadingListCourseCardSkeletonizer(count: 2),
                firstPageProgressIndicatorBuilder: (context) {
                  return LoadingListCourseCardSkeletonizer();
                },
                firstPageErrorIndicatorBuilder: (context) {
                  // log(pagingState.error.toString());
                  return RotatedBox(quarterTurns: 2, child: Icon(Iconsax.info_circle));
                },
                itemBuilder: (context, item, index) {
                  final content = item as CourseContent;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: ContentCard(content: content)
                        .animate()
                        .fadeIn(curve: CustomCurves.defaultIosSpring, duration: Durations.extralong1)
                        .slideY(
                          begin: 0.1,
                          end: 0,
                          curve: CustomCurves.defaultIosSpring,
                          duration: Durations.extralong4,
                        ),
                  );
                },
              ),
            );
          } else {
            return PagedSliverGrid(
              state: state,
              fetchNextPage: fetchNextPage,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: context.deviceWidth ~/ 160,
                crossAxisSpacing: 12,
              ),

              builderDelegate: PagedChildBuilderDelegate(
                // noItemsFoundIndicatorBuilder: (context) => EmptyLibraryView(asSliver: false),
                newPageProgressIndicatorBuilder: (context) => Center(child: LoadingView(msg: "")),
                firstPageProgressIndicatorBuilder: (context) {
                  return LoadingGridCourseCardSkeletonizer(count: 2);
                },
                firstPageErrorIndicatorBuilder: (context) {
                  // log(pagingState.error.toString());
                  return RotatedBox(quarterTurns: 2, child: Icon(Iconsax.info_circle));
                },
                itemBuilder: (context, item, index) {
                  final content = item as CourseContent;
                  return ContentCard(content: content)
                      .animate()
                      .fadeIn(curve: CustomCurves.defaultIosSpring, duration: Durations.extralong1)
                      .slideY(begin: 0.1, end: 0, curve: CustomCurves.defaultIosSpring, duration: Durations.extralong4);
                },
              ),
            );
          }
        },
      ),
    );
  }
}



    // return ListView.builder(
    //   padding: EdgeInsets.only(top: 8),
    //   physics: BouncingScrollPhysics(),
    //   itemCount: courseContents.length,
    //   itemBuilder: (context, index) {
    //     return CourseMaterialListCard(
    //       courseContent: courseContents[index],
    //       courseMaterialListCardActionModels: simList,
    //       isCourseMaterialListCardExpandedProvider: isCourseMaterialCardExpandedFamily(index),
    //       onTapCard: () {
    //         for (int i = 0; i < 10; i++) {
    //           final isExpandedNotifier = ref.read(isCourseMaterialCardExpandedFamily(i).notifier);
    //           if (i == index) {
    //             isExpandedNotifier.update((cb) => !isExpandedNotifier.state);
    //           } else {
    //             if (isExpandedNotifier.state) {
    //               isExpandedNotifier.update((cb) => false);
    //             }
    //           }
    //           // log("$i. ${isExpandedNotifier.state}");
    //         }
    //       },
    //       onLongPressed: () {},
    //     );
    //   },
    // );