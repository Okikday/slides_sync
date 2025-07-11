import 'dart:developer';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:slides_sync/core/models/file_details.dart';
import 'package:slides_sync/core/utils/app_navigator.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/data/models/course_model/course_model.dart';
import 'package:slides_sync/data/repos/course_repo.dart';
import 'package:slides_sync/features/modify_all/modify_courses/domain/usecases/modify_course_uc/modify_course_actions.dart';
import 'package:slides_sync/features/modify_all/modify_collections/presentation/views/modify_collections/create_collection_bottom_sheet.dart';
import 'package:slides_sync/features/modify_all/modify_courses/presentation/providers/modify_course_providers.dart';
import 'package:slides_sync/features/modify_all/modify_courses/presentation/views/modify_course/collections_section.dart';
import 'package:slides_sync/features/modify_all/modify_courses/presentation/views/modify_course/edit_course_bottom_sheet.dart';
import 'package:slides_sync/features/modify_all/modify_courses/presentation/views/modify_course/modify_course_header.dart';
import 'package:slides_sync/features/modify_all/modify_courses/presentation/views/select_to_modify_course_view.dart';
import 'package:slides_sync/shared/components/app_bar_container.dart';
import 'package:slides_sync/shared/components/app_bar_container_child.dart';
import 'package:slides_sync/shared/components/dialogs/confirm_deletion_dialog.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

/// VIEW
class ModifyCourseView extends ConsumerStatefulWidget {
  final CourseModel courseModel;
  const ModifyCourseView({super.key, required this.courseModel});

  @override
  ConsumerState createState() => _ModifyCourseState();
}

class _ModifyCourseState extends ConsumerState<ModifyCourseView> with TickerProviderStateMixin {
  late final ValueNotifier<bool> canPopNotifier;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final modifyCourseNotifier = ref.read(ModifyCourseProviders.modifyCourseProvider.notifier);
      if (modifyCourseNotifier.value != widget.courseModel) {
        modifyCourseNotifier.update(widget.courseModel);
      }
    });

    canPopNotifier = ValueNotifier(true);
  }

  @override
  void dispose() {
    canPopNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          await Future.delayed(Duration.zero);
          if (context.mounted) {
            AppNavigator.to(context).modifyExistingCoursesRoute();
          }
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
              title: 'Modify Course',
              // onBackButtonClicked: () async {
              //   context.pop();
              // },
            ),
          ),
          body: ModifyCourseViewOuterSection(),
        ),
      ),
    );
  }
}

class ModifyCourseViewOuterSection extends ConsumerWidget {
  const ModifyCourseViewOuterSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final CourseModel courseModel = ref.watch(ModifyCourseProviders.modifyCourseProvider);
    final ModifyCourseActions modifyCourseActions = ModifyCourseActions();
    return CustomScrollView(
      slivers: [
        // HEADER
        ModifyCourseHeader(
          title: courseModel.courseName,
          description: courseModel.description.trim(),
          courseCode: courseModel.courseCode.trim(),
          courseFileDetails: courseModel.imageLocationJson,
          onClickEditCourse: () async {
            await showModalBottomSheet(
              context: context,
              enableDrag: false,
              showDragHandle: false,
              backgroundColor: context.scaffoldBackgroundColor,
              isScrollControlled: true,
              builder: (context) => EditCourseBottomSheet(),
            );
          },
          onClickDelete: () {
            UiUtils.showCustomDialog(
              context,
              child: ConfirmDeletionDialog(
                content: "Deleting this course will delete it's collections and contents",
                onDelete: () async {
                  CustomDialog.hide(context);
                  await Future.delayed(Durations.medium1);

                  if (context.mounted) {
                    UiUtils.showLoadingDialog(context, message: "Deleting course...");
                  }
                  await modifyCourseActions.onDeleteCourse(id: courseModel.id, courseId: courseModel.courseId);
                  if (context.mounted) CustomDialog.hide(context);
                  if (context.mounted) context.pop();
                  if (context.mounted) UiUtils.showFlushBar(context, msg: "Successfully deleted course");
                },
              ),
            );
          },
          onClickAddDescription: () => modifyCourseActions.onClickAddDescription(context, currDescription: courseModel.description),

          onClickImage: () async {
            if (!courseModel.imageLocationJson.fileDetails.containsFilePath) {
              modifyCourseActions.pickImageActionRoute(context, courseDbId: courseModel.id);
              return;
            }

            modifyCourseActions.onClickCourseImage(context, courseModel: courseModel);
          },

          onLongPressImage: () async {
            if (!courseModel.imageLocationJson.fileDetails.containsFilePath) {
              modifyCourseActions.pickImageActionRoute(context, courseDbId: courseModel.id);
              return;
            }

            modifyCourseActions.previewImageActionRoute(context, courseImagePath: courseModel.imageLocationJson);
          },
        ),

        SliverToBoxAdapter(child: ConstantSizing.columnSpacingExtraLarge),

        // BODY
        CollectionsSection(
          courseDbId: courseModel.id,
          collections: courseModel.subCollections,
          onClickNewCollection: () {
            if (courseModel.subCollections.isEmpty) {
              CustomDialog.show(
                context,
                canPop: true,
                barrierColor: Colors.black.withAlpha(150),
                child: CreateCollectionBottomSheet(courseDbId: courseModel.id),
              ).then((value) {
                if (courseModel.subCollections.isNotEmpty) {
                  if (context.mounted) AppNavigator.to(context).modifyCollectionsRoute(courseModel);
                }
              });
              return;
            }
            AppNavigator.to(context).modifyCollectionsRoute(courseModel);
          },
        ),

        SliverToBoxAdapter(child: ConstantSizing.columnSpacingMedium),

        // AFTER
        if (courseModel.subCollections.isNotEmpty)
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            sliver: SliverToBoxAdapter(
              child: CustomElevatedButton(
                onClick: () {
                  AppNavigator.to(context).modifyCollectionsRoute(courseModel);
                },
                borderRadius: 48,
                pixelHeight: 56,
                backgroundColor: context.theme.colorScheme.outlineVariant,
                label: "See all collections",
                textSize: 15,
                textColor: context.theme.colorScheme.outline,
              ),
            ),
          ),
      ],
    );
  }
}
