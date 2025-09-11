import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/domain/models/course_model/course.dart';
import 'package:slides_sync/domain/repos/course_repo/course_collection_repo.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/views/library_tab_view/library_tab_view_app_bar/library_tab_view_layout_button.dart';
import 'package:slides_sync/features/course_navigation/presentation/providers/course_materials_providers.dart';
import 'package:slides_sync/features/manage_all/manage_contents/presentation/views/add_contents/add_content_fab.dart';
import 'package:slides_sync/features/course_navigation/presentation/views/course_materials/materials_view.dart';
import 'package:slides_sync/shared/components/app_bar_container.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

class CourseMaterialsView extends ConsumerStatefulWidget {
  final CourseCollection collection;
  const CourseMaterialsView({super.key, required this.collection});

  @override
  ConsumerState<CourseMaterialsView> createState() => _CourseMaterialsViewState();
}

class _CourseMaterialsViewState extends ConsumerState<CourseMaterialsView> {
  late final ScrollController scrollController;
  // late final AutoDisposeStreamProvider<CourseCollection?> streamedCollection;
  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    scrollController.addListener(scrollListener);
    // streamedCollection = AutoDisposeStreamProvider((cb) => CourseCollectionRepo.watchByDbId(widget.collection.id));
  }

  void scrollListener() {
    final scrollOffsetNotifier = ref.read(CourseMaterialsProviders.scrollOffsetProvider.notifier);
    final prevOffset = scrollOffsetNotifier.state;
    final currOffset = scrollController.offset;
    if (currOffset != prevOffset) {
      scrollOffsetNotifier.update((cb) => currOffset);
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ref.watch(streamedCollection).value ??
    final CourseCollection collection = widget.collection;
    return AnnotatedRegion(
      value: UiUtils.getSystemUiOverlayStyle(context.scaffoldBackgroundColor, context.isDarkMode),
      child: Scaffold(
        appBar: AppBarContainer(
          appBarHeight: kToolbarHeight + 12,
          padding: EdgeInsets.zero,
          child: AppBarContainerChild(
            context.isDarkMode,
            title: collection.collectionTitle,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                LibraryTabViewLayoutButton(
                  isListLayoutProvider: CourseMaterialsProviders.isListLayout,
                  backgroundColor: Colors.transparent,
                ),
                IconButton(onPressed: () {}, icon: Icon(Iconsax.search_normal_copy)),
              ],
            ),
          ),
        ),

        floatingActionButton: AddContentFAB(
          collection: collection,
          scrollOffsetProvider: CourseMaterialsProviders.scrollOffsetProvider,
        ),

        body: CustomScrollView(
          controller: scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [MaterialsView(collection: collection, scrollController: scrollController)],
        ),
      ),
    );
  }
}
