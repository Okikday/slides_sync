import 'dart:developer';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:slides_sync/core/utils/app_navigator.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/domain/models/course_model/course.dart';
import 'package:slides_sync/domain/repos/course_repo/course_repo.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/views/library_tab_view/all_courses_section/course_card/grid_course_card.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/views/library_tab_view/all_courses_section/course_card/list_course_card.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/views/library_tab_view/expand_card_dialog.dart';
import 'package:slides_sync/features/course_navigation/presentation/providers/course_provider.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/providers/is_list_view_notifier.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/views/library_tab_view/all_courses_section/courses_view.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/views/library_tab_view/all_courses_section/empty_library_view.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:slides_sync/shared/widgets/loading_view.dart';

class AllCoursesSection extends ConsumerStatefulWidget {
  final AsyncNotifierProvider<IsListViewNotifier, bool> isListViewAsyncProvider;

  const AllCoursesSection({super.key, required this.isListViewAsyncProvider});

  @override
  ConsumerState createState() => _AllCoursesSectionState();
}

class _AllCoursesSectionState extends ConsumerState<AllCoursesSection> with AutomaticKeepAliveClientMixin {
  late final AutoDisposeStateProviderFamily<bool, int> scaleClickProviderFamily;
  late final StateProvider<bool> isCourseClickedProvider;
  late final StreamProvider<List<Course>> watchAllcoursesProvider;
  late final StateProvider<Offset?> longPressDetailsProvider;

  @override
  void initState() {
    super.initState();
    scaleClickProviderFamily = AutoDisposeStateProviderFamily((ref, index) => false);
    isCourseClickedProvider = StateProvider((ref) => false);
    watchAllcoursesProvider = StreamProvider((ref) => CourseRepo.watchAllCourses());
    longPressDetailsProvider = StateProvider<Offset?>((ref) => null);
  }

  void onTap(Course course) async {
    final isCourseClickedNotifier = ref.read(isCourseClickedProvider.notifier);
    if (isCourseClickedNotifier.state) return;
    isCourseClickedNotifier.update((cb) => true); // Tell that a course is currently opened

    await Future.delayed(Durations.short4);
    ref.read(CourseProviders.courseProvider.notifier).updateCourse(course);
    if (mounted) AppNavigator.to(context).courseDetailsRoute(course);
    if (mounted) isCourseClickedNotifier.update((cb) => false);
  }

  void onLongPress(Course course) {
    final Offset? tapPosition = ref.read(longPressDetailsProvider.notifier).state;
    if (tapPosition == null) return;
    UiUtils.showCustomDialog(
      context,
      blurSigma: Offset(2, 2),
      barrierColor: Colors.black26,
      child: ExpandCardDialog(
        tapPosition: tapPosition,
        course: course,
        onOpen: () {
          CustomDialog.hide(context);
          onTap(course);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final AsyncValue<List<Course>> streamedCourses = ref.watch(watchAllcoursesProvider);
    final AsyncValue<bool> asyncIsListView = ref.watch(widget.isListViewAsyncProvider);
    final isListView = asyncIsListView.value ?? false;

    return streamedCourses.when(
      data: (List<Course> data) {
        if (data.isEmpty) {
          return EmptyLibraryView();
        }

        return SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          sliver: CoursesView(
            isListView,
            scaleClickProviderFamily: scaleClickProviderFamily,
            longPressTapDetailsProvider: longPressDetailsProvider,
            data: data,
            onTap: (index) => onTap(data[index]),
            onLongPress: (index) => onLongPress(data[index]),
          ),
        );
      },
      error: (error, st) {
        log("error: $st");
        return SliverToBoxAdapter(child: RotatedBox(quarterTurns: 2, child: Icon(Iconsax.info_circle)));
      },
      loading: () {
        return SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          sliver:
              isListView
                  ? SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => Skeletonizer(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: ListCourseCard(defaultCourse, onTapIcon: () {}),
                        ),
                      ),
                      childCount: 5,
                    ),
                  )
                  : SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: context.deviceHeight > context.deviceWidth ? 2 : 3,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => Skeletonizer(child: GridCourseCard(defaultCourse, onTapIcon: () {})),
                      childCount: 5,
                    ),
                  ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
