import 'dart:developer';
import 'dart:ui';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:slides_sync/core/usecases/app_navigator.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/features/course_mgmt/data/models/course_model/course_model.dart';
import 'package:slides_sync/features/course_mgmt/data/repos/course_repo.dart';
import 'package:slides_sync/features/course_mgmt/presentation/viewmodels/notifiers/modify_course/is_plain_view_notifier.dart';
import 'package:slides_sync/features/course_mgmt/presentation/views/modify_course/collections_section.dart';
import 'package:slides_sync/features/course_mgmt/presentation/views/modify_course/course_description_dialog.dart';
import 'package:slides_sync/features/course_mgmt/presentation/views/modify_course/edit_course_bottom_sheet.dart';
import 'package:slides_sync/features/course_mgmt/presentation/views/modify_course/modify_course_header.dart';
import 'package:slides_sync/shared/components/app_bar_container.dart';
import 'package:slides_sync/shared/components/app_bar_container_child.dart';
import 'package:slides_sync/shared/components/dialogs/app_alert_dialog.dart';
import 'package:slides_sync/shared/styles/app_ui_context.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) => ref.read(modifyCourseProvider.notifier).update((cb) => currCourse));
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
            ModifyCourseHeader(
              title: courseModel.courseName,
              description: courseModel.description.trim(),
              courseCode: courseModel.courseCode.trim(),
              courseImagePath: courseModel.imagePath,
              onClickEditCourse: () async {
                await showModalBottomSheet(
                  context: context,
                  enableDrag: false,
                  showDragHandle: false,
                  backgroundColor: context.scaffoldBackgroundColor,
                  isScrollControlled: true,
                  builder: (context) => EditCourseBottomSheet(modifyCourseProvider: modifyCourseProvider),
                ).then((_) {
                  log("Closed Bottom sheet");
                });
              },
              onClickDelete: () {
                LoadingDialog.showLoadingDialog(
                  context,
                  canPop: true,
                  barrierColor: Colors.black.withValues(alpha: 0.6),
                  transitionType: TransitionType.cupertinoDialog,
                  transitionDuration: Durations.medium2,
                  loadingInfoWidget: AppAlertDialog(
                    title: "Confirm deletion",
                    content: "Are you sure you want to delete this course?",
                    actions: [
                      CustomElevatedButton(
                        label: "Go back",
                        textSize: 14,
                        pixelHeight: 44,
                        textColor: Colors.white,
                        backgroundColor: Colors.white.withAlpha(40),
                        borderRadius: ConstantSizing.borderRadiusCircle,
                        onClick: () => LoadingDialog.hideLoadingDialog(context),
                      ),

                      CustomElevatedButton(
                        label: "Delete",
                        textSize: 14,
                        pixelHeight: 44,
                        textColor: Colors.red,
                        backgroundColor: Colors.red.withAlpha(40),
                        borderRadius: ConstantSizing.borderRadiusCircle,
                        onClick: () async {
                          LoadingDialog.hideLoadingDialog(context);
                          await Future.delayed(Durations.medium1);

                          if (context.mounted) {
                            LoadingDialog.showLoadingDialog(
                              context,
                              canPop: true,
                              msg: "Deleting Course",
                              barrierColor: Colors.black.withValues(alpha: 0.6),
                              transitionDuration: Durations.medium2,
                            );
                          }
                          await CourseRepo.deleteCourse(courseModel.id);
                          if (context.mounted) LoadingDialog.hideLoadingDialog(context);
                          if (context.mounted) context.pop();
                        },
                      ),
                    ],
                  ),
                );
              },
              onClickAddDescription: () {
                if (courseModel.description.isNotEmpty) {
                  LoadingDialog.showLoadingDialog(
                    context,
                    canPop: true,
                    reverseTransitionDuration: Durations.short4,
                    transitionType: TransitionType.cupertinoDialog,
                    curve: CustomCurves.defaultIosSpring,
                    barrierColor: Colors.black54,
                    loadingInfoWidget: CourseDescriptionDialog(
                      description: courseModel.description,
                    ).animate().scale(begin: Offset(0.5, 0.5), duration: Durations.extralong1, curve: CustomCurves.bouncySpring),
                  );
                } else {
                  showModalBottomSheet(
                    context: context,
                    enableDrag: false,
                    showDragHandle: false,
                    backgroundColor: context.scaffoldBackgroundColor,
                    barrierColor: Colors.black54,
                    isScrollControlled: true,
                    builder: (context) {
                      return EditCourseBottomSheet(modifyCourseProvider: modifyCourseProvider, isEditingDescription: true);
                    },
                  ).then((_) {
                    log("Closed Bottom sheet");
                  });
                }
              },
            ),

            SliverToBoxAdapter(child: ConstantSizing.columnSpacingExtraLarge),

            CollectionsSection(
              collections: courseModel.subCollections,
              pageController: collectionPageController,
              onClickNewCollection: () {
                AppNavigator.to(context).courseCollectionsRoute(courseModel);
              },
            ),

            SliverToBoxAdapter(child: ConstantSizing.columnSpacingMedium),

            if (courseModel.subCollections.isNotEmpty)
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                sliver: SliverToBoxAdapter(
                  child: CustomElevatedButton(
                    onClick: () {},
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
