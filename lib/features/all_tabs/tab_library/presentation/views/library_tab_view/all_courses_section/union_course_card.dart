import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/domain/models/course_model/course.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/views/library_tab_view/all_courses_section/course_card/grid_course_card.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/views/library_tab_view/all_courses_section/course_card/list_course_card.dart';

class UnionCourseCard extends ConsumerWidget {
  final Course course;
  final bool isGrid;
  final AutoDisposeStateProvider<bool> scaleClickProvider;
  final StateProvider<Offset?> longPressTapDetailsProvider;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  const UnionCourseCard(
    this.course,
    this.isGrid, {
    super.key,
    required this.scaleClickProvider,
    required this.longPressTapDetailsProvider,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    updateScaleClickProvider(bool newValue) =>
        ref.read(scaleClickProvider.notifier).update((cb) => newValue);
    updateTapDownDetailsProvider(Offset det) =>
        ref.read(longPressTapDetailsProvider.notifier).update((state) => det);
    final scale = ref.watch(scaleClickProvider) ? 0.9 : 1.0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: AnimatedScale(
        scale: scale,
        duration: Durations.medium2,
        curve: CustomCurves.defaultIosSpring,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            overlayColor: WidgetStatePropertyAll(Colors.white.withAlpha(80)),
            onTapDown: (details) {
              if (!ref.read(scaleClickProvider.notifier).state) {
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
              onLongPress();
            },
            onTap: onTap,
            child:
                isGrid
                    ? GridCourseCard(
                      course,
                      onTapIcon: onLongPress,
                      progress: 0.0,
                    )
                    : ListCourseCard(
                      course,
                      onTapIcon: onLongPress,
                      progress: 0.0,
                    ),
          ),
        ),
      ),
    ).animate().fadeIn();
  }
}
