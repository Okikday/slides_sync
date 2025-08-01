import 'dart:developer';
import 'dart:ui';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/core/models/file_details.dart';
import 'package:slides_sync/data/models/course_model/course.dart';
import 'package:slides_sync/features/course_navigation/presentation/views/course_details/course_details_header/progress_shape_animated_widget.dart';
import 'package:slides_sync/features/manage_all/manage_course/presentation/views/modify_course/course_description_dialog.dart';
import 'package:slides_sync/shared/components/component_widgets.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:slides_sync/shared/styles/colors.dart';

class CourseDetailsHeader extends ConsumerWidget {
  const CourseDetailsHeader({super.key, required this.course, required this.isScrolled, required this.appBarHeight});

  final Course course;
  final bool isScrolled;
  final double appBarHeight;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appBarCollapsedHeight = kToolbarHeight;

    final topGradColor = AppColors.bgBlendColor(context, .8, .2);
    final firstStop = ((appBarHeight + context.topPadding) / context.deviceHeight);
    return SliverAppBar(
      pinned: true,
      automaticallyImplyLeading: false,
      centerTitle: false,
      leadingWidth: 0,
      expandedHeight: appBarHeight,
      collapsedHeight: appBarCollapsedHeight,
      forceMaterialTransparency: true,
      surfaceTintColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        expandedTitleScale: 1.0,
        centerTitle: false,
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              stops: [double.parse(firstStop.toStringAsFixed(2)), 1],
              colors: [AppColors.backgroundColor(context), topGradColor],
            ),
          ),
        ),
        titlePadding: EdgeInsets.zero,
        title: CourseDetailsHeaderContent(course: course, isScrolled: isScrolled, appBarHeight: appBarHeight),
      ),
    );
  }
}

class CourseDetailsHeaderContent extends ConsumerWidget {
  const CourseDetailsHeaderContent({super.key, required this.course, required this.isScrolled, required this.appBarHeight});

  final Course course;
  final bool isScrolled;
  final double appBarHeight;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topPadding = context.topPadding;
    final shapeSize = kToolbarHeight * 2;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
      child: Padding(
        padding: EdgeInsets.only(top: topPadding),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Padding(
              padding: EdgeInsets.only(left: ConstantSizing.spaceSmall, right: ConstantSizing.spaceSmall),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  Expanded(
                    child: Row(
                      spacing: 8,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ComponentWidgets.backButton(context, backgroundColor: AppColors.bgBlendColor(context, .8, .2)),

                        (course.courseCode.isNotEmpty)
                            ? CustomTextButton(
                              backgroundColor: context.theme.colorScheme.secondary.withAlpha(40),
                              pixelHeight: 28,
                              contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
                              child: CustomText(
                                course.courseCode,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: context.theme.primaryColor,
                              ),
                            ).animate().fadeIn(duration: Durations.medium4, curve: CustomCurves.defaultIosSpring)
                            : const SizedBox(),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: ProgressShapeAnimatedWidget(
                      progress: 0.98,
                      shapeSize: shapeSize,
                      fileDetails: course.imageLocationJson.fileDetails,
                    ).animate().fadeIn(duration: Durations.medium4, curve: CustomCurves.bouncySpring).slideX(begin: 1, end: 0, duration: Durations.medium4, curve: CustomCurves.defaultIosSpring),
                  ),
                ],
              ),
            ),

            AnimatedPositioned(
              left: ConstantSizing.spaceMedium,
              right: shapeSize + ConstantSizing.spaceMedium + 8,
              top: 50 + 8,
              duration: Durations.short2,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: appBarHeight - (48 + 8)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: CourseDetailsHeaderTitle(
                        course: course,
                        isScrolled: isScrolled,
                        appBarHeight: appBarHeight,
                        adjustPosition: course.courseCode.isEmpty,
                      ),
                    ),

                    if (course.description.isNotEmpty) ConstantSizing.columnSpacingSmall,

                    Flexible(
                      child: CustomTextButton(
                        borderRadius: 4.0,
                        contentPadding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                        onClick: () {
                          if (course.description.isNotEmpty) {
                            CustomDialog.show(
                              context,
                              canPop: true,
                              transitionType: TransitionType.cupertinoDialog,
                              reverseTransitionDuration: Durations.short4,
                              curve: CustomCurves.defaultIosSpring,
                              barrierColor: Colors.black.withAlpha(100),
                              child: CourseDescriptionDialog(
                                description: course.description,
                              ).animate().scale(begin: Offset(0.5, 0.5), duration: Durations.extralong1, curve: CustomCurves.bouncySpring),
                            );
                          }
                        },
                        child: CustomText(
                          course.description.isEmpty ? "No description" : course.description,
                          color: AppColors.bgBlendColor(context, .7, .3),
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CourseDetailsHeaderTitle extends ConsumerStatefulWidget {
  const CourseDetailsHeaderTitle({
    super.key,
    required this.course,
    required this.isScrolled,
    required this.appBarHeight,
    required this.adjustPosition,
  });

  final Course course;
  final double appBarHeight;
  final bool isScrolled;
  final bool adjustPosition;

  @override
  ConsumerState<CourseDetailsHeaderTitle> createState() => _CourseDetailsHeaderTitleState();
}

class _CourseDetailsHeaderTitleState extends ConsumerState<CourseDetailsHeaderTitle> with SingleTickerProviderStateMixin {
  // late final AnimationController moveAnimController;
  // @override
  // void initState() {
  //   super.initState();
  //   moveAnimController = AnimationController(vsync: this);
  //   moveAnimController.addListener(onScrollListener);
  // }

  // void onScrollListener(){
  //   if(widget.isScrolled && moveAnimController.isCompleted) {
  //     moveAnimController.forward(from: 0);
  //   }
  // }

  // @override
  // void dispose() {
  //   moveAnimController.removeListener(onScrollListener);
  //   moveAnimController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
          message: widget.course.courseName,
          triggerMode: TooltipTriggerMode.tap,
          child: CustomText(
            widget.course.courseName,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: context.theme.colorScheme.tertiary,
            overflow: TextOverflow.fade,
          ),
        )
        .animate(
          // controller: moveAnimController
        )
        .fadeIn()
        .move(
          begin: widget.adjustPosition ? (widget.isScrolled ? Offset.zero : Offset(48, -44)) : null,
          end: widget.adjustPosition ? (widget.isScrolled ? Offset(48, -44) : Offset.zero) : null,
          duration: Durations.extralong2,
          curve: CustomCurves.defaultIosSpring,
        );
  }
}
