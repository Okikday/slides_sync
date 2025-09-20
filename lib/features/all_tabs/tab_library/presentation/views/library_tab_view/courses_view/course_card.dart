import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/core/global_providers/global_providers.dart';
import 'package:slides_sync/domain/models/course_model/course.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/actions/course_card_actions.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/providers/library_tab_view_providers.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/views/library_tab_view/courses_view/course_card/grid_course_card.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/views/library_tab_view/courses_view/course_card/list_course_card.dart';
import 'package:slides_sync/shared/common_widgets/scale_click_wrapper.dart';

class CourseCard extends ConsumerWidget {
  final Course course;
  final bool isGrid;
  final void Function(Course course)? onTap;
  const CourseCard(this.course, this.isGrid, {super.key, this.onTap});

  void updateTapDownDetailsProvider(WidgetRef ref, Offset det) {
    LibraryTabViewProviders.cardTapPositionDetails = det;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ScaleClickWrapper(
        borderRadius: 24,
        onTapDown: (details) {
          updateTapDownDetailsProvider(ref, details.globalPosition);
        },
        onLongPress: () {
          CourseCardActions.of(ref).onHoldCourseCard(course);
        },
        onTap: () {
          if (onTap != null) {
            onTap!(course);
            return;
          }
          CourseCardActions.of(ref).onTapCourseCard(course);
        },
        child:
            isGrid
                ? GridCourseCard(
                  course,
                  onTapIcon: () {
                    CourseCardActions.of(ref).onHoldCourseCard(course);
                  },
                  progress: 0.0,
                )
                : ListCourseCard(
                  course,
                  onTapIcon: () {
                    CourseCardActions.of(ref).onHoldCourseCard(course);
                  },
                  progress: 0.0,
                ),
      ),
    ).animate().fadeIn();
  }
}
