import 'dart:developer';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/core/models/file_details.dart';
import 'package:slides_sync/data/models/course_model/course_model.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/views/library_tab_view/all_courses_section/list_course_card.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:slides_sync/shared/widgets/build_image_path_widget.dart';

class CoursesListView extends ConsumerWidget {
  const CoursesListView({
    super.key,
    required this.scaleClickProviderFamily,
    required this.longPressTapDetailsProvider,
    required this.data,
    required this.onTap,
    required this.onLongPress,
  });

  final StateProviderFamily<bool, int> scaleClickProviderFamily;
  final StateProvider<TapDownDetails?> longPressTapDetailsProvider;
  final List<CourseModel> data;
  final void Function(int index) onTap;
  final void Function(int index) onLongPress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(childCount: data.length, (context, index) {
          final StateProvider<bool> provider = scaleClickProviderFamily(index);
          final CourseModel courseModel = data[index];
          updateScaleClickProvider(bool newValue) => ref.read(provider.notifier).update((cb) => newValue);
          updateTapDownDetailsProvider(TapDownDetails det) => ref.read(longPressTapDetailsProvider.notifier).update((state) => det);

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: AnimatedScale(
              scale: ref.watch(provider) ? 0.85 : 1.0,
              duration: Durations.medium3,
              curve: CustomCurves.defaultIosSpring,
              child: Material(
                type: MaterialType.transparency,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  overlayColor: WidgetStatePropertyAll(Colors.white.withAlpha(80)),
                  onTapDown: (details) {
                    log("Detected tap down...");
                    if (!ref.read(provider.notifier).state) updateTapDownDetailsProvider(details);
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
                  onLongPress: () {
                    log("Long press...");
                    onLongPress(index);
                  },
                  onTap: () => onTap(index),
                  child: ListCourseCard(
                    isDarkMode: context.isDarkMode,
                    courseCode: courseModel.courseCode,
                    courseName: courseModel.courseName,
                    hasImage: courseModel.imageLocationJson.fileDetails.containsFilePath,
                    categoriesCount: courseModel.subCollections.length,
                    onTapIcon: () => onLongPress(index),
                    progress: 0.0,
                    courseImageWidget: BuildImagePathWidget(
                      fileDetails: courseModel.imageLocationJson.fileDetails,
                      fallbackWidget: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:
                            courseModel.courseCode.isEmpty
                                ? Icon(Iconsax.document_1, color: context.theme.colorScheme.primary)
                                : Center(
                                  child: CustomText(
                                    courseModel.courseCode.substring(0, courseModel.courseCode.length.clamp(0, 8)),
                                    fontSize:
                                        context.deviceWidth < context.deviceHeight
                                            ? context.deviceWidth * 0.025
                                            : context.deviceHeight * 0.025,
                                    fontWeight: FontWeight.bold,
                                    textAlign: TextAlign.center,
                                    color: context.theme.colorScheme.primary,
                                  ),
                                ),
                      ),
                    ),
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
