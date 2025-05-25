import 'dart:developer';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:googleapis/forms/v1.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:slides_sync/core/usecases/app_navigator.dart';
import 'package:slides_sync/features/course_mgmt/data/models/course_model/course_model.dart';
import 'package:slides_sync/features/course_mgmt/presentation/viewmodels/notifiers/select_to_modify_course/get_courses_notifier.dart';
import 'package:slides_sync/shared/components/loading_view.dart';
import 'package:slides_sync/shared/helpers/widget_helper.dart';
import 'package:slides_sync/shared/strings/icon_strings.dart';
import 'package:slides_sync/shared/styles/app_ui_context.dart';
import 'all_courses_section/grid_course_card.dart';
import 'all_courses_section/list_course_card.dart';

class AllCoursesSection extends ConsumerStatefulWidget {
  final bool isListView;

  const AllCoursesSection({super.key, required this.isListView,});

  @override
  ConsumerState createState() => _AllCoursesSectionState();
}

class _AllCoursesSectionState extends ConsumerState<AllCoursesSection> {
  late final AutoDisposeStateProviderFamily<bool, int> scaleClickProviderFamily;
  late final StateProvider<bool> isCourseClickedProvider;
  late final StreamNotifierProvider<WatchAllCoursesStreamNotifier, List<CourseModel>> asyncGetCoursesProvider;

  @override
  void initState() {
    super.initState();
    scaleClickProviderFamily = AutoDisposeStateProviderFamily((ref, index) => false);
    isCourseClickedProvider = StateProvider((ref) => false);
    asyncGetCoursesProvider = StreamNotifierProvider<WatchAllCoursesStreamNotifier, List<CourseModel>>(WatchAllCoursesStreamNotifier.new);
  }

  @override
  Widget build(BuildContext context) {
    
    final AsyncValue<List<CourseModel>> streamedCourses = ref.watch(asyncGetCoursesProvider);

    return streamedCourses.when(
      data: (data) {
        if (data.isEmpty) {
          return SliverList.list(
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
          );
        }

        if (widget.isListView) {
          return SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(childCount: data.length, (context, index) {
                final AutoDisposeStateProvider<bool> provider = scaleClickProviderFamily(index);
                final CourseModel courseModel = data[index];
                updateScaleClickProvider(bool newValue) => ref.read(provider.notifier).update((cb) => newValue);

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: AnimatedScale(
                    scale: ref.watch(provider) ? 0.85 : 1.0,
                    duration: Durations.medium3,
                    curve: CustomCurves.defaultIosSpring,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTapDown: (details) {
                        log("Detected tap down...");
                        updateScaleClickProvider(true);
                      },
                      onTapCancel: () {
                        log("Detected tap cancel...");
                        updateScaleClickProvider(false);
                      },
                      onTapUp: (details) async {
                        log("Detected tap up...");
                        await Future.delayed(Durations.short2);
                        updateScaleClickProvider(false);
                      },
                      onTap: () async {
                        final isCourseClickedNotifier = ref.read(isCourseClickedProvider.notifier);
                        if (isCourseClickedNotifier.state) return;
                        isCourseClickedNotifier.update((cb) => true); // Tell that a course is currently opened

                        await Future.delayed(Durations.short4);
                        if (context.mounted) {
                          AppNavigator.to(context).courseDetailsViewRoute(CourseModel.create(courseTitle: "Course title"));
                        }
                        if (context.mounted) isCourseClickedNotifier.update((cb) => false);
                      },
                      child: ListCourseCard(
                        isDarkMode: context.isDarkMode,
                        courseCode: courseModel.courseCode,
                        courseName: courseModel.courseName,
                        categoriesCount: courseModel.subCollections.length,
                        progress: 0.0,
                        courseImageWidget: WidgetHelper.resolveImageWidget(
                          courseModel.imagePath,
                          fallbackWidget: Icon(Iconsax.document_1, size: 26),
                        ),
                      ),
                    ),
                  ),
                ).animate().fadeIn();
              }),
            ),
          );
        } else {
          return SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: context.deviceHeight > context.deviceWidth ? 2 : 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              delegate: SliverChildBuilderDelegate(childCount: data.length, (context, index) {
                final AutoDisposeStateProvider<bool> provider = scaleClickProviderFamily(index);
                final CourseModel courseModel = data[index];
                updateScaleClickProvider(bool newValue) => ref.read(provider.notifier).update((cb) => newValue);
                return AnimatedScale(
                  scale: ref.watch(provider) ? 0.8 : 1.0,
                  duration: Durations.medium3,
                  curve: CustomCurves.defaultIosSpring,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTapDown: (details) {
                      log("Detected tap down...");
                      updateScaleClickProvider(true);
                    },
                    onTapCancel: () {
                      log("Detected tap cancel...");
                      updateScaleClickProvider(false);
                    },
                    onTapUp: (details) async {
                      log("Detected tap up...");
                      await Future.delayed(Durations.short2);
                      updateScaleClickProvider(false);
                    },
                    onTap: () async {
                      final isCourseClickedNotifier = ref.read(isCourseClickedProvider.notifier);
                      if (isCourseClickedNotifier.state) return;
                      isCourseClickedNotifier.update((cb) => true); // Tell that a course is currently opened

                      await Future.delayed(Durations.short4);
                      if (context.mounted) {
                        AppNavigator.to(context).courseDetailsViewRoute(CourseModel.create(courseTitle: "Course title"));
                      }
                      isCourseClickedNotifier.update((cb) => false);
                    },
                    child: GridCourseCard(
                      isDarkMode: context.isDarkMode,
                      courseCode: courseModel.courseCode,
                      courseName: courseModel.courseName,
                      categoriesCount: courseModel.subCollections.length,
                      progress: 0.0,
                    ),
                  ),
                ).animate().fadeIn();
              }),
            ),
          );
        }
      },
      error: (_, __) {
        return RotatedBox(quarterTurns: 2, child: Icon(Iconsax.info_circle));
      },
      loading: () {
        return SliverToBoxAdapter(child: LoadingView(msg: "Loading Courses"));
      },
    );
  }
}
