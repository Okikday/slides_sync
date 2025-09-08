import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:slides_sync/domain/models/course_model/course.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/actions/courses_view_actions.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/providers/courses_view_providers.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/providers/library_tab_view_providers.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/views/library_tab_view/courses_view/course_card/list_course_card.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/views/library_tab_view/courses_view/empty_library_view.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/views/library_tab_view/courses_view/course_card.dart';

import 'package:slides_sync/core/global_providers/course_providers.dart';
import 'package:slides_sync/shared/widgets/loading_view.dart';
import 'courses_view/course_card/grid_course_card.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

class CoursesView extends ConsumerStatefulWidget {
  const CoursesView({super.key});

  @override
  ConsumerState<CoursesView> createState() => _CoursesViewState();
}

class _CoursesViewState extends ConsumerState<CoursesView> {
  late final PagingController<int, Course> pagingController;
  final int limit = 10;

  @override
  void initState() {
    super.initState();
    pagingController = PagingController(
      value: CoursesViewProviders.pagingState,
      getNextPageKey: CoursesViewActions.getNextPageKey,
      fetchPage: (pageKey) async => await CoursesViewActions.fetchPage(pageKey, limit),
    );
  }

  @override
  void dispose() {
    pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isListView = ref.watch(LibraryTabViewProviders.isListLayout).value ?? false;
    final isGrid = !isListView;

    ref.listen<AsyncValue<void>>(CoursesViewProviders.watchChanges, (previous, next) {
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
                noItemsFoundIndicatorBuilder: (context) => EmptyLibraryView(asSliver: false),
                newPageProgressIndicatorBuilder: (context) => LoadingListCourseCardSkeletonizer(count: 2),
                firstPageProgressIndicatorBuilder: (context) {
                  return LoadingListCourseCardSkeletonizer();
                },
                firstPageErrorIndicatorBuilder: (context) {
                  // log(pagingState.error.toString());
                  return RotatedBox(quarterTurns: 2, child: Icon(Iconsax.info_circle));
                },
                itemBuilder: (context, item, index) {
                  final course = item as Course;
                  return CourseCard(
                    course,
                    isGrid,
                    scaleClickProvider: LibraryTabViewProviders.isCourseCardTappedDownFamily(index),
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
                noItemsFoundIndicatorBuilder: (context) => EmptyLibraryView(asSliver: false),
                newPageProgressIndicatorBuilder: (context) => Center(child: LoadingView(msg: "")),
                firstPageProgressIndicatorBuilder: (context) {
                  return LoadingGridCourseCardSkeletonizer(count: 2);
                },
                firstPageErrorIndicatorBuilder: (context) {
                  // log(pagingState.error.toString());
                  return RotatedBox(quarterTurns: 2, child: Icon(Iconsax.info_circle));
                },
                itemBuilder: (context, item, index) {
                  final course = item as Course;
                  return CourseCard(
                    course,
                    isGrid,
                    scaleClickProvider: LibraryTabViewProviders.isCourseCardTappedDownFamily(index),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}

class LoadingGridCourseCardSkeletonizer extends StatelessWidget {
  final int count;
  const LoadingGridCourseCardSkeletonizer({super.key, this.count = 3});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: GridView(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: context.deviceHeight > context.deviceWidth ? 2 : 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
        ),
        children: [
          for (int i = 0; i < count; i++)
            Skeletonizer(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: GridCourseCard(defaultCourse, onTapIcon: () {}),
              ),
            ),
        ],
      ),
    );
  }
}

class LoadingListCourseCardSkeletonizer extends StatelessWidget {
  final int count;
  const LoadingListCourseCardSkeletonizer({super.key, this.count = 3});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: [
          for (int i = 0; i < count; i++)
            Skeletonizer(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: ListCourseCard(defaultCourse, onTapIcon: () {}),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
