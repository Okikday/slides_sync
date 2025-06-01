import 'dart:developer';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/features/course_mgmt/data/models/course_model/course_model.dart';
import 'package:slides_sync/features/course_mgmt/data/repos/course_repo.dart';
import 'package:slides_sync/features/course_mgmt/domain/usecases/modify_course_actions.dart';
import 'package:slides_sync/features/course_mgmt/presentation/views/create_course_view/input_course_code_field.dart';
import 'package:slides_sync/features/course_mgmt/presentation/views/create_course_view/input_course_title_field.dart';
import 'package:slides_sync/features/course_mgmt/presentation/views/modify_course/edit_course_bottom_sheet/edit_course_input_description_field.dart';
import 'package:slides_sync/shared/components/dialogs/app_alert_dialog.dart';
import 'package:slides_sync/shared/helpers/course_formatter.dart';
import 'package:slides_sync/shared/styles/app_ui_context.dart';
import 'package:slides_sync/shared/styles/colors.dart';

class EditCourseBottomSheet extends ConsumerStatefulWidget {
  final StateProvider<CourseModel> modifyCourseProvider;
  final bool isEditingDescription;
  const EditCourseBottomSheet({super.key, required this.modifyCourseProvider, this.isEditingDescription = false});

  @override
  ConsumerState createState() => _EditCourseBottomSheetState();
}

class _EditCourseBottomSheetState extends ConsumerState<EditCourseBottomSheet> {
  late final TextEditingController courseNameTextController;
  late final TextEditingController courseCodeController;
  late final TextEditingController descriptionTextController;
  late final StateProvider<bool> canExitProvider;
  late final FocusNode descriptionFocusNode;
  late final StateProvider<bool> isCourseCodeFieldVisible;

