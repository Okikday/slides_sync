import 'dart:developer';
import 'package:flutter/material.dart';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/core/utils/app_ui_state.dart';
import 'package:slides_sync/shared/models/course_model/course_model.dart';

import '../../../../viewmodels/notifiers/modify_course/modify_course_model_notifier.dart';

class EditCourseBottomSheet extends ConsumerStatefulWidget {
  final NotifierProvider<ModifyCourseModelNotifier, CourseModel> modifyCourseProvider;
  const EditCourseBottomSheet({super.key, required this.modifyCourseProvider});

  @override
  ConsumerState createState() => _EditCourseBottomSheetState();
}

class _EditCourseBottomSheetState extends ConsumerState<EditCourseBottomSheet> {
  late final TextEditingController descriptionTextController;
  @override
  void initState() {
    super.initState();
    descriptionTextController = TextEditingController();
  }
  @override
  Widget build(BuildContext context) {
    final AppUiModel appUiModel = ref.watch(appUiStateProvider);
    final CourseModel courseModel = ref.watch(widget.modifyCourseProvider);
    final Color scaffoldBgColor = Theme.of(context).scaffoldBackgroundColor;
    final double bottomPadding = MediaQuery.paddingOf(context).bottom;
    final double keyboardInsets = double.parse(
      (appUiModel.viewInsets.bottom / appUiModel.deviceHeight).toStringAsFixed(2),
    ).clamp(0.0, 0.25);

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (_, __) {
        log("User popped");
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
                color: scaffoldBgColor,
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Container(
                          clipBehavior: Clip.hardEdge,
                          margin: EdgeInsets.symmetric(vertical: 20.0),
                          decoration: BoxDecoration(
                            color: appUiModel.isDarkMode ? Colors.blueGrey : Colors.grey,
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
                                SliverToBoxAdapter(
                                  child: GestureDetector(
                                    onTap: (){

                                    },
                                    child: CustomRichText(
                                      children: [
                                        CustomTextSpanData(
                                          courseModel.courseTitle,
                                          fontWeight: FontWeight.bold,
                                          fontSize: ConstantSizing.fontSizeExtraLarge,
                                        ),
                                        CustomTextSpanData(
                                          " edit",
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Colors.blue,
                                          textDecoration: TextDecoration.underline,
                                          decorationColor: Colors.blue,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                SliverToBoxAdapter(child: ConstantSizing.columnSpacingLarge),

                                SliverToBoxAdapter(
                                  child: SizedBox(
                                    width: appUiModel.deviceWidth,
                                    child: CustomTextfield(
                                      onTapOutside: (){},
                                      controller: descriptionTextController,
                                      backgroundColor: Colors.grey.withAlpha(40),
                                      cursorColor: CustomText("").effectiveStyle(context).color ?? Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8.0),
                                        borderSide: BorderSide(
                                          color:
                                              appUiModel.isDarkMode
                                                  ? Colors.lightBlueAccent.withAlpha(80)
                                                  : Colors.deepPurple.withAlpha(40),
                                        ),
                                      ),
                                      pixelWidth: appUiModel.deviceWidth,
                                      minLines: 3,
                                      maxLines: 6,
                                      inputContentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                      hint: "Enter description",
                                      inputTextStyle: CustomText("", fontSize: 16).effectiveStyle(context),
                                    ),
                                  ),
                                ),

                                SliverToBoxAdapter(child: CustomText("*Supports markdown", fontSize: 10, color: Colors.red)),

                                SliverToBoxAdapter(
                                  child: AnimatedSize(
                                    duration: Durations.extralong1,
                                    curve: CustomCurves.defaultIosSpring,
                                    child: ConstantSizing.columnSpacing(appUiModel.viewInsets.bottom + bottomPadding + 48),
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
                      bottom: bottomPadding + appUiModel.viewInsets.bottom + 4.0,
                      left: appUiModel.viewInsets.bottom > 20 ? null : 0,
                      right: 0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: CustomElevatedButton(
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
