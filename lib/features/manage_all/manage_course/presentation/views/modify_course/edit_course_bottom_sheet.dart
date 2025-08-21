import 'package:flutter/material.dart';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/domain/models/course_model/course.dart';
import 'package:slides_sync/features/manage_all/manage_course/usecases/actions/edit_course_actions.dart';
import 'package:slides_sync/features/manage_all/manage_course/presentation/views/create_course/input_course_code_field.dart';
import 'package:slides_sync/features/manage_all/manage_course/presentation/views/create_course/input_course_title_field.dart';
import 'package:slides_sync/features/manage_all/manage_course/presentation/viewmodels/modify_course_providers.dart';
import 'package:slides_sync/features/manage_all/manage_course/presentation/views/modify_course/edit_course_bottom_sheet/edit_course_input_description_field.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

class EditCourseBottomSheet extends ConsumerStatefulWidget {
  final bool isEditingDescription;
  const EditCourseBottomSheet({super.key, this.isEditingDescription = false});

  @override
  ConsumerState createState() => _EditCourseBottomSheetState();
}

class _EditCourseBottomSheetState extends ConsumerState<EditCourseBottomSheet> {
  late final TextEditingController courseNameTextController;
  late final TextEditingController courseCodeController;
  late final TextEditingController descriptionTextController;
  late final AutoDisposeStateProvider<bool> canExitProvider;
  late final FocusNode descriptionFocusNode;
  late final AutoDisposeStateProvider<bool> isCourseCodeFieldVisible;

  @override
  void initState() {
    super.initState();
    canExitProvider = AutoDisposeStateProvider<bool>((ref) => false);
    courseNameTextController = TextEditingController();
    descriptionTextController = TextEditingController();
    courseCodeController = TextEditingController();
    isCourseCodeFieldVisible = AutoDisposeStateProvider((ref) => false);
    if (widget.isEditingDescription) {
      descriptionFocusNode = FocusNode();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => initPostFrame());
  }

  void initPostFrame() {
    final readCourse = ref.watch(ModifyCourseProviders.modifyCourseProvider);
    courseNameTextController.text = readCourse.courseName;
    if (readCourse.courseCode.isNotEmpty) courseCodeController.text = readCourse.courseCode;

    if (readCourse.description.isNotEmpty) {
      descriptionTextController.text = readCourse.description;
      descriptionTextController.selection = TextSelection(baseOffset: 0, extentOffset: descriptionTextController.text.length);
    }
    if (widget.isEditingDescription) descriptionFocusNode.requestFocus();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Course course = ref.watch(ModifyCourseProviders.modifyCourseProvider);
    final editCourseActions = EditCourseActions();

    final double bottomPadding = MediaQuery.paddingOf(context).bottom;
    final double keyboardInsets = double.parse((context.viewInsets.bottom / context.deviceHeight).toStringAsFixed(2)).clamp(0.0, 0.25);

    // CupertinoContextMenu(actions: actions, child: child)

    return PopScope(
      canPop: ref.watch(canExitProvider),
      onPopInvokedWithResult: (_, __) => editCourseActions.onPopInvokedWithResult(context, ref.read(canExitProvider.notifier)),

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
                                    child: CustomText(
                                      "Edit course",
                                      fontSize: 18,
                                      color: ref.theme.primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                                SliverToBoxAdapter(child: ConstantSizing.columnSpacingMedium),

                                SliverToBoxAdapter(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    spacing: 6.0,
                                    children: [
                                      CustomText(
                                        "course title",
                                        fontSize: 13,
                                        color: ref.theme.primaryText,
                                      ),
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
                                  course: course,
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
                          onClick:
                              () async {
                                final ModifyCourseNotifier modifyCourseNotifier = ref.read(ModifyCourseProviders.modifyCourseProvider.notifier);
                                editCourseActions.onUpdateDetails(
                                context,
                                courseName: courseNameTextController.text,
                                courseCode: courseCodeController.text,
                                description: descriptionTextController.text,
                                isCourseCodeFieldVisible: ref.read(isCourseCodeFieldVisible.notifier).state,
                                canExitProvider: ref.read(canExitProvider.notifier),
                                modifyCourseProvider: modifyCourseNotifier,
                              );
                              },
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          label: "Update details",
                          textColor: ref.theme.primaryText,
                          textSize: 15,
                          pixelHeight: 48,
                          backgroundColor: context.theme.colorScheme.primary,
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
