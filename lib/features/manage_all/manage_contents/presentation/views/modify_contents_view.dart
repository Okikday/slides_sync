import 'package:collection/collection.dart';
import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/core/global_providers/course_providers.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/domain/models/course_model/course.dart';
import 'package:slides_sync/features/manage_all/manage_contents/presentation/views/add_contents/add_content_fab.dart';
import 'package:slides_sync/features/manage_all/manage_contents/presentation/views/modify_contents/empty_contents_view.dart';
import 'package:slides_sync/features/manage_all/manage_contents/presentation/views/modify_contents/modify_content_list_view.dart';
import 'package:slides_sync/features/manage_all/manage_contents/presentation/views/modify_contents/modify_contents_header.dart';
import 'package:slides_sync/features/manage_all/manage_course/presentation/viewmodels/modify_course_providers.dart';
import 'package:slides_sync/shared/components/app_bar_container.dart';
import 'package:slides_sync/shared/models/type_defs.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:slides_sync/shared/styles/colors.dart';

class ModifyContentsView extends ConsumerStatefulWidget {
  final ContentRecord<int, CourseCollection, CourseTitleRecord> record;
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
    CourseCollection? stateCollection = (ref.watch(CourseProviders.courseProvider).value ?? defaultCourse)
        .collections
        .firstWhereOrNull((e) => e.collectionId == widget.record.collection.collectionId);
    final theme = ref.theme;

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
            subtitleStyle: TextStyle(fontSize: 12, color: theme.bgLightenColor(.6, .4)),
          ),
        ),

        floatingActionButton: AddContentFAB(collection: widget.record.collection),

        body: ModifyContentsOuterSection(
          record: (
            collection: stateCollection ?? widget.record.collection,
            courseDbId: widget.record.courseDbId,
            courseTitle: widget.record.courseTitle,
          ),
        ),
      ),
    );
  }
}

class ModifyContentsOuterSection extends ConsumerWidget {
  final ContentRecord<int, CourseCollection, CourseTitleRecord> record;
  const ModifyContentsOuterSection({super.key, required this.record});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomScrollView(
      slivers: [
        ModifyContentsHeader(onSelect: () {}, onClickFilter: () {}, onSearch: () {}),
        SliverToBoxAdapter(child: ConstantSizing.columnSpacingSmall),
        if (record.collection.contents.isEmpty)
          EmptyContentsView(collection: record.collection,)
        else
          ModifyContentListView(
            collectionId: record.collection.collectionId,
            courseDbId: record.courseDbId,
            contentList: record.collection.contents.toList(),
          ),

        SliverToBoxAdapter(child: ConstantSizing.columnSpacing(context.bottomPadding)),
      ],
    );
  }
}
