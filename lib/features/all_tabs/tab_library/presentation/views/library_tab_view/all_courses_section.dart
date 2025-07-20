import 'dart:developer';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/core/utils/app_navigator.dart';
import 'package:slides_sync/data/models/course_model/course.dart';
import 'package:slides_sync/data/repos/course_repo.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/views/library_tab_view/expand_card_dialog.dart';
import 'package:slides_sync/features/course_navigation/presentation/providers/course_provider.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/providers/is_list_view_notifier.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/views/library_tab_view/all_courses_section/courses_grid_view.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/views/library_tab_view/all_courses_section/courses_list_view.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/views/library_tab_view/all_courses_section/empty_library_view.dart';
import 'package:slides_sync/shared/widgets/loading_view.dart';

class AllCoursesSection extends ConsumerStatefulWidget {
  final AsyncNotifierProvider<IsListViewNotifier, bool> isListViewAsyncProvider;

  const AllCoursesSection({super.key, required this.isListViewAsyncProvider});

  @override
  ConsumerState createState() => _AllCoursesSectionState();
}

class _AllCoursesSectionState extends ConsumerState<AllCoursesSection> with AutomaticKeepAliveClientMixin {
  late final StateProviderFamily<bool, int> scaleClickProviderFamily;
  late final StateProvider<bool> isCourseClickedProvider;
  late final StreamProvider<List<Course>> watchAllcoursesProvider;
  late final StateProvider<TapDownDetails?> longPressDetailsProvider;

  @override
  void initState() {
    super.initState();
    scaleClickProviderFamily = StateProviderFamily((ref, index) => false);
    isCourseClickedProvider = StateProvider((ref) => false);
    watchAllcoursesProvider = StreamProvider((ref) => CourseRepo.watchAllCourses());
    longPressDetailsProvider = StateProvider<TapDownDetails?>((ref) => null);
  }

  void onTap(Course course) async {
    final isCourseClickedNotifier = ref.read(isCourseClickedProvider.notifier);
    if (isCourseClickedNotifier.state) return;
    isCourseClickedNotifier.update((cb) => true); // Tell that a course is currently opened

    await Future.delayed(Durations.short4);
    ref.read(CourseProviders.courseProvider.notifier).update(course);
    if (mounted) AppNavigator.to(context).courseDetailsRoute(course);
    if (mounted) isCourseClickedNotifier.update((cb) => false);
  }

  void onLongPress(Course course) {
    final Offset? tapPosition = ref.read(longPressDetailsProvider.notifier).state?.globalPosition;
    if (tapPosition == null) return;
    CustomDialog.show(
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

        if (isListView) {
          return CoursesListView(
            scaleClickProviderFamily: scaleClickProviderFamily,
            longPressTapDetailsProvider: longPressDetailsProvider,
            data: data,
            onTap: (index) => onTap(data[index]),
            onLongPress: (index) => onLongPress(data[index]),
          );
        } else {
          return CoursesGridView(
            scaleClickProviderFamily: scaleClickProviderFamily,
            longPressTapDetailsProvider: longPressDetailsProvider,
            data: data,
            onTap: (index) => onTap(data[index]),
            onLongPress: (index) => onLongPress(data[index]),
          );
        }
      },
      error: (error, st) {
        log("error: $st");
        return SliverToBoxAdapter(child: RotatedBox(quarterTurns: 2, child: Icon(Iconsax.info_circle)));
      },
      loading: () {
        return SliverToBoxAdapter(child: LoadingView(msg: "Loading Courses"));
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
