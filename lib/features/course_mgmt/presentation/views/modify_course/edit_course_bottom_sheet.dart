import 'dart:developer';
import 'package:flutter/material.dart';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/features/course_mgmt/data/models/course_model/course_model.dart';
import 'package:slides_sync/features/course_mgmt/presentation/viewmodels/notifiers/modify_course/modify_course_model_notifier.dart';
import 'package:slides_sync/shared/components/dialogs/app_alert_dialog.dart';
import 'package:slides_sync/shared/styles/app_ui_context.dart';

class EditCourseBottomSheet extends ConsumerStatefulWidget {
  final NotifierProvider<ModifyCourseModelNotifier, CourseModel> modifyCourseProvider;
  const EditCourseBottomSheet({super.key, required this.modifyCourseProvider});

  @override
  ConsumerState createState() => _EditCourseBottomSheetState();
}

class _EditCourseBottomSheetState extends ConsumerState<EditCourseBottomSheet> {
  late final TextEditingController descriptionTextController;
  late final StateProvider<bool> canExitProvider;

  @override
  void initState() {
    super.initState();
    canExitProvider = StateProvider<bool>((ref) => false);
    descriptionTextController = TextEditingController();
  }

  bool isDescriptionValid() {
    final text = descriptionTextController.text;
    final String providerDesc = ref.watch(widget.modifyCourseProvider).description;
    if (text.isEmpty || text.length < 8 || text.length > 1024 || text == providerDesc) {
      return false;
    }
    return true;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    final CourseModel courseModel = ref.watch(widget.modifyCourseProvider);
    
    final double bottomPadding = MediaQuery.paddingOf(context).bottom;
    final double keyboardInsets = double.parse(
      (context.viewInsets.bottom / context.deviceHeight).toStringAsFixed(2),
    ).clamp(0.0, 0.25);

    return PopScope(
      canPop: ref.watch(canExitProvider),
      onPopInvokedWithResult: (_, __) {
        log("message to track");
        if(ref.watch(canExitProvider)){
          return;
        }
        // final currCourseModel = ref.watch(widget.modifyCourseProvider);

        LoadingDialog.showLoadingDialog(
          context,
          barrierColor: Colors.black.withValues(alpha: 0.4),
          blurSigma: 4,
          transitionDuration: Durations.medium2,
          loadingInfoWidget: AppAlertDialog(
            title: "Confirm exit",
            content: "Are you sure you want to exit without saving?",
            onCancel: (){
              LoadingDialog.hideLoadingDialog(context);
            },
            onConfirm: () async{
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
                                SliverToBoxAdapter(
                                  child: GestureDetector(
                                    onTap: () {},
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
                                    width: context.deviceWidth,
                                    child: CustomTextfield(
                                      onchanged: (text){
                                        if(isDescriptionValid()){
                                          ref.read(canExitProvider.notifier).update((cb)=> true);
                                        }else{
                                          ref.read(canExitProvider.notifier).update((cb)=> false);
                                        }
                                      },
                                      // onTapOutside: () {},
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
                                ),

                                SliverToBoxAdapter(child: CustomText("*Supports markdown", fontSize: 10, color: Colors.red)),

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
                          onClick: () {
                            final text = descriptionTextController.text;
                            final String providerDesc = ref.watch(widget.modifyCourseProvider).description;

                            if (!isDescriptionValid()) {
                              if(text == providerDesc){
                                CustomSnackBar.showSnackBar(context, content: "Kindly input a different description from previous");
                                return;
                              }
                              CustomSnackBar.showSnackBar(context, content: "Kindly input a valid description!");
                              return;
                            }

                            final currCourseModel = ref.watch(widget.modifyCourseProvider);
                            ref.read(widget.modifyCourseProvider.notifier).update(currCourseModel.copyWith(description: text));
                            ref.read(canExitProvider.notifier).update((cb) => true);
                            Navigator.pop(context);
                          },
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          label: "Update details",
                          textColor: Colors.white,
                          textSize: 15,
                          pixelHeight: 48,
                          backgroundColor: isDescriptionValid() ? Colors.deepPurple : Colors.blueGrey,
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
