import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/domain/models/course_model/course.dart';
import 'package:slides_sync/domain/repos/course_repo/course_collection_repo.dart';
import 'package:slides_sync/features/manage_all/manage_contents/presentation/views/add_contents/add_content_fab.dart';
import 'package:slides_sync/features/course_navigation/presentation/views/course_materials/course_materials_outer_section.dart';
import 'package:slides_sync/shared/components/app_bar_container.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

class CourseMaterialsView extends ConsumerStatefulWidget {
  final CourseCollection collection;
  const CourseMaterialsView({super.key, required this.collection});

  @override
  ConsumerState<CourseMaterialsView> createState() => _CourseMaterialsViewState();
}

class _CourseMaterialsViewState extends ConsumerState<CourseMaterialsView> {
  late final AutoDisposeStreamProvider<CourseCollection?> streamedCollection;
  @override
  void initState() {
    super.initState();
    streamedCollection = AutoDisposeStreamProvider((cb) => CourseCollectionRepo.watchByDbId(widget.collection.id));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final CourseCollection collection = ref.watch(streamedCollection).value ?? widget.collection;
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
                IconButton(onPressed: () {}, icon: Icon(Iconsax.menu_board)),
                IconButton(onPressed: () {}, icon: Icon(Iconsax.search_normal_copy)),
              ],
            ),
          ),
        ),

        floatingActionButton: AddContentFAB(collection: collection),

        body: CourseMaterialsOuterSection(collection: collection),
      ),
    );
  }
}
