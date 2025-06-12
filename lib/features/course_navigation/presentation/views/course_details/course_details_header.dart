import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/core/models/file_location.dart';
import 'package:slides_sync/features/course_mgmt/data/models/course_model/course_model.dart';
import 'package:slides_sync/features/course_mgmt/presentation/views/modify_course/course_description_dialog.dart';
import 'package:slides_sync/features/course_navigation/presentation/views/course_details/course_details_header/custom_wave_widget.dart';
import 'package:slides_sync/shared/helpers/widget_helper.dart';
import 'package:slides_sync/shared/widgets/build_image_path_widget.dart';

class CourseDetailsHeader extends ConsumerWidget {
  final CourseModel courseModel;
  const CourseDetailsHeader({super.key, required this.courseModel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          ConstantSizing.columnSpacingMedium,

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  spacing: 8.0,
                  children: [
                    if (courseModel.courseCode.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: CustomTextButton(
                          backgroundColor: Colors.deepPurple.withAlpha(80),
                          pixelHeight: 28,
                          contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
                          child: CustomText(
                            courseModel.courseCode,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurpleAccent,
                          ),
                        ),
                      ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: CustomText(courseModel.courseName, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxHeight: 80),
                          child: SingleChildScrollView(
                            child: CustomTextButton(
                              borderRadius: 4.0,
                              contentPadding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                              onClick: () {
                                if (courseModel.description.isNotEmpty) {
                                  CustomDialog.show(
                                    context,
                                    canPop: true,
                                    transitionType: TransitionType.cupertinoDialog,
                                    reverseTransitionDuration: Durations.short4,
                                    curve: CustomCurves.defaultIosSpring,
                                    barrierColor: Colors.black.withAlpha(100),
                                    child: CourseDescriptionDialog(description: courseModel.description).animate().scale(
                                      begin: Offset(0.5, 0.5),
                                      duration: Durations.extralong1,
                                      curve: CustomCurves.bouncySpring,
                                    ),
                                  );
                                }
                              },
                              child: CustomText(
                                courseModel.description.isEmpty ? "No description" : courseModel.description,
                                color: Colors.deepPurpleAccent,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              ConstantSizing.rowSpacingLarge,

              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: StarWaveFilledProgressWidget(
                  progress: 0.56,
                  backgroundWidget: BuildImagePathWidget(fileLocation:
                    courseModel.imageLocationJson.fileLocation,
                    fallbackWidget: const SizedBox(),
                  ).animate().fade(begin: 1.0, end: 0.2, duration: Durations.extralong1, curve: CustomCurves.decelerate),
                ),
              ),
            ],
          ),

          ConstantSizing.columnSpacingLarge,

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              spacing: 8.0,
              children: [
                Expanded(
                  child: CustomElevatedButton(
                    label: "Reading history",
                    // textColor: context.isDarkMode ? Colors.white : Colors.black,
                    textColor: Colors.deepPurpleAccent,
                    textSize: 14,
                    borderRadius: 24,
                    pixelHeight: 48,
                    backgroundColor: Colors.deepPurple.withAlpha(80),
                    onClick: () async {
                      await showModalBottomSheet(
                        context: context,
                        enableDrag: true,
                        showDragHandle: true,
                        builder: (context) {
                          return DraggableScrollableSheet(
                            builder: (context, scrollController) {
                              return Container();
                            },
                          );
                        },
                      );
                    },
                  ),
                ),

                CustomElevatedButton(
                  shape: CircleBorder(),
                  pixelHeight: 48,
                  pixelWidth: 48,
                  backgroundColor: Colors.lightBlueAccent.withAlpha(80),
                  child: Icon(Icons.share_outlined, size: 20, color: Colors.lightBlue),
                ),
              ],
            ),
          ),

          ConstantSizing.columnSpacingLarge,
        ],
      ),
    );
  }
}
