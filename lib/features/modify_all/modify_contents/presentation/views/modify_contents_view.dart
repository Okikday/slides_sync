import 'package:collection/collection.dart';
import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/core/utils/result.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/data/models/course_model/course_model.dart';
import 'package:slides_sync/data/repos/course_repo.dart';
import 'package:slides_sync/features/modify_all/modify_contents/presentation/views/modify_contents/add_contents_fab.dart';
import 'package:slides_sync/features/modify_all/modify_contents/presentation/views/modify_contents/modify_content_list_view.dart';
import 'package:slides_sync/features/modify_all/modify_contents/presentation/views/modify_contents/modify_contents_header.dart';
import 'package:slides_sync/features/modify_all/modify_courses/presentation/providers/modify_course_providers.dart';
import 'package:slides_sync/shared/components/app_bar_container.dart';
import 'package:slides_sync/shared/components/app_bar_container_child.dart';
import 'package:slides_sync/shared/models/type_defs.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

class ModifyContentsView extends ConsumerStatefulWidget {
  final ContentRecord<int, CourseSubCollection, CourseTitleRecord> record;
  const ModifyContentsView({super.key, required this.record});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ModifyContentsViewState();
}

class _ModifyContentsViewState extends ConsumerState<ModifyContentsView> {
  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    // ref.listen(syncCourseProvider, syncCourseWithStorage);
    CourseSubCollection? stateCollection = ref
        .watch(ModifyCourseProviders.modifyCourseProvider)
        .subCollections
        .firstWhereOrNull((e) => e.collectionId == widget.record.collection.collectionId);

    return AnnotatedRegion(
      value: UiUtils.getSystemUiOverlayStyle(context.scaffoldBackgroundColor, context.isDarkMode),
      child: Scaffold(
        appBar: AppBarContainer(
          appBarHeight: kToolbarHeight + 12,
          padding: EdgeInsets.zero,
          child: AppBarContainerChild(
            context.isDarkMode,
            title: widget.record.collection.collectionTitle,
            subtitle: "Collection",
            subtitleStyle: TextStyle(fontSize: 12, color: context.theme.colorScheme.outline,),
          ),
        ),

        floatingActionButton: AddContentsFAB(collection: widget.record.collection),

        body: ModifyContentsOuterSection(record: (
                collection: stateCollection ?? widget.record.collection,
                courseDbId: widget.record.courseDbId,
                courseTitle: widget.record.courseTitle,
              ) ),
      ),
    );
  }
}

class ModifyContentsOuterSection extends ConsumerWidget {
  final ContentRecord<int, CourseSubCollection, CourseTitleRecord> record;
  const ModifyContentsOuterSection({super.key, required this.record});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomScrollView(
      slivers: [
        ModifyContentsHeader(),
        SliverToBoxAdapter(child: ConstantSizing.columnSpacingSmall),
        ModifyContentListView(
          collectionId: record.collection.collectionId,
          courseDbId: record.courseDbId,
          contentList: record.collection.courseContents),

        SliverToBoxAdapter(child: ConstantSizing.columnSpacing(context.bottomPadding)),
      ],
    );
  }
}
