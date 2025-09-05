import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:isar/isar.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:slides_sync/domain/models/course_model/course.dart';
import 'package:slides_sync/domain/repos/course_repo/course_repo.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/views/library_tab_view/all_courses_section/course_card/list_course_card.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/views/library_tab_view/all_courses_section/empty_library_view.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/views/library_tab_view/all_courses_section/union_course_card.dart';

import 'package:slides_sync/features/course_navigation/presentation/providers/course_provider.dart';
import 'package:slides_sync/shared/widgets/loading_view.dart';
import 'course_card/grid_course_card.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

class CoursesView extends ConsumerStatefulWidget {
  const CoursesView(
    this.isListView, {
    super.key,
    required this.scaleClickProviderFamily,
    required this.longPressTapDetailsProvider,
    required this.onTap,
    required this.onLongPress,
  });

  final bool isListView;
  final AutoDisposeStateProviderFamily<bool, int> scaleClickProviderFamily;
  final StateProvider<Offset?> longPressTapDetailsProvider;
  final void Function(Course course) onTap;
  final void Function(Course course) onLongPress;

  @override
  ConsumerState<CoursesView> createState() => _CoursesViewState();
}

class _CoursesViewState extends ConsumerState<CoursesView> {
  late final PagingState<int, Course> pagingState;
  late final PagingController<int, Course> pagingController;
  final int limit = 10;

  @override
  void initState() {
    super.initState();
    pagingState = PagingState();
    pagingController = PagingController(value: pagingState, getNextPageKey: getNextPageKey, fetchPage: fetchPage);
  }

  Future<List<Course>> fetchPage(int pageKey) async {
    final list = await (await CourseRepo.filter).idGreaterThan((pageKey - 1) * limit).limit(limit).findAll();
    // log("pageKey: $pageKey");
    // log("Got: ${list}");
    return list;
  }

  int? getNextPageKey(PagingState<int, Course> state) {
    // log("${state.nextIntPageKey}");
    return state.lastPageIsEmpty ? null : state.nextIntPageKey;
  }

  @override
  void dispose() {
    pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final double dimension = (context.deviceWidth > context.deviceHeight ? context.deviceWidth * 0.12 : context.deviceWidth * 0.12);
    final isGrid = !widget.isListView;

    return PagingListener(
      controller: pagingController,
      builder: (context, state, fetchNextPage) {
        if (!isGrid) {
          return PagedSliverList(
            state: state,
            fetchNextPage: fetchNextPage,
            builderDelegate: PagedChildBuilderDelegate(
              noItemsFoundIndicatorBuilder: (context) => EmptyLibraryView(asSliver: false),
              newPageProgressIndicatorBuilder: (context) => Center(child: LoadingView(msg: "")),
              firstPageProgressIndicatorBuilder: (context) {
                return SizedBox(
                  height: 400,
                  child: ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      for (int i = 0; i < 4; i++)
                        Skeletonizer(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: ListCourseCard(defaultCourse, onTapIcon: () {}),
                          ),
                        ),
                    ],
                  ),
                );
              },
              firstPageErrorIndicatorBuilder: (context) {
                // log(pagingState.error.toString());
                return RotatedBox(quarterTurns: 2, child: Icon(Iconsax.info_circle));
              },
              itemBuilder: (context, item, index) {
                final course = item as Course;
                return UnionCourseCard(
                  course,
                  isGrid,
                  scaleClickProvider: widget.scaleClickProviderFamily(index),
                  longPressTapDetailsProvider: widget.longPressTapDetailsProvider,
                  onTap: () => widget.onTap(course),
                  onLongPress: () => widget.onLongPress(course),
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
                      for (int i = 0; i < 4; i++) Skeletonizer(child: GridCourseCard(defaultCourse, onTapIcon: () {})),
                    ],
                  ),
                );
              },
              firstPageErrorIndicatorBuilder: (context) {
                // log(pagingState.error.toString());
                return RotatedBox(quarterTurns: 2, child: Icon(Iconsax.info_circle));
              },
              itemBuilder: (context, item, index) {
                final course = item as Course;
                return UnionCourseCard(
                  course,
                  isGrid,
                  scaleClickProvider: widget.scaleClickProviderFamily(index),
                  longPressTapDetailsProvider: widget.longPressTapDetailsProvider,
                  onTap: () => widget.onTap(course),
                  onLongPress: () => widget.onLongPress(course),
                );
              },
            ),
          );
        }
      },
    );

    // if (widget.isListView) {

    //   // return SliverList.builder(
    //   //   itemCount: data.length,
    //   //   itemBuilder: (context, index) {
    //   //     return UnionCourseCard(
    //   //       data[index],
    //   //       false,
    //   //       scaleClickProvider: scaleClickProviderFamily(index),
    //   //       longPressTapDetailsProvider: longPressTapDetailsProvider,
    //   //       onTap: () => onTap(index),
    //   //       onLongPress: () => onLongPress(index),
    //   //     );
    //   //   }
    //   // );
    // } else {
    //   return SliverGrid.builder(
    //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //       crossAxisCount: context.deviceHeight > context.deviceWidth ? 2 : 3,

    //       crossAxisSpacing: 12,
    //     ),
    //     itemCount: widget.data.length,
    //     itemBuilder: (context, index) {
    //       return UnionCourseCard(
    //         widget.data[index],
    //         true,
    //         scaleClickProvider: widget.scaleClickProviderFamily(index),
    //         longPressTapDetailsProvider: widget.longPressTapDetailsProvider,
    //         onTap: () => widget.onTap(index),
    //         onLongPress: () => widget.onLongPress(index),
    //       );
    //     },
    //   );
    // }
  }
}
