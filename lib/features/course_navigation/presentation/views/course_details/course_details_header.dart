import 'dart:math';
import 'dart:ui';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/domain/models/file_details.dart';
import 'package:slides_sync/domain/models/course_model/course.dart';
import 'package:slides_sync/features/course_navigation/presentation/views/course_details/course_details_header/progress_shape_animated_widget.dart';
import 'package:slides_sync/features/course_navigation/presentation/views/course_details_view.dart';
import 'package:slides_sync/features/manage_all/manage_course/presentation/views/modify_course/course_description_dialog.dart';
import 'package:slides_sync/shared/components/app_bar_container.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:slides_sync/shared/styles/colors.dart';

class CourseDetailsHeader extends ConsumerWidget {
  const CourseDetailsHeader({
    super.key,
    required this.course,
    required this.scrollOffsetProvider,
    required this.appBarHeight,
  });

  final Course course;
  final AutoDisposeStateProvider<double> scrollOffsetProvider;
  final double appBarHeight;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appBarCollapsedHeight = kToolbarHeight;
    final theme = ref.theme;

    // final topGradColor = theme.background.blendColor(
    //   context.isDarkMode ? .2 : .8,
    // );
    final topGradColor = theme.altBackgroundPrimary;
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
        title: CourseDetailsHeaderContent(
          course: course,
          scrollOffsetProvider: scrollOffsetProvider,
          appBarHeight: appBarHeight,
        ),
      ),
    );
  }
}

class CourseDetailsHeaderContent extends ConsumerWidget {
  const CourseDetailsHeaderContent({
    super.key,
    required this.course,
    required this.scrollOffsetProvider,
    required this.appBarHeight,
  });

  final Course course;
  final AutoDisposeStateProvider<double> scrollOffsetProvider;
  final double appBarHeight;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topPadding = context.topPadding;
    final shapeSize = kToolbarHeight * 2;
    final theme = ref.theme;

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
                        AppBackButton(),

                        (course.courseCode.isNotEmpty)
                            ? CustomTextButton(
                              backgroundColor: theme.altBackgroundPrimary,
                              pixelHeight: 28,
                              contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
                              child: CustomText(
                                course.courseCode,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: theme.primaryColor,
                              ),
                            ).animate().scaleXY(duration: Durations.extralong4, curve: CustomCurves.defaultIosSpring)
                            : const SizedBox(),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Builder(
                      builder: (context) {
                        final rand = Random().nextDouble();
                        return ProgressShapeAnimatedWidget(
                              progress: rand,
                              shapeSize: shapeSize,
                              fileDetails: course.imageLocationJson.fileDetails,
                            )
                            .animate()
                            .fadeIn(duration: Durations.medium4, curve: CustomCurves.bouncySpring)
                            .scaleXY(
                              begin: .4,
                              end: 1,
                              duration: Durations.extralong2,
                              curve: CustomCurves.bouncySpring,
                            );
                      },
                    ),
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
                        courseName: course.courseName,
                        scrollOffsetProvider: scrollOffsetProvider,
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
                              child: CourseDescriptionDialog(description: course.description).animate().scale(
                                begin: Offset(0.5, 0.5),
                                duration: Durations.extralong1,
                                curve: CustomCurves.bouncySpring,
                              ),
                            );
                          }
                        },
                        child: CustomText(
                          course.description.isEmpty ? "No description" : course.description,
                          color: theme.supportingText.withValues(alpha: .9),
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
    required this.courseName,
    required this.scrollOffsetProvider,
    required this.appBarHeight,
    required this.adjustPosition,
  });

  final String courseName;
  final double appBarHeight;
  final AutoDisposeStateProvider<double> scrollOffsetProvider;
  final bool adjustPosition;

  @override
  ConsumerState<CourseDetailsHeaderTitle> createState() => _CourseDetailsHeaderTitleState();
}

class _CourseDetailsHeaderTitleState extends ConsumerState<CourseDetailsHeaderTitle> with SingleTickerProviderStateMixin {
  late final AnimationController moveAnimController;
  @override
  void initState() {
    super.initState();
    moveAnimController = AnimationController(
      duration: Durations.medium1,
      reverseDuration: Durations.medium1,
      vsync: this,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(widget.scrollOffsetProvider.notifier).addListener(listener);
    });

    moveAnimController.forward(from: 0);
  }

  void listener(double offset) {
    final double percentScroll = (offset / (appBarHeight + context.topPadding)).clamp(0, 1);
    percentScroll >= 0.5 ? moveAnimController.reverse() : moveAnimController.forward();
  }

  @override
  void dispose() {
    moveAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.theme;
    final textWidget = Tooltip(
      message: widget.courseName,
      triggerMode: TooltipTriggerMode.tap,
      child: CustomText(
        widget.courseName,
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: theme.onBackground,
        overflow: TextOverflow.fade,
      ),
    );
    return widget.adjustPosition
        ? textWidget
            .animate(controller: moveAnimController)
            .move(
              begin: Offset(48, -44),
              end: Offset.zero,
              duration: Durations.extralong4,
              curve: CustomCurves.defaultIosSpring,
            )
        : textWidget
            .animate(controller: moveAnimController)
            .fadeIn()
            .move(
          begin: Offset(48, -44),
          end: Offset.zero,
          duration: Durations.extralong4,
          curve: CustomCurves.defaultIosSpring,
        );
  }
}
