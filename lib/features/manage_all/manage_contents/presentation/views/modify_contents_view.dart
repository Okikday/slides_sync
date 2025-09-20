import 'dart:collection';
import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/core/global_providers/data_providers/course_providers.dart';
import 'package:slides_sync/core/routes/routes.dart';
import 'package:slides_sync/core/utils/result.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/domain/models/course_model/course.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/views/library_tab_view/library_tab_view_app_bar/build_button.dart';
import 'package:slides_sync/features/manage_all/manage_contents/presentation/actions/modify_content_card_actions.dart';
import 'package:slides_sync/features/manage_all/manage_contents/presentation/actions/modify_contents_action.dart';
import 'package:slides_sync/features/manage_all/manage_contents/presentation/providers/modify_contents_view_providers.dart';
import 'package:slides_sync/features/manage_all/manage_contents/presentation/views/add_contents/add_content_fab.dart';
import 'package:slides_sync/features/manage_all/manage_contents/presentation/views/modify_contents/empty_contents_view.dart';
import 'package:slides_sync/features/manage_all/manage_contents/presentation/views/modify_contents/mod_content_search_view_button.dart';
import 'package:slides_sync/features/manage_all/manage_contents/presentation/views/modify_contents/modify_content_list_view.dart';
import 'package:slides_sync/features/manage_all/manage_contents/presentation/views/modify_contents/modify_contents_header.dart';
import 'package:slides_sync/features/manage_all/manage_course/presentation/providers/modify_course_providers.dart';
import 'package:slides_sync/shared/common_widgets/app_popup_menu_button.dart';
import 'package:slides_sync/shared/components/app_bar_container.dart';
import 'package:slides_sync/shared/components/dialogs/confirm_deletion_dialog.dart';
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
  late final ModifyContentsViewProviders mcvp;

  @override
  void initState() {
    super.initState();
    mcvp = ModifyContentsViewProviders.of(ref);
  }

  @override
  void dispose() {
    mcvp.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ref.listen(syncCourseProvider, syncCourseWithStorage);
    CourseCollection? stateCollection = (ref.watch(CourseProviders.courseProvider).value ?? defaultCourse).collections
        .firstWhereOrNull((e) => e.collectionId == widget.record.collection.collectionId);
    final theme = ref.theme;

    return ValueListenableBuilder(
      valueListenable: mcvp.selectedContentsNotifier,
      builder: (context, value, child) {
        return PopScope(
          canPop: value.isEmpty,
          onPopInvokedWithResult: (didPop, result) {
            if (!mcvp.isEmpty) {
              mcvp.clearContents();
            }
          },
          child: AnnotatedRegion(
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
                  trailing: ModContentSearchViewButton(
                    doBeforeTap: () {
                      mcvp.clearContents();
                    },
                  )
                ),
              ),

              floatingActionButton: AddContentFAB(collection: widget.record.collection),

              body: ModifyContentsOuterSection(
                mcvp: mcvp,
                record: (
                  collection: stateCollection ?? widget.record.collection,
                  courseDbId: widget.record.courseDbId,
                  courseTitle: widget.record.courseTitle,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class ModifyContentsOuterSection extends ConsumerWidget {
  final ContentRecord<int, CourseCollection, CourseTitleRecord> record;
  final ModifyContentsViewProviders mcvp;
  const ModifyContentsOuterSection({super.key, required this.record, required this.mcvp});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomScrollView(
      slivers: [
        //collectionLength: record.collection.contents.length
        ModifyContentsHeader(
          onDelete: () {
            UiUtils.showCustomDialog(
              context,
              child: ConfirmDeletionDialog(
                content:
                    "Are you sure you want to delete ${mcvp.selectedContentsNotifier.value.length} item(s) from \"${record.collection.collectionTitle}\".",
                onPop: () {
                  if (context.mounted) {
                    UiUtils.hideDialog(context);
                  } else {
                    rootNavigatorKey.currentContext?.pop();
                  }
                },
                onCancel: () {
                  rootNavigatorKey.currentContext?.pop();
                },
                onDelete: () async {
                  if (context.mounted) {
                    UiUtils.hideDialog(context);
                  } else {
                    rootNavigatorKey.currentContext?.pop();
                  }
                  UiUtils.showLoadingDialog(context, message: "Removing contents", canPop: false);

                  final String? outcome =
                      (await Result.tryRunAsync(() async {
                        String? outcome;
                        for (final e in mcvp.selectedContentsNotifier.value) {
                          outcome = await ModifyContentCardActions.onDeleteContent(context, e, false);
                        }
                        return outcome;
                      })).data;

                  rootNavigatorKey.currentContext?.pop();
                  if (context.mounted) {
                    if (outcome == null) {
                      UiUtils.showFlushBar(context, msg: "Successfully removed contents!", vibe: FlushbarVibe.success);
                    } else if (outcome.toLowerCase().contains("error")) {
                      UiUtils.showFlushBar(context, msg: outcome, vibe: FlushbarVibe.error);
                    } else {
                      UiUtils.showFlushBar(context, msg: outcome, vibe: FlushbarVibe.warning);
                    }
                  }
                  mcvp.clearContents();
                },
              ),
            );
          },
          mcvp: mcvp,
        ),
        SliverToBoxAdapter(child: ConstantSizing.columnSpacingMedium),
        if (record.collection.contents.isEmpty)
          EmptyContentsView(collection: record.collection)
        else
          ModifyContentListView(
            mcvp: mcvp,
            collectionId: record.collection.collectionId,
            courseDbId: record.courseDbId,
            contentList: record.collection.contents.toList(),
          ),

        SliverToBoxAdapter(child: ConstantSizing.columnSpacing(context.bottomPadding)),
      ],
    );
  }
}
