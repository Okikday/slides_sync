import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:material_shapes/material_shapes.dart';
import 'package:slides_sync/core/models/file_details.dart';
import 'package:slides_sync/data/models/course_model/course_model.dart';
import 'package:slides_sync/features/course_navigation/presentation/views/course_details/course_details_header/animated_shape.dart';
import 'package:slides_sync/features/course_navigation/presentation/views/course_details/course_details_header/custom_wave_widget.dart';
import 'package:slides_sync/features/manage_all/manage_course/presentation/views/modify_course/course_description_dialog.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:slides_sync/shared/widgets/build_image_path_widget.dart';

class CourseDetailsHeaderTop extends StatelessWidget {
  const CourseDetailsHeaderTop({super.key, required this.courseModel});

  final CourseModel courseModel;

  @override
  Widget build(BuildContext context) {
    return Row(
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
                    backgroundColor: context.theme.primaryColor.withAlpha(80),
                    pixelHeight: 28,
                    contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
                    child: CustomText(
                      courseModel.courseCode,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: context.theme.colorScheme.outline,
                    ),
                  ),
                ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: CustomText(
                    courseModel.courseName,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: context.theme.colorScheme.tertiary,
                  ),
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
                              child: CourseDescriptionDialog(
                                description: courseModel.description,
                              ).animate().scale(begin: Offset(0.5, 0.5), duration: Durations.extralong1, curve: CustomCurves.bouncySpring),
                            );
                          }
                        },
                        child: CustomText(
                          courseModel.description.isEmpty ? "No description" : courseModel.description,
                          color: context.theme.colorScheme.outline,
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
          child: Builder(
            builder: (context) {
              final shapes = materialShapes;
              shapes.shuffle();
              final shape = shapes.first.shape;
              return MaterialShapedWidget(
                shape: shape,
                size: Size(120, 120),
                child: CustomShapeWaveFilledWidget(
                  progress: 0.56,
                  textStyle: TextStyle(fontWeight: FontWeight.bold, color: context.theme.primaryColor),
                  backgroundWidget: BuildImagePathWidget(
                    fileDetails: courseModel.imageLocationJson.fileDetails,
                    fallbackWidget: const SizedBox(),
                  ).animate().fade(begin: 1.0, end: 0.2, duration: Durations.extralong1, curve: CustomCurves.decelerate),
                ),
              );
            },
          ),
        ),

        // Padding(
        //   padding: const EdgeInsets.only(right: 16.0),
        //   child: StarWaveFilledProgressWidget(
        //     progress: 0.56,
        //     backgroundWidget: BuildImagePathWidget(fileDetails:
        //       courseModel.imageLocationJson.fileDetails,
        //       fallbackWidget: const SizedBox(),
        //     ).animate().fade(begin: 1.0, end: 0.2, duration: Durations.extralong1, curve: CustomCurves.decelerate),
        //   ),
        // ),
      ],
    );
  }
}

class AnimatedShapeSection extends StatelessWidget {
  const AnimatedShapeSection({super.key, required this.courseModel});

  final CourseModel courseModel;

  @override
  Widget build(BuildContext context) {
    return AnimatedShape(
      size: Size(120, 120),
      morphDuration: const Duration(milliseconds: 1500),
      delayedDuration: const Duration(milliseconds: 5000),
      child: CustomShapeWaveFilledWidget(
        progress: 0.56,
        textStyle: TextStyle(fontWeight: FontWeight.bold, color: context.theme.primaryColor),
        backgroundWidget: BuildImagePathWidget(
          fileDetails: courseModel.imageLocationJson.fileDetails,
          fallbackWidget: const SizedBox(),
        ).animate().fade(begin: 1.0, end: 0.2, duration: Durations.extralong1, curve: CustomCurves.decelerate),
      ),
    );
  }
}
