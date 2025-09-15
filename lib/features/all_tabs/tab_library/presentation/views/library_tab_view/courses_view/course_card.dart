import 'dart:developer';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/domain/models/course_model/course.dart';
import 'package:slides_sync/domain/repos/course_repo/course_repo.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/actions/course_card_actions.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/providers/library_tab_view_providers.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/views/library_tab_view/courses_view/course_card/grid_course_card.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/views/library_tab_view/courses_view/course_card/list_course_card.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

class CourseCard extends ConsumerStatefulWidget {
  final Course course;
  final bool isGrid;
  final AutoDisposeStateProvider<bool> scaleClickProvider;
  final void Function(Course course)? onTap;
  const CourseCard(this.course, this.isGrid, {super.key, required this.scaleClickProvider, this.onTap});

  @override
  ConsumerState<CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends ConsumerState<CourseCard> {
  late final AutoDisposeStreamProvider<Course?> streamedCourseProvider;
  @override
  void initState() {
    super.initState();
    streamedCourseProvider = AutoDisposeStreamProvider((cb) => CourseRepo.watchCourseByDbId(widget.course.id));
  }

  void updateScaleClickProvider(bool newValue) => ref.read(widget.scaleClickProvider.notifier).update((cb) => newValue);
  void updateTapDownDetailsProvider(Offset det) {
    ref.read(LibraryTabViewProviders.cardTapPositionDetails.notifier).update((state) => det);
  }

  @override
  Widget build(BuildContext context) {
    final Course streamedCourse = ref.watch(streamedCourseProvider).value ?? widget.course;
    final theme = ref.theme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: AnimatedScale(
        scale: ref.watch(widget.scaleClickProvider) ? 0.9 : 1.0,
        duration: Durations.medium2,
        curve: CustomCurves.defaultIosSpring,
        child: ClipRSuperellipse(
          borderRadius: BorderRadius.circular(26),
          child: ColoredBox(
            color:
                theme.isDarkTheme
                    ? theme.adjustBgAndPrimaryWithLerp
                    : theme.adjustBgAndPrimaryWithLerp.withValues(alpha: 0.45),
            child: Padding(
              padding: const EdgeInsets.all(1.5),
              child: ClipRSuperellipse(
                borderRadius: BorderRadius.circular(24),
                child: GestureDetector(
                  // overlayColor: WidgetStatePropertyAll(Colors.white.withAlpha(80)),
                  onTapDown: (details) {
                    if (!ref.read(widget.scaleClickProvider.notifier).state) {
                      updateTapDownDetailsProvider(details.globalPosition);
                    }
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
                    CourseCardActions.of(ref).onHoldCourseCard(streamedCourse);
                  },
                  onTap: () {
                    if (widget.onTap != null) {
                      widget.onTap!(widget.course);
                      return;
                    }
                    CourseCardActions.of(ref).onTapCourseCard(streamedCourse);
                  },
                  child:
                      widget.isGrid
                          ? GridCourseCard(
                            streamedCourse,
                            onTapIcon: () {
                              CourseCardActions.of(ref).onHoldCourseCard(streamedCourse);
                            },
                            progress: 0.0,
                          )
                          : ListCourseCard(
                            streamedCourse,
                            onTapIcon: () {
                              CourseCardActions.of(ref).onHoldCourseCard(streamedCourse);
                            },
                            progress: 0.0,
                          ),
                ),
              ),
            ),
          ),
        ),
      ),
    ).animate().fadeIn();
  }
}
