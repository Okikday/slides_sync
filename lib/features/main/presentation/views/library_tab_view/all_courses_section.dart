import 'dart:developer';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:slides_sync/features/course_mgmt/data/models/course_model/course_model.dart';
import 'package:slides_sync/features/course_mgmt/data/repos/course_repo.dart';
import 'package:slides_sync/features/main/presentation/views/library_tab_view/all_courses_section/courses_grid_view.dart';
import 'package:slides_sync/features/main/presentation/views/library_tab_view/all_courses_section/courses_list_view.dart';
import 'package:slides_sync/shared/components/loading_view.dart';
import 'package:slides_sync/shared/strings/icon_strings.dart';
import 'package:slides_sync/shared/styles/app_ui_context.dart';

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

    return streamedCourses.when(
      data: (data) {
        if (data.isEmpty) {
          return EmptyLibraryView();
        }

        if (widget.isListView) {
          return CoursesListView(
            scaleClickProviderFamily: scaleClickProviderFamily,
            isCourseClickedProvider: isCourseClickedProvider,
            data: data,
          );
        } else {
          return CoursesGridView(
            scaleClickProviderFamily: scaleClickProviderFamily,
            data: data,
            isCourseClickedProvider: isCourseClickedProvider,
          );
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





class EmptyLibraryView extends StatelessWidget {
  const EmptyLibraryView({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: ListView(
        shrinkWrap: true,
        children: [
          SizedBox.square(dimension: context.deviceWidth * 0.5, child: LottieBuilder.asset(IconStrings.instance.roundedPlayingFace)),

          ConstantSizing.columnSpacingExtraLarge,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: CustomElevatedButton(
              backgroundColor: Colors.lightBlueAccent.withAlpha(40),
              borderRadius: 12,
              pixelHeight: 44,
              label: "Create your course",
              textSize: 15,
              textColor: context.isDarkMode ? Colors.white : Colors.black,
            ),
          ),

          ConstantSizing.columnSpacingMedium,

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: CustomElevatedButton(
              backgroundColor: Colors.deepPurple,
              borderRadius: 12,
              pixelHeight: 44,
              label: "Explore Courses",
              textSize: 15,
              textColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
