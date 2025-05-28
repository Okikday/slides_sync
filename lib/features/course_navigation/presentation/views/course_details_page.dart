import 'dart:ui';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/features/course_mgmt/data/models/course_model/course_model.dart';
import 'package:slides_sync/features/course_mgmt/presentation/views/modify_course/course_description_dialog.dart';
import 'package:slides_sync/features/course_navigation/presentation/views/course_details/star_wave_filled_progress_widget.dart';
import 'package:slides_sync/shared/components/app_bar_container.dart';
import 'package:slides_sync/shared/components/app_bar_container_child.dart';
import 'package:slides_sync/features/course_navigation/presentation/views/course_details/course_categories_card.dart';
import 'package:slides_sync/shared/helpers/widget_helper.dart';
import 'package:slides_sync/shared/styles/app_ui_context.dart';

import 'course_materials_view.dart';

class CourseDetailsPage extends ConsumerWidget {
  final CourseModel courseModel;
  const CourseDetailsPage({super.key, required this.courseModel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<String> categoriesList = ["Slides", "Textbooks", "Questions", "Additional", "Tips"];
    return AnnotatedRegion(
      value: UiUtils.getSystemUiOverlayStyle(context.scaffoldBackgroundColor, context.isDarkMode),
      child: Scaffold(
        extendBody: true,
        appBar: AppBarContainer(
          appBarHeight: kToolbarHeight + 12,
          padding: EdgeInsets.zero,
          child: AppBarContainerChild(context.isDarkMode, title: "Course Info"),
        ),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: ConstantSizing.columnSpacingMedium),
            SliverToBoxAdapter(
              child: Row(
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
                                    if(courseModel.description.isNotEmpty){
                                      LoadingDialog.showLoadingDialog(
                                      context,
                                      canPop: true,
                                      transitionType: TransitionType.cupertinoDialog,
                                      reverseTransitionDuration: Durations.short4,
                                      curve: CustomCurves.defaultIosSpring,
                                      barrierColor: Colors.black.withAlpha(100),
                                      loadingInfoWidget: CourseDescriptionDialog(description: courseModel.description).animate().scale(
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
                    child: ClipPath(
                      clipper: StarClipper(StarBorder(points: 4, pointRounding: 0.7, valleyRounding: 0.3, innerRadiusRatio: 0.4)),
                      child: ClipPath(
                        clipBehavior: Clip.hardEdge,
                        child: SizedBox(
                          width: 100,
                          height: 100,
                          child: Stack(
                            clipBehavior: Clip.hardEdge,
                            children: [
                              WidgetHelper.resolveImageWidget(
                                courseModel.imagePath,
                                fallbackWidget: const SizedBox(),
                              ).animate().fade(begin: 1.0, end: 0.2, duration: Durations.extralong1, curve: CustomCurves.decelerate),
                              Positioned.fill(child: StarWaveFilledProgressWidget(progress: 0.56)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Padding(
                  //   padding: const EdgeInsets.only(right: 16.0),
                  //   child: Material(
                  //     child: SizedBox(
                  //       width: 100,
                  //       height: 100,
                  //       child: Stack(
                  //         clipBehavior: Clip.hardEdge,
                  //         children: [
                  //           WidgetHelper.resolveImageWidget(courseModel.imagePath, fallbackWidget: const SizedBox()),
                  //           Positioned.fill(child: StarWaveFilledProgressWidget(progress: 0.56)),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            SliverToBoxAdapter(child: ConstantSizing.columnSpacingExtraLarge),

            // Bottom sheet would pop up for Editing Course
            SliverToBoxAdapter(
              child: Padding(
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
                      child: Icon(Icons.share_outlined, size: 20, color: Colors.lightBlue,),
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(child: ConstantSizing.columnSpacingExtraLarge),

            PinnedHeaderSliver(
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                  child: ColoredBox(
                    color: context.scaffoldBackgroundColor.withValues(alpha: 0.8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: CustomText("Categories", fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(child: ConstantSizing.columnSpacingSmall),

            SliverList.builder(
              itemCount: categoriesList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0, left: 16.0, right: 16.0),
                  child: CourseCategoriesCard(
                    isDarkMode: context.isDarkMode,
                    title: categoriesList[index],
                    onTap: () {
                      if (context.mounted) {
                        Navigator.of(context).push(
                          PageTransition(
                            type: PageTransitionType.rightToLeftWithFade,
                            duration: Durations.extralong3,
                            reverseDuration: Durations.medium1,
                            curve: CustomCurves.snappySpring,
                            child: CourseMaterialsView(),
                          ),
                        );
                      }
                    },
                  ).animate().slideY(
                    begin: double.parse((0.5 * (index + (categoriesList.length / 2) / categoriesList.length)).toStringAsFixed(2)),
                    end: 0,
                    curve: CustomCurves.bouncySpring,
                    duration: Durations.extralong4,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
