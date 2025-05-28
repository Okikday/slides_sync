import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/core/usecases/app_navigator.dart';
import 'package:slides_sync/features/course_mgmt/data/models/course_model/course_model.dart';
import 'package:slides_sync/features/course_mgmt/data/repos/course_repo.dart';
import 'package:slides_sync/features/main/presentation/views/library_tab_view/all_courses_section/courses_grid_view.dart';
import 'package:slides_sync/features/main/presentation/views/library_tab_view/all_courses_section/courses_list_view.dart';
import 'package:slides_sync/features/main/presentation/views/library_tab_view/all_courses_section/empty_library_view.dart';
import 'package:slides_sync/shared/components/loading_view.dart';

class AllCoursesSection extends ConsumerStatefulWidget {
  final bool isListView;

  const AllCoursesSection({super.key, required this.isListView});

  @override
  ConsumerState createState() => _AllCoursesSectionState();
}

class _AllCoursesSectionState extends ConsumerState<AllCoursesSection> {
  late final StateProviderFamily<bool, int> scaleClickProviderFamily;
  late final StateProvider<bool> isCourseClickedProvider;
  late final StreamProvider<List<CourseModel>> watchAllcoursesProvider;

  @override
  void initState() {
    super.initState();
    scaleClickProviderFamily = StateProviderFamily((ref, index) => false);
    isCourseClickedProvider = StateProvider((ref) => false);
    watchAllcoursesProvider = StreamProvider((ref) => CourseRepo.watchAllCourses());
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<CourseModel>> streamedCourses = ref.watch(watchAllcoursesProvider);
    log("Streamed course");
    void onTap(CourseModel course) async {
      final isCourseClickedNotifier = ref.read(isCourseClickedProvider.notifier);
      if (isCourseClickedNotifier.state) return;
      isCourseClickedNotifier.update((cb) => true); // Tell that a course is currently opened

      await Future.delayed(Durations.short4);
      if (context.mounted) {
        AppNavigator.to(context).courseDetailsRoute(course);
      }
      if (context.mounted) isCourseClickedNotifier.update((cb) => false);
    }


    

    return streamedCourses.when(
      data: (data) {
        if (data.isEmpty) {
          return EmptyLibraryView();
        }

        if (widget.isListView) {
          return CoursesListView(scaleClickProviderFamily: scaleClickProviderFamily, data: data, onTap: (index) => onTap(data[index]));
        } else {
          return CoursesGridView(scaleClickProviderFamily: scaleClickProviderFamily, data: data, onTap: (index) => onTap(data[index]));
        }
      },
      error: (_, __) {
        return SliverToBoxAdapter(child: RotatedBox(quarterTurns: 2, child: Icon(Iconsax.info_circle)));
      },
      loading: () {
        return SliverToBoxAdapter(child: LoadingView(msg: "Loading Courses"));
      },
    );
  }
}
