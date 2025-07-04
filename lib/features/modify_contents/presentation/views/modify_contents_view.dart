import 'package:collection/collection.dart';
import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/core/utils/result.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/data/models/course_model/course_model.dart';
import 'package:slides_sync/data/repos/course_repo.dart';
import 'package:slides_sync/features/modify_contents/presentation/views/modify_contents/add_contents_fab.dart';
import 'package:slides_sync/features/modify_contents/presentation/views/modify_contents/modify_content_list_view.dart';
import 'package:slides_sync/features/modify_contents/presentation/views/modify_contents/modify_contents_header.dart';
import 'package:slides_sync/features/modify_courses/presentation/viewmodels/modify_course_providers.dart';
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
  final StateProvider<CourseModel> modifyCourseProvider = ModifyCourseProviders.modifyCourseProvider;
  final StreamProvider<CourseModel?> syncCourseProvider = ModifyCourseProviders.syncCourseProvider;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final modifyCourseNotifier = ref.read(modifyCourseProvider.notifier);
      final CourseModel? course = await CourseRepo.getCourseByDbId(widget.record.courseDbId);
      if (course == null) return;
      if (modifyCourseNotifier.state.lastUpdated != course.lastUpdated) {
        modifyCourseNotifier.update((ref) => course);
      }
    });
    ModifyCourseProviders.setSyncCourseProvider(StreamProvider((ref) => CourseRepo.watchCourseByDbId(widget.record.courseDbId)));
  }

  void syncCourseWithStorage(AsyncValue<CourseModel?>? prev, AsyncValue<CourseModel?> next) {
    if (!next.hasValue) return;
    final CourseModel? currCourse = next.value;
    if (currCourse == null) return;
    ref.read(modifyCourseProvider.notifier).update((cb) => currCourse);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(syncCourseProvider, syncCourseWithStorage);
    CourseSubCollection? stateCollection = ref
        .watch(modifyCourseProvider)
        .subCollections
        .firstWhereOrNull((e) => e.collectionId == widget.record.collection.collectionId);
    if (stateCollection == null) {
      Result.tryRun(() => Navigator.pop(context));
    }
    stateCollection ??= CourseSubCollection.create(collectionTitle: "Default Collection", parentId: "parentId");

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
            subtitleStyle: TextStyle(fontSize: 12, color: Colors.lightBlueAccent.withAlpha(150)),
          ),
        ),

        floatingActionButton: AddContentsFAB(collection: widget.record.collection),

        body: ModifyContentsOuterSection(collection: stateCollection),
      ),
    );
  }
}

class ModifyContentsOuterSection extends ConsumerWidget {
  final CourseSubCollection collection;
  const ModifyContentsOuterSection({super.key, required this.collection});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomScrollView(
      slivers: [
        ModifyContentsHeader(),
        SliverToBoxAdapter(child: ConstantSizing.columnSpacingSmall),
        ModifyContentListView(contentList: collection.courseContents),

        SliverToBoxAdapter(child: ConstantSizing.columnSpacing(context.bottomPadding)),
      ],
    );
  }
}
