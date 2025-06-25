
import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/data/models/course_model/course_model.dart';
import 'package:slides_sync/features/modify_contents/presentation/views/modify_contents/add_contents_fab.dart';
import 'package:slides_sync/features/modify_contents/presentation/views/modify_contents/modify_content_list_view.dart';
import 'package:slides_sync/features/modify_contents/presentation/views/modify_contents/modify_contents_header.dart';
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
  Widget build(BuildContext context) {
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

        floatingActionButton: AddContentsFAB(),

        body: ModifyContentsOuterSection(),
      ),
    );
  }
}

class ModifyContentsOuterSection extends ConsumerWidget {
  const ModifyContentsOuterSection({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomScrollView(
      slivers: [
        ModifyContentsHeader(),
        SliverToBoxAdapter(child: ConstantSizing.columnSpacingSmall),
        ModifyContentListView(),
    
        SliverToBoxAdapter(child: ConstantSizing.columnSpacing(context.bottomPadding)),
      ],
    );
  }
}
