import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/data/models/course_model/course_model.dart';
import 'package:slides_sync/data/repos/course_repo.dart';
import 'package:slides_sync/features/modify_all/modify_collections/presentation/views/modify_collections/add_collection_action_button.dart';
import 'package:slides_sync/features/modify_all/modify_collections/presentation/views/modify_collections/collections_list_view.dart';
import 'package:slides_sync/features/modify_all/modify_collections/presentation/views/modify_collections/collections_view_search_bar.dart';
import 'package:slides_sync/features/modify_all/modify_collections/presentation/views/modify_collections/create_collection_bottom_sheet.dart';
import 'package:slides_sync/features/modify_all/modify_collections/presentation/views/modify_collections/empty_collections_view.dart';
import 'package:slides_sync/features/modify_all/modify_courses/presentation/viewmodels/modify_course_providers.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

import '../../../../../core/utils/ui_utils.dart';
import '../../../../../shared/components/app_bar_container.dart';
import '../../../../../shared/components/app_bar_container_child.dart';

class ModifyCollectionsView extends ConsumerStatefulWidget {
  final int courseDbId;

  const ModifyCollectionsView({super.key, required this.courseDbId});

  @override
  ConsumerState createState() => _ModifyCollectionsViewState();
}

class _ModifyCollectionsViewState extends ConsumerState<ModifyCollectionsView> {
  late final ScrollController scrollController;
  late final AutoDisposeStateProvider<double> scrollOffsetProvider;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    scrollOffsetProvider = AutoDisposeStateProvider((ref) => 0.0);
    scrollController.addListener(listenToscrollOffsetProvider);
  }

  void listenToscrollOffsetProvider() {
    if (scrollController.positions.isNotEmpty && context.mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(scrollOffsetProvider.notifier).update((cb) => scrollController.offset);
      });
    }
  }


  @override
  void dispose() {
    scrollController.removeListener(listenToscrollOffsetProvider);
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final CourseModel courseModel = ref.watch(ModifyCourseProviders.modifyCourseProvider);

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

        body: ModifyCollectionsOuterSection(scrollController: scrollController, courseModel: courseModel),
      ),
    );
  }
}

class ModifyCollectionsOuterSection extends StatelessWidget {
  const ModifyCollectionsOuterSection({super.key, required this.scrollController, required this.courseModel});

  final ScrollController scrollController;
  final CourseModel courseModel;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
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
    );
  }
}
