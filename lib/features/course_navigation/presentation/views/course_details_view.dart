import 'dart:developer';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/data/models/course_model/course.dart';
import 'package:slides_sync/features/course_navigation/presentation/providers/course_provider.dart';
import 'package:slides_sync/features/course_navigation/presentation/views/course_details/course_details_collection_section.dart';
import 'package:slides_sync/features/course_navigation/presentation/views/course_details/course_details_header.dart';
import 'package:slides_sync/features/course_navigation/presentation/views/course_details/positioned_course_options.dart';
import 'package:slides_sync/features/manage_all/manage_collections/presentation/views/modify_collections/collections_view_search_bar.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

class CourseDetailsView extends ConsumerStatefulWidget {
  final Course course;
  const CourseDetailsView({super.key, required this.course});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CourseDetailsViewState();
}

class _CourseDetailsViewState extends ConsumerState<CourseDetailsView> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: UiUtils.getSystemUiOverlayStyle(context.scaffoldBackgroundColor, context.isDarkMode, statusBarColor: Colors.transparent),
      child: Scaffold(extendBody: true, body: CourseDetailsOuterSection(course: widget.course)),
    );
  }
}

class CourseDetailsOuterSection extends ConsumerStatefulWidget {
  final Course course;
  const CourseDetailsOuterSection({super.key, required this.course});

  @override
  ConsumerState<CourseDetailsOuterSection> createState() => _CourseDetailsOuterSectionState();
}

class _CourseDetailsOuterSectionState extends ConsumerState<CourseDetailsOuterSection> {
  late final ScrollController viewScrollController;
  late final StateProvider<double> scrollOffsetProvider;

  @override
  void initState() {
    super.initState();
    viewScrollController = ScrollController();
    scrollOffsetProvider = StateProvider((cb) => 0.0);
    viewScrollController.addListener(updateScrollOffset);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final modifyCourseNotifier = ref.read(CourseProviders.courseProvider.notifier);
      if (modifyCourseNotifier.value.lastUpdated != widget.course.lastUpdated) {
        modifyCourseNotifier.update(widget.course);
      }
    });
  }

  void updateScrollOffset() {
    final newOffset = viewScrollController.offset;
    final scrollNotifier = ref.read(scrollOffsetProvider.notifier);
    if (newOffset == scrollNotifier.state) return;
    scrollNotifier.update((cb) => newOffset);
  }

  @override
  void dispose() {
    viewScrollController.removeListener(updateScrollOffset);
    viewScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Course course = ref.watch(CourseProviders.courseProvider);
    const double appBarHeight = 180;
    final scrollOffset = ref.watch(scrollOffsetProvider);
    final isScrolled = scrollOffset >= appBarHeight / 2;
    final double percentScroll = (scrollOffset / (appBarHeight + context.topPadding)).clamp(0, 1);
    
    return Stack(
      clipBehavior: Clip.hardEdge,
      children: [
        NestedScrollView(
          controller: viewScrollController,
          physics: const NeverScrollableScrollPhysics(),
          headerSliverBuilder:
              (context, innerBoxIsScrolled) => [CourseDetailsHeader(course: course, isScrolled: isScrolled, appBarHeight: appBarHeight)],
          body: CustomScrollView(
            slivers: [
              PinnedHeaderSliver(
                child: AnimatedSize(
                  duration: Durations.medium1,
                  curve: CustomCurves.defaultIosSpring,
                  child: ConstantSizing.columnSpacing((kToolbarHeight + context.topPadding) * percentScroll),
                ),
              ),
              PinnedHeaderSliver(child: CollectionsViewSearchBar()),
              CourseDetailsCollectionSection(course: course),

              SliverToBoxAdapter(child: ConstantSizing.columnSpacingMedium),
            ],
          ),
        ),

        PositionedCourseOptions(),
      ],
    );
  }
}
