import 'dart:developer';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:slides_sync/core/models/file_location.dart';
import 'package:slides_sync/core/utils/app_navigator.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/data/models/course_model/course_model.dart';
import 'package:slides_sync/data/repos/course_repo.dart';
import 'package:slides_sync/features/modify_courses/domain/usecases/modify_course_uc/modify_course_actions.dart';
import 'package:slides_sync/features/modify_courses/presentation/notifiers/modify_course/is_plain_view_notifier.dart';
import 'package:slides_sync/features/modify_courses/presentation/views/modify_course/collections_section.dart';
import 'package:slides_sync/features/modify_courses/presentation/views/modify_course/edit_course_bottom_sheet.dart';
import 'package:slides_sync/features/modify_courses/presentation/views/modify_course/modify_course_header.dart';
import 'package:slides_sync/shared/components/app_bar_container.dart';
import 'package:slides_sync/shared/components/app_bar_container_child.dart';
import 'package:slides_sync/shared/components/dialogs/app_alert_dialog.dart';
import 'package:slides_sync/shared/styles/app_ui_context.dart';
import 'package:slides_sync/shared/styles/colors.dart';

/// VIEW
class ModifyCourseView extends ConsumerStatefulWidget {
  final CourseModel courseModel;
  const ModifyCourseView({super.key, required this.courseModel});

  @override
  ConsumerState createState() => _ModifyCourseState();
}

class _ModifyCourseState extends ConsumerState<ModifyCourseView> with TickerProviderStateMixin {
  // late final NotifierProvider<ModifyCourseModelNotifier, CourseModel> modifyCourseProvider;

  late final StateProvider<CourseModel> modifyCourseProvider;
  late final StreamProvider<CourseModel?> syncCourseProvider;

  late final PageController collectionPageController;
  late final PageController contentPageController;

  late final AsyncNotifierProvider<IsPlainViewNotifier, bool> isPlainViewProvider;

  @override
  void initState() {
    super.initState();
    modifyCourseProvider = StateProvider((ref) => widget.courseModel);
    syncCourseProvider = StreamProvider((ref) => CourseRepo.watchCourseById(widget.courseModel.id));
    collectionPageController = PageController(initialPage: 4);
    contentPageController = PageController(initialPage: 4);
    isPlainViewProvider = AsyncNotifierProvider<IsPlainViewNotifier, bool>(IsPlainViewNotifier.new);
  }

  void syncCourseWithStorage(AsyncValue<CourseModel?>? prev, AsyncValue<CourseModel?> next) {
    if (!next.hasValue) return;
    final CourseModel? currCourse = next.value;
    if (currCourse == null) return;
    ref.read(modifyCourseProvider.notifier).update((cb) => currCourse);
  }

  @override
  void dispose() {
    collectionPageController.dispose();
    contentPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(syncCourseProvider, syncCourseWithStorage);

    final CourseModel courseModel = ref.watch(modifyCourseProvider);

    final ModifyCourseActions modifyCourseActions = ModifyCourseActions();

    return AnnotatedRegion(
      value: UiUtils.getSystemUiOverlayStyle(context.scaffoldBackgroundColor, context.isDarkMode),
      child: Scaffold(
        appBar: AppBarContainer(
          appBarHeight: kToolbarHeight + 12,
          padding: EdgeInsets.zero,
          child: AppBarContainerChild(context.isDarkMode, title: 'Modify Course'),
        ),
        body: CustomScrollView(
          slivers: [
            // HEADER
            ModifyCourseHeader(
              title: courseModel.courseName,
              description: courseModel.description.trim(),
              courseCode: courseModel.courseCode.trim(),
              courseFileLocation: courseModel.imageLocationJson,
              onClickEditCourse: () async {
                await showModalBottomSheet(
                  context: context,
                  enableDrag: false,
                  showDragHandle: false,
                  backgroundColor: context.scaffoldBackgroundColor,
                  isScrollControlled: true,
                  builder: (context) => EditCourseBottomSheet(modifyCourseProvider: modifyCourseProvider),
                );
              },
              onClickDelete: () {
                CustomDialog.show(
                  context,
                  canPop: true,
                  barrierColor: Colors.black.withValues(alpha: 0.6),
                  transitionType: TransitionType.cupertinoDialog,
                  transitionDuration: Durations.medium2,
                  child: AppAlertDialog(
                    title: "Confirm deletion",
                    content: "Are you sure you want to delete this course?",
                    backgroundColor: context.isDarkMode ? SlidesRepoColors.darkBlue.withAlpha(200) : null,
                    actions: [
                      _buildDialogButton(
                        label: "Go back",
                        textColor: context.isDarkMode ? Colors.white : Colors.black,
                        backgroundColor: Colors.blueGrey.withAlpha(40),
                        onClick: () => CustomDialog.hide(context),
                      ),

                      _buildDialogButton(
                        label: "Delete",
                        textColor: Colors.red,
                        backgroundColor: Colors.red.withAlpha(40),
                        onClick: () async {
                          CustomDialog.hide(context);
                          await Future.delayed(Durations.medium1);

                          if (context.mounted) {
                            CustomDialog.showLoadingDialog(
                              context,
                              canPop: true,
                              msg: "Deleting Course",
                              barrierColor: Colors.black.withValues(alpha: 0.6),
                              transitionDuration: Durations.medium2,
                            );
                          }
                          await modifyCourseActions.onDeleteCourse(id: courseModel.id, courseId: courseModel.courseId);
                          if (context.mounted) CustomDialog.hide(context);
                          if (context.mounted) context.pop();
                        },
                      ),
                    ],
                  ),
                );
              },
              onClickAddDescription:
                  () => modifyCourseActions.onClickAddDescription(
                    context,
                    currDescription: courseModel.description,
                    modifyCourseProvider: modifyCourseProvider,
                  ),

              onClickImage: () async {
                if (!courseModel.imageLocationJson.fileLocation.containsImagePath) {
                  modifyCourseActions.pickImageActionRoute(context, courseDbId: courseModel.id);
                  return;
                }

                modifyCourseActions.onClickCourseImage(context, courseModel: courseModel);
              },

              onLongPressImage: () async {
                if (!courseModel.imageLocationJson.fileLocation.containsImagePath) {
                  modifyCourseActions.pickImageActionRoute(context, courseDbId: courseModel.id);
                  return;
                }

                modifyCourseActions.previewImageActionRoute(context, courseImagePath: courseModel.imageLocationJson);
              },
            ),

            SliverToBoxAdapter(child: ConstantSizing.columnSpacingExtraLarge),

            // BODY
            CollectionsSection(
              collections: courseModel.subCollections,
              pageController: collectionPageController,
              onClickNewCollection: () {
                AppNavigator.to(context).courseCollectionsRoute(courseModel);
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
                      AppNavigator.to(context).courseCollectionsRoute(courseModel);
                    },
                    borderRadius: 48,
                    pixelHeight: 56,
                    backgroundColor: Colors.deepPurple.withAlpha(80),
                    label: "See all materials",
                    textSize: 15,
                    textColor: Colors.deepPurple,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Dialog button
Widget _buildDialogButton({
  required String label,
  Color textColor = Colors.white,
  Color backgroundColor = Colors.deepPurple,
  required void Function() onClick,
}) {
  return CustomElevatedButton(
    label: label,
    textSize: 14,
    pixelHeight: 44,
    textColor: textColor,
    backgroundColor: backgroundColor,
    borderRadius: ConstantSizing.borderRadiusCircle,
    onClick: onClick,
  );
}
