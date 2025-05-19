import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_transition/page_transition.dart';
import 'package:slides_sync/core/utils/app_ui_state.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/features/course_navigation/presentation/views/course_details/star_wave_filled_progress_widget.dart';
import 'package:slides_sync/features/course_navigation/presentation/views/course_navigation/collection_card_tile.dart';
import 'package:slides_sync/shared/components/app_bar_container.dart';
import 'package:slides_sync/shared/components/app_bar_container_child.dart';
import 'package:slides_sync/shared/components/component_widgets.dart';
import 'package:slides_sync/features/course_navigation/presentation/views/course_details/course_categories_card.dart';
import 'package:slides_sync/shared/styles/app_ui_context.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

import 'course_materials_view.dart';

class CourseDetailsPage extends ConsumerWidget {
  const CourseDetailsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<String> categoriesList = ["Slides", "Textbooks", "Questions", "Additional", "Tips"];
    return AnnotatedRegion(
      value: UiUtils.getSystemUiOverlayStyle(context.scaffoldBackgroundColor, context.isDarkMode),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
        appBar: AppBarContainer(
          appBarHeight: kToolbarHeight + 12,
          padding: EdgeInsets.zero,
          child: AppBarContainerChild(context.isDarkMode, title: "Course info"),
        ),
        body: SafeArea(
          child: CustomScrollView(
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
                          children: [
                            CustomText("MAT 224", fontSize: 24, fontWeight: FontWeight.bold),
                            ConstantSizing.columnSpacingSmall,
                            CustomText("Linear Algebra II"),
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

              // Bottom sheet would pop up for the More info button
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: CustomElevatedButton(
                    borderRadius: 24,
                    pixelHeight: 48,
                    backgroundColor: Colors.deepPurple.withAlpha(10),
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText("More info", color: context.isDarkMode ? Colors.white : Colors.black, fontWeight: FontWeight.bold),
                        ConstantSizing.rowSpacing(4),
                        Icon(Icons.keyboard_arrow_down_rounded, size: 24),
                      ],
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(child: ConstantSizing.columnSpacingExtraLarge),

              PinnedHeaderSliver(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: CustomText("Categories", fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              SliverToBoxAdapter(child: ConstantSizing.columnSpacingLarge),
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
                    ).animate().slideY(begin: 0.5 * (index + (categoriesList.length/2)/categoriesList.length), end: 0, curve: CustomCurves.bouncySpring, duration: Durations.extralong4),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}