  @override
  void initState() {
    super.initState();
    canExitProvider = StateProvider<bool>((ref) => false);
    courseNameTextController = TextEditingController();
    descriptionTextController = TextEditingController();
    courseCodeController = TextEditingController();
    isCourseCodeFieldVisible = StateProvider((ref) => false);
    if (widget.isEditingDescription) {
      descriptionFocusNode = FocusNode();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final readCourseModel = ref.watch(widget.modifyCourseProvider);
      courseNameTextController.text = readCourseModel.courseName;
      if (readCourseModel.courseCode.isNotEmpty) courseCodeController.text = readCourseModel.courseCode;

      if (readCourseModel.description.isNotEmpty) {
        descriptionTextController.text = readCourseModel.description;
        descriptionTextController.selection = TextSelection(baseOffset: 0, extentOffset: descriptionTextController.text.length);
      }
      if (widget.isEditingDescription) descriptionFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final CourseModel courseModel = ref.watch(widget.modifyCourseProvider);

    final double bottomPadding = MediaQuery.paddingOf(context).bottom;
    final double keyboardInsets = double.parse((context.viewInsets.bottom / context.deviceHeight).toStringAsFixed(2)).clamp(0.0, 0.25);

    // CupertinoContextMenu(actions: actions, child: child)

    return PopScope(
      canPop: ref.watch(canExitProvider),
      onPopInvokedWithResult: (_, __) {
        if (ref.watch(canExitProvider)) {
          return;
        }

        LoadingDialog.showLoadingDialog(
          context,
          barrierColor: Colors.black.withValues(alpha: 0.7),
          transitionType: TransitionType.cupertinoDialog,
          blurSigma: Offset(2.0, 2.0),
          transitionDuration: Durations.medium2,
          loadingInfoWidget: AppAlertDialog(
            title: "Confirm exit",
            content: "Are you sure you want to exit without saving?",
            backgroundColor: context.isDarkMode ? SlidesRepoColors.darkBlue.withAlpha(200) : null,
            onCancel: () {
              LoadingDialog.hideLoadingDialog(context);
            },
            onConfirm: () async {
              LoadingDialog.hideLoadingDialog(context);

              ref.read(canExitProvider.notifier).update((cb) => true);
              Navigator.pop(context);
            },
          ),
        );
      },

      child: AnimatedSize(
        duration: Durations.extralong1,
        curve: CustomCurves.defaultIosSpring,
        child: DraggableScrollableSheet(
          maxChildSize: 1.0,
          initialChildSize: 0.65 + keyboardInsets,
          expand: false,
          snapSizes: [],
          builder: (context, scrollController) {
            return ClipRRect(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
              child: ColoredBox(
                color: context.scaffoldBackgroundColor,
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Container(
                          clipBehavior: Clip.hardEdge,
                          margin: EdgeInsets.symmetric(vertical: 20.0),
                          decoration: BoxDecoration(
                            color: context.isDarkMode ? Colors.blueGrey : Colors.grey,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          height: 4,
                          width: 48,
                        ),

                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: CustomScrollView(
                              slivers: [
                                PinnedHeaderSliver(
                                  child: ColoredBox(
                                    color: context.scaffoldBackgroundColor,
                                    child: CustomText("Edit Course", fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                ),

                                SliverToBoxAdapter(child: ConstantSizing.columnSpacingMedium),

                                SliverToBoxAdapter(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    spacing: 6.0,
                                    children: [
                                      CustomText("Course title", fontSize: 13),
                                      InputCourseTitleField(
                                        courseNameController: courseNameTextController,
                                        isCourseCodeFieldVisible: isCourseCodeFieldVisible,
                                      ),

                                      InputCourseCodeField(
                                        courseCodeController: courseCodeController,
                                        isCourseCodeFieldVisible: isCourseCodeFieldVisible,
                                      ),
                                    ],
                                  ),
                                ),

                                SliverToBoxAdapter(child: ConstantSizing.columnSpacingLarge),

                                EditCourseInputDescriptionField(
                                  descriptionTextController: descriptionTextController,
                                  courseModel: courseModel,
                                  descriptionFocusNode: widget.isEditingDescription ? descriptionFocusNode : null,
                                ),

                                SliverToBoxAdapter(
                                  child: AnimatedSize(
                                    duration: Durations.extralong1,
                                    curve: CustomCurves.defaultIosSpring,
                                    child: ConstantSizing.columnSpacing(context.viewInsets.bottom + bottomPadding + 48),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    AnimatedPositioned(
                      duration: Durations.extralong1,
                      curve: CustomCurves.defaultIosSpring,
                      bottom: bottomPadding + context.viewInsets.bottom + 4.0,
                      left: context.viewInsets.bottom > 20 ? null : 0,
                      right: 0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: CustomElevatedButton(
                          onClick: () async {
                            final String? errorMsg = ModifyCourseActions.checkIfCanUpdateCourse(
                              courseName: courseNameTextController.text,
                              courseCode: courseCodeController.text,
                              description: descriptionTextController.text,
                              isVisible: ref.watch(isCourseCodeFieldVisible),
                            );
                            if (errorMsg != null) {
                              log("Cant update");
                              UiUtils.showFlushBar(context, msg: errorMsg, flushbarPosition: FlushbarPosition.TOP);
                              return;
                            }
                            final currCourseModel = ref.watch(widget.modifyCourseProvider);
                            final description = descriptionTextController.text;
                            final String courseTitle = CourseFormatter.joinCodeToTitle(
                              courseCodeController.text,
                              courseNameTextController.text,
                            );
                            final CourseModel updatedCourseModel = currCourseModel.copyWith(
                              courseTitle: courseTitle,
                              description: description,
                            );
                            ref.read(widget.modifyCourseProvider.notifier).update((ref) => updatedCourseModel);
                            await CourseRepo.addCourse(updatedCourseModel);
                            ref.read(canExitProvider.notifier).update((cb) => true);
                            if (context.mounted) Navigator.pop(context);
                          },
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          label: "Update details",
                          textColor: Colors.white,
                          textSize: 15,
                          pixelHeight: 48,
                          backgroundColor: Colors.deepPurple,
                          borderRadius: 48,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}


