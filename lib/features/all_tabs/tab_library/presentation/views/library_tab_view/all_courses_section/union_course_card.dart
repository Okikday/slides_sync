import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/domain/models/course_model/course.dart';
import 'package:slides_sync/domain/repos/course_repo/course_repo.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/views/library_tab_view/all_courses_section/course_card/grid_course_card.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/views/library_tab_view/all_courses_section/course_card/list_course_card.dart';

class UnionCourseCard extends ConsumerStatefulWidget {
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
  ConsumerState<UnionCourseCard> createState() => _UnionCourseCardState();
}

class _UnionCourseCardState extends ConsumerState<UnionCourseCard> {
  late final AutoDisposeStreamProvider<Course?> streamedCourseProvider;
  @override
  void initState() {
    super.initState();
    streamedCourseProvider = AutoDisposeStreamProvider((cb) => CourseRepo.watchCourseByDbId(widget.course.id));
  }

  void updateScaleClickProvider(bool newValue) => ref.read(widget.scaleClickProvider.notifier).update((cb) => newValue);
  void updateTapDownDetailsProvider(Offset det) =>
      ref.read(widget.longPressTapDetailsProvider.notifier).update((state) => det);

  @override
  Widget build(BuildContext context) {
    final Course streamedCourse = ref.watch(streamedCourseProvider).value ?? widget.course;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: AnimatedScale(
        scale: ref.watch(widget.scaleClickProvider) ? 0.9 : 1.0,
        duration: Durations.medium2,
        curve: CustomCurves.defaultIosSpring,
        child: ClipRRect(
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
              widget.onLongPress();
            },
            onTap: widget.onTap,
            child:
                Center(
              child:
                  widget.isGrid
                      ? GridCourseCard(streamedCourse, onTapIcon: widget.onLongPress, progress: 0.0)
                      : ListCourseCard(streamedCourse, onTapIcon: widget.onLongPress, progress: 0.0),
            ),
          ),
        ),
      ),
    ).animate().fadeIn();
  }
}
