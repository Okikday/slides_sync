import 'dart:developer';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/features/course_mgmt/data/models/course_model/course_model.dart';
import 'package:slides_sync/features/course_mgmt/data/repos/course_repo.dart';
import 'package:slides_sync/features/course_mgmt/presentation/views/create_course_view/input_course_code_field.dart';
import 'package:slides_sync/features/course_mgmt/presentation/views/create_course_view/input_course_title_field.dart';
import 'package:slides_sync/shared/components/dialogs/app_alert_dialog.dart';
import 'package:slides_sync/shared/helpers/course_formatter.dart';
import 'package:slides_sync/shared/styles/app_ui_context.dart';

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
      final formerCourseName = readCourseModel.courseName;
      final formerDescription = readCourseModel.description;
      final formerCourseCode = readCourseModel.courseCode;
      courseNameTextController.text = formerCourseName;
      if (formerCourseCode.isNotEmpty) courseCodeController.text = formerCourseCode;

      if (formerDescription.isNotEmpty) {
        descriptionTextController.text = formerDescription;
        descriptionTextController.selection = TextSelection(baseOffset: 0, extentOffset: descriptionTextController.text.length);
      }
      if (widget.isEditingDescription) descriptionFocusNode.requestFocus();
    });
  }

  // Check if can update course
  String? checkIfCanUpdateCourse() {
    final courseName = courseNameTextController.text;
    final courseCode = courseCodeController.text;
    final description = descriptionTextController.text;
    final isVisible = ref.watch(isCourseCodeFieldVisible);
    if (courseName.isEmpty || courseName.length < 2 || courseName.length > 64 || double.tryParse(courseName) != null) {
      if (courseName.isEmpty) return "Kindly fill the course title field!";
      if (courseName.length < 2) return "Course title too short!";
      if (courseName.length > 64) return "Course title too long!";
      return "Kindly input a valid course title!";
    } else if (isVisible && (courseCode.length < 2 || courseCode.length > 12)) {
      return "Kindly input a valid course code or hide it";
    } else if (description.length > 1024) {
      return "Kindly input a valid description!";
    }
    return null;
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
          barrierColor: context.isDarkMode ? Colors.white10 : Colors.black.withValues(alpha: 0.7),
          transitionType: TransitionType.cupertinoDialog,
          blurSigma: Offset(3.0, 3.0),
          transitionDuration: Durations.medium2,
          loadingInfoWidget: AppAlertDialog(
            title: "Confirm exit",
            content: "Are you sure you want to exit without saving?",
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

                                SliverToBoxAdapter(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    spacing: 6.0,
                                    children: [
                                      CustomText("Description", fontSize: 13),
                                      SizedBox(
                                        width: context.deviceWidth,
                                        child: CustomTextfield(
                                          ontap: () {
                                            final descriptionText = descriptionTextController.text;
                                            if (descriptionText == courseModel.description) {
                                              descriptionTextController.selection = TextSelection(
                                                baseOffset: 0,
                                                extentOffset: descriptionText.length,
                                              );
                                            }
                                          },
                                          onchanged: (text) {},
                                          // onTapOutside: () {},
                                          focusNode: widget.isEditingDescription ? descriptionFocusNode : null,
                                          controller: descriptionTextController,
                                          backgroundColor: Colors.grey.withAlpha(40),
                                          cursorColor: CustomText("").effectiveStyle(context).color ?? Colors.white,
                                          maxLength: 1024,
                                          counterText: null,
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8.0),
                                            borderSide: BorderSide(
                                              color:
                                                  context.isDarkMode
                                                      ? Colors.lightBlueAccent.withAlpha(80)
                                                      : Colors.deepPurple.withAlpha(40),
                                            ),
                                          ),
                                          pixelWidth: context.deviceWidth,
                                          minLines: 3,
                                          maxLines: 6,
                                          inputContentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                          hint: "Enter new description",
                                          inputTextStyle: CustomText("", fontSize: 16).effectiveStyle(context),
                                        ),
                                      ),
                                    ],
                                  ),
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
                            final String? errorMsg = checkIfCanUpdateCourse();
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
