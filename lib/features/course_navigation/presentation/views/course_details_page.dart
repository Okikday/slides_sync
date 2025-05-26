import 'dart:ui';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_transition/page_transition.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/features/course_mgmt/data/models/course_model/course_model.dart';
import 'package:slides_sync/features/course_mgmt/presentation/views/modify_course/course_description_dialog.dart';
import 'package:slides_sync/features/course_navigation/presentation/views/course_details/star_wave_filled_progress_widget.dart';
import 'package:slides_sync/shared/components/app_bar_container.dart';
import 'package:slides_sync/shared/components/app_bar_container_child.dart';
import 'package:slides_sync/features/course_navigation/presentation/views/course_details/course_categories_card.dart';
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
          child: AppBarContainerChild(context.isDarkMode, title: "Course Info",),
        ),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: ConstantSizing.columnSpacingMedium),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        spacing: 8.0,
                        children: [
                          Flexible(child: CustomText("[MAT 224] - Linear Algebra II", fontSize: 16, fontWeight: FontWeight.bold)),
                          Flexible(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(maxHeight: 80),
                              child: SingleChildScrollView(
                                child: CustomTextButton(
                                  borderRadius: 4.0,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                                  onClick: (){
                                    LoadingDialog.showLoadingDialog(
                                      context,
                                      canPop: true,
                                      transitionType: TransitionType.cupertinoDialog,
                                      reverseTransitionDuration: Durations.short4,
                                      curve: CustomCurves.defaultIosSpring,
                                      barrierColor: Colors.black.withAlpha(100),
                                      loadingInfoWidget: CourseDescriptionDialog(
                                        description: "Description",
                                      ).animate().scale(begin: Offset(0.5, 0.5), duration: Durations.extralong1, curve: CustomCurves.bouncySpring),
                                    );
                                  },
                                  child: CustomText(true ? "No description" : "other condition", color: Colors.deepPurple),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    ConstantSizing.rowSpacingLarge,

                    StarWaveFilledProgressWidget(progress: 0.56),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(child: ConstantSizing.columnSpacingExtraLarge),

            // Bottom sheet would pop up for Editing Course
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: CustomElevatedButton(
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
                  child: CustomText("Edit course", color: context.isDarkMode ? Colors.white : Colors.black, fontWeight: FontWeight.bold),
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

            SliverToBoxAdapter(child: ConstantSizing.columnSpacingSmall,),

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
                  ).animate().slideY(begin: double.parse((0.5 * (index + (categoriesList.length/2)/categoriesList.length)).toStringAsFixed(2)), end: 0, curve: CustomCurves.bouncySpring, duration: Durations.extralong4),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}




