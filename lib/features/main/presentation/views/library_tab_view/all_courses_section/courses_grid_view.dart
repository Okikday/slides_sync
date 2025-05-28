import 'dart:developer';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/features/course_mgmt/data/models/course_model/course_model.dart';
import 'package:slides_sync/features/main/presentation/views/library_tab_view/all_courses_section/grid_course_card.dart';
import 'package:slides_sync/shared/helpers/widget_helper.dart';
import 'package:slides_sync/shared/styles/app_ui_context.dart';

class CoursesGridView extends ConsumerWidget {
  const CoursesGridView({super.key, required this.scaleClickProviderFamily, required this.data, required this.onTap});

  final StateProviderFamily<bool, int> scaleClickProviderFamily;
  final List<CourseModel> data;
  final void Function(int index) onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: context.deviceHeight > context.deviceWidth ? 2 : 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
        ),
        delegate: SliverChildBuilderDelegate(childCount: data.length, (context, index) {
          final StateProvider<bool> provider = scaleClickProviderFamily(index);
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
              onTap: () => onTap(index),
              child: GridCourseCard(
                isDarkMode: context.isDarkMode,
                courseCode: courseModel.courseCode,
                courseName: courseModel.courseName,
                categoriesCount: courseModel.subCollections.length,
                progress: 0.0,
                courseImageWidget: WidgetHelper.resolveImageWidget(
                  courseModel.imagePath,
                  fallbackWidget: Icon(Iconsax.document_1, size: 16, color: Colors.white),
                ),
              ),
            ),
          ).animate().fadeIn();
        }),
      ),
    );
  }
}
