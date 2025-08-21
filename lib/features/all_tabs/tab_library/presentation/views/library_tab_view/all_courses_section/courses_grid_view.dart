import 'dart:developer';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/domain/models/file_details.dart';
import 'package:slides_sync/domain/models/course_model/course.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/views/library_tab_view/all_courses_section/grid_course_card.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:slides_sync/shared/widgets/build_image_path_widget.dart';

class CoursesGridView extends ConsumerWidget {
  const CoursesGridView({
    super.key,
    required this.scaleClickProviderFamily,
    required this.longPressTapDetailsProvider,
    required this.data,
    required this.onTap,
    required this.onLongPress,
  });

  final StateProviderFamily<bool, int> scaleClickProviderFamily;
  final StateProvider<TapDownDetails?> longPressTapDetailsProvider;
  final List<Course> data;
  final void Function(int index) onTap;
  final void Function(int index) onLongPress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = context.isDarkMode;
    final double dimension = (context.deviceWidth > context.deviceHeight ? context.deviceWidth * 0.12 : context.deviceWidth * 0.12);
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
          final Course course = data[index];
          updateScaleClickProvider(bool newValue) => ref.read(provider.notifier).update((cb) => newValue);
          updateTapDownDetailsProvider(TapDownDetails det) => ref.read(longPressTapDetailsProvider.notifier).update((state) => det);
          return AnimatedScale(
            scale: ref.watch(provider) ? 0.8 : 1.0,
            duration: Durations.medium3,
            curve: CustomCurves.defaultIosSpring,
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTapDown: (details) {
                  if (!ref.read(provider.notifier).state) updateTapDownDetailsProvider(details);
                  updateScaleClickProvider(true);
                  
                },
                onTapCancel: () {
                  updateScaleClickProvider(false);
                },
                onTapUp: (details) async {
                  await Future.delayed(Durations.short2);
                  updateScaleClickProvider(false);
                },
                onLongPress: () {
                  onLongPress(index);
                },
                onTap: () => onTap(index),
                child: GridCourseCard(
                  isDarkMode: isDarkMode,
                  dimension: dimension,
                  courseCode: course.courseCode,
                  courseName: course.courseName,
                  categoriesCount: course.collections.length,
                  onTapIcon: () => onLongPress(index),
                  progress: 0.0,
                  courseImageWidget: BuildImagePathWidget(
                    fileDetails: course.imageLocationJson.fileDetails,
                    fallbackWidget: Icon(Iconsax.document_1, size: 16, color: isDarkMode ? Colors.white : Colors.black),
                  ),
                ),
              ),
            ),
          ).animate().fadeIn();
        }),
      ),
    );
  }
}
