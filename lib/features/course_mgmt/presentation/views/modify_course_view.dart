import 'dart:developer';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:slides_sync/core/models/image_location.dart';
import 'package:slides_sync/core/usecases/app_navigator.dart';
import 'package:slides_sync/core/utils/file_utils.dart';
import 'package:slides_sync/core/utils/result.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/features/course_mgmt/data/models/course_model/course_model.dart';
import 'package:slides_sync/features/course_mgmt/data/repos/course_repo.dart';
import 'package:slides_sync/features/course_mgmt/domain/usecases/create_course_action.dart';
import 'package:slides_sync/features/course_mgmt/domain/usecases/modify_course_actions.dart';
import 'package:slides_sync/features/course_mgmt/presentation/viewmodels/notifiers/modify_course/is_plain_view_notifier.dart';
import 'package:slides_sync/features/course_mgmt/presentation/views/modify_course/collections_section.dart';
import 'package:slides_sync/features/course_mgmt/presentation/views/modify_course/course_description_dialog.dart';
import 'package:slides_sync/features/course_mgmt/presentation/views/modify_course/edit_course_bottom_sheet.dart';
import 'package:slides_sync/features/course_mgmt/presentation/views/modify_course/modify_course_header.dart';
import 'package:slides_sync/shared/components/app_bar_container.dart';
import 'package:slides_sync/shared/components/app_bar_container_child.dart';
import 'package:slides_sync/shared/components/dialogs/app_alert_dialog.dart';
import 'package:slides_sync/shared/components/dialogs/app_customizable_dialog.dart';
import 'package:slides_sync/shared/helpers/widget_helper.dart';
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
            // HEADER
            ModifyCourseHeader(
              title: courseModel.courseName,
              description: courseModel.description.trim(),
              courseCode: courseModel.courseCode.trim(),
              courseImageLocation: courseModel.imageLocation,
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
                    backgroundColor: context.isDarkMode ? SlidesRepoColors.darkBlue.withAlpha(200) : null,
                    actions: [
                      _buildDialogButton(
                        label: "Go back",
                        textColor: context.isDarkMode ? Colors.white : Colors.black,
                        backgroundColor: Colors.blueGrey.withAlpha(40),
                        onClick: () => LoadingDialog.hideLoadingDialog(context),
                      ),

                      _buildDialogButton(
                        label: "Delete",
                        textColor: Colors.red,
                        backgroundColor: Colors.red.withAlpha(40),
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
                          await ModifyCourseActions.onDeleteCourse(id: courseModel.id, courseId: courseModel.courseId);
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

              onClickImage: () async {

                // Show image in a Dialog
                LoadingDialog.showLoadingDialog(
                  context,
                  msg: "Selecting image...",
                  backgroundColor: context.scaffoldBackgroundColor.withAlpha(200),
                  transitionDuration: Durations.short3,
                  reverseTransitionDuration: Durations.short4,
                  canPop: true,
                  barrierColor: Colors.black.withAlpha(200),
                  loadingInfoWidget: ColoredBox(
                    color: Colors.yellow,
                    child: SizedBox(
                      height: context.deviceHeight,
                      width: context.deviceWidth,
                      child: InteractiveViewer(
                        constrained: false,
                        alignment: Alignment.center,
                        child: WidgetHelper.resolveImageWidget(
                          courseModel.imageLocation.imageLocation,
                          fallbackWidget: Icon(Iconsax.document, color: context.isDarkMode ? Colors.deepPurpleAccent : Colors.deepPurple),
                        ),
                      ),
                    ),
                  )
                );

                // ImagePicker imagePicker = ImagePicker();
                // final XFile? pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);
                // if (context.mounted) LoadingDialog.hideLoadingDialog(context);
                // if (pickedImage == null) {
                //   if (context.mounted) UiUtils.showFlushBar(context, msg: "Oops, You didn't select an image!", vibe: FlushbarVibe.warning);
                //   return;
                // }

                // final Result result = await ModifyCourseActions.modifyCourseImageAction(
                //   id: courseModel.id,
                //   newImageFile: File(pickedImage.path),
                // );

                // if (context.mounted) {
                //   LoadingDialog.hideLoadingDialog(context);
                //   if (result.isSuccess) {
                //     UiUtils.showFlushBar(context, msg: "Successfully changed course Image!", vibe: FlushbarVibe.success);
                //   } else {
                //     UiUtils.showFlushBar(context, msg: "Unable to change course Image!", vibe: FlushbarVibe.error);
                //   }
                // }
              },

              onEditImage: (){
                LoadingDialog.showLoadingDialog(
                  context,
                  msg: "Selecting image...",
                  backgroundColor: context.scaffoldBackgroundColor.withAlpha(200),
                  barrierColor: Colors.black.withAlpha(200),
                  loadingInfoWidget: AppCustomizableDialog(
                    title: "What would you like to do?",
                    vActions: [
                      ConstantSizing.columnSpacingSmall,

                      Row(spacing: 8.0, children: [Icon(Iconsax.camera, size: 24), Expanded(child: CustomText("View Image"))]),

                      Divider(color: context.isDarkMode ? Colors.lightBlue.withAlpha(40) : Colors.grey.withAlpha(40)),

                      ConstantSizing.columnSpacingSmall,

                      Row(spacing: 8.0, children: [Icon(Iconsax.camera, size: 24), Expanded(child: CustomText("Edit Image"))]),

                      // Divider(color: context.isDarkMode ? Colors.lightBlue.withAlpha(40) : Colors.grey.withAlpha(40)),
                    ],
                  ),
                );
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
