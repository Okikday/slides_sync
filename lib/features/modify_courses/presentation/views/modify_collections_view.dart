import 'dart:developer';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/data/models/course_model/course_model.dart';
import 'package:slides_sync/data/repos/course_repo.dart';
import 'package:slides_sync/features/modify_courses/presentation/views/modify_collections/add_collection_action_button.dart';
import 'package:slides_sync/features/modify_courses/presentation/views/modify_collections/collections_list_view.dart';
import 'package:slides_sync/features/modify_courses/presentation/views/modify_collections/collections_view_search_bar.dart';
import 'package:slides_sync/features/modify_courses/presentation/views/modify_collections/create_collection_bottom_sheet.dart';
import 'package:slides_sync/features/modify_courses/presentation/views/modify_collections/empty_collections_view.dart';
import 'package:slides_sync/shared/styles/app_ui_context.dart';

import '../../../../core/utils/ui_utils.dart';
import '../../../../shared/components/app_bar_container.dart';
import '../../../../shared/components/app_bar_container_child.dart';

class ModifyCollectionsView extends ConsumerStatefulWidget {
  final CourseModel courseModel;

  const ModifyCollectionsView({super.key, required this.courseModel});

  @override
  ConsumerState createState() => _ModifyCollectionsViewState();
}

class _ModifyCollectionsViewState extends ConsumerState<ModifyCollectionsView> {
  late final StateProvider<CourseModel> modifyCourseProvider;
  late final StreamProvider<CourseModel?> syncCourseProvider;
  late final ScrollController scrollController;
  late final StateProvider<double> scrollOffsetProvider;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    modifyCourseProvider = StateProvider((ref) => widget.courseModel);
    syncCourseProvider = StreamProvider((ref) => CourseRepo.watchCourseByDbId(widget.courseModel.id));
    scrollOffsetProvider = StateProvider((ref) => 0.0);
    scrollController.addListener(listenToscrollOffsetProvider);
  }

  void listenToscrollOffsetProvider() {
    if (scrollController.positions.isNotEmpty && context.mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(scrollOffsetProvider.notifier).update((cb) => scrollController.offset);
      });
    }
  }

  void syncCourseWithStorage(AsyncValue<CourseModel?>? prev, AsyncValue<CourseModel?> next) {
    if (!next.hasValue) return;
    final CourseModel? currCourse = next.value;
    if (currCourse == null) return;
    ref.read(modifyCourseProvider.notifier).update((cb) => currCourse);
  }

  @override
  void dispose() {
    scrollController.removeListener(listenToscrollOffsetProvider);
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(syncCourseProvider, syncCourseWithStorage);

    final CourseModel courseModel = ref.watch(modifyCourseProvider);

    return AnnotatedRegion(
      value: UiUtils.getSystemUiOverlayStyle(context.scaffoldBackgroundColor, context.isDarkMode),
      child: Scaffold(
        appBar: AppBarContainer(
          appBarHeight: kToolbarHeight + 12,
          padding: EdgeInsets.zero,
          child: AppBarContainerChild(
            context.isDarkMode,
            title: courseModel.courseName,
            tooltipMessage: "${courseModel.courseName}(${courseModel.courseCode})",
          ),
        ),

        floatingActionButton:
            courseModel.subCollections.isNotEmpty
                ? AddCollectionActionButton(
                  courseDbId: courseModel.id,
                  isScrolled: ref.watch(scrollOffsetProvider) > 40,
                  onClickUp: () {
                    scrollController.animateTo(0.0, duration: Durations.medium1, curve: CustomCurves.defaultIosSpring);
                  },
                )
                : null,

        body: CustomScrollView(
          controller: scrollController,
          slivers: [
            if (courseModel.subCollections.isNotEmpty) PinnedHeaderSliver(child: CollectionsViewSearchBar()),

            if (courseModel.subCollections.isNotEmpty)
              CollectionsListView(courseDbId: courseModel.id, collections: courseModel.subCollections)
            else
              EmptyCollectionsView(
                onClickAddCollection: () {
                  CustomDialog.show(
                    context,
                    canPop: true,
                    barrierColor: Colors.black.withAlpha(150),
                    child: CreateCollectionBottomSheet(courseDbId: courseModel.id),
                  );
                },
              ),
            SliverToBoxAdapter(child: ConstantSizing.columnSpacingMedium),

            // ),
          ],
        ),
      ),
    );
  }
}
