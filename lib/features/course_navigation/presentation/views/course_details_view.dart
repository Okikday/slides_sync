import 'dart:developer';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/domain/models/course_model/course.dart';
import 'package:slides_sync/core/global_providers/data_providers/course_providers.dart';
import 'package:slides_sync/features/course_navigation/presentation/views/course_details/course_details_collection_section.dart';
import 'package:slides_sync/features/course_navigation/presentation/views/course_details/course_details_header.dart';
import 'package:slides_sync/features/course_navigation/presentation/views/course_details/positioned_course_options.dart';
import 'package:slides_sync/features/manage_all/manage_collections/presentation/views/modify_collections/collections_view_search_bar.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

const double appBarHeight = 180;

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
      value: UiUtils.getSystemUiOverlayStyle(
        context.scaffoldBackgroundColor,
        context.isDarkMode,
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(extendBody: true, body: CourseDetailsOuterSection(course: widget.course)),
    );
  }
}

// Course Details Outer Section
class CourseDetailsOuterSection extends ConsumerStatefulWidget {
  final Course course;
  const CourseDetailsOuterSection({super.key, required this.course});

  @override
  ConsumerState<CourseDetailsOuterSection> createState() => _CourseDetailsOuterSectionState();
}

class _CourseDetailsOuterSectionState extends ConsumerState<CourseDetailsOuterSection> {
  late final ScrollController viewScrollController;
  late final AutoDisposeStateProvider<double> scrollOffsetProvider;
  late final TextEditingController searchCollectionController;
  late final ValueNotifier<String> searchCollectionTextNotifier;

  @override
  void initState() {
    super.initState();
    viewScrollController = ScrollController();
    scrollOffsetProvider = AutoDisposeStateProvider((cb) => 0.0);
    searchCollectionController = TextEditingController();
    searchCollectionTextNotifier = ValueNotifier("");
    viewScrollController.addListener(updateScrollOffset);
    searchCollectionController.addListener(searchCollectionTextListener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(CourseProviders.courseProvider.notifier).updateByDate(widget.course);
    });
  }

  void updateScrollOffset() {
    final newOffset = viewScrollController.offset;
    final scrollNotifier = ref.read(scrollOffsetProvider.notifier);
    if (newOffset == scrollNotifier.state) return;
    scrollNotifier.update((cb) => newOffset);
  }

  void searchCollectionTextListener() {
    if (searchCollectionTextNotifier.value == searchCollectionController.text) return;
    searchCollectionTextNotifier.value = searchCollectionController.text;
  }

  @override
  void dispose() {
    searchCollectionController.removeListener(searchCollectionTextListener);
    searchCollectionController.dispose();
    searchCollectionTextNotifier.dispose();
    viewScrollController.removeListener(updateScrollOffset);
    viewScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<Course> courseAsyncValue = ref.watch(CourseProviders.courseProvider);
    

    return Stack(
      clipBehavior: Clip.hardEdge,
      children: [
        NestedScrollView(
          controller: viewScrollController,
          physics: const NeverScrollableScrollPhysics(),
          headerSliverBuilder:
              (context, innerBoxIsScrolled) => [
                courseAsyncValue.when(
                  data:
                      (data) => CourseDetailsHeader(
                        course: data,
                  scrollOffsetProvider: scrollOffsetProvider,
                  appBarHeight: appBarHeight,
                ),
                  error:
                      (error, st) => CourseDetailsHeader(
                        course: widget.course,
                        scrollOffsetProvider: scrollOffsetProvider,
                        appBarHeight: appBarHeight,
                      ),
                  loading:
                      () => CourseDetailsHeader(
                        course: widget.course,
                        scrollOffsetProvider: scrollOffsetProvider,
                        appBarHeight: appBarHeight,
                      ),
                ),
                
              ],
          body: CustomScrollView(
            slivers: [
              PinnedHeaderSliver(child: AdjustingSpacing(scrollOffsetProvider: scrollOffsetProvider)),
              PinnedHeaderSliver(
                child: CollectionsViewSearchBar(
                  searchController: searchCollectionController,
                  onTap: () {
                    viewScrollController.animateTo(
                      appBarHeight + 8,
                      duration: Durations.medium4,
                      curve: CustomCurves.defaultIosSpring,
                    );
                  },
                ),
              ),
              CourseDetailsCollectionSection(courseAsyncValue: courseAsyncValue, searchCollectionTextNotifier: searchCollectionTextNotifier),

              SliverToBoxAdapter(child: ConstantSizing.columnSpacingMedium),
            ],
          ),
        ),

        PositionedCourseOptions(),
      ],
    );
  }
}

class AdjustingSpacing extends ConsumerWidget {
  final AutoDisposeStateProvider<double> scrollOffsetProvider;
  const AdjustingSpacing({super.key, required this.scrollOffsetProvider});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollOffset = ref.watch(scrollOffsetProvider);
    final double percentScroll = (scrollOffset / (appBarHeight + context.topPadding)).clamp(0, 1);
    return AnimatedSize(
      duration: Durations.medium1,
      curve: CustomCurves.defaultIosSpring,
      child: ConstantSizing.columnSpacing((kToolbarHeight + context.topPadding) * percentScroll),
    );
  }
}
