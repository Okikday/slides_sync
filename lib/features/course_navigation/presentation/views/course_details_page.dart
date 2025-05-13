import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_transition/page_transition.dart';
import 'package:slides_sync/core/utils/app_ui_state.dart';
import 'package:slides_sync/features/course_navigation/presentation/views/course_details/star_clipper.dart';
import 'package:slides_sync/shared/components/app_bar_container.dart';
import 'package:slides_sync/shared/components/component_widgets.dart';
import 'package:slides_sync/features/course_navigation/presentation/views/course_details/course_categories_card.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

import 'course_details/course_materials_view.dart';

class CourseDetailsPage extends ConsumerWidget {
  const CourseDetailsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppUiModel appUiModel = ref.watch(appUiStateProvider);
    final Color scaffoldBgColor = Theme.of(context).scaffoldBackgroundColor;
    final List<String> categoriesList = ["Slides", "Textbooks", "Questions", "Additional", "Tips"];
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(systemNavigationBarColor: scaffoldBgColor, statusBarColor: scaffoldBgColor),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
        appBar: AppBarContainer(
          appBarHeight: kToolbarHeight + 12,
            padding: EdgeInsets.zero,
            child: Material(
              type: MaterialType.transparency,
              shape: LinearBorder(bottom: LinearBorderEdge(), side: BorderSide(color: appUiModel.isDarkMode ? Colors.lightBlueAccent.withAlpha(60) : Colors.grey.withAlpha(40))),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                          children: [
                ComponentWidgets.backButton(context),
                ConstantSizing.rowSpacingMedium,
                Expanded(child: CustomText("Course info", fontSize: 18, fontWeight: FontWeight.bold,))
                          ],
                        ),
              ),
            )),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: ConstantSizing.columnSpacingMedium),
                SliverToBoxAdapter(
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

                      StarWaveFilledWidget(progress: 0.56,),

                    ],
                  ),
                ),
                SliverToBoxAdapter(child: ConstantSizing.columnSpacingExtraLarge),

                // Bottom sheet would pop up for the More info button
                SliverToBoxAdapter(
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
                        CustomText("More info", color: appUiModel.isDarkMode ? Colors.white : Colors.black, fontWeight: FontWeight.bold),
                        ConstantSizing.rowSpacing(4),
                        Icon(Icons.keyboard_arrow_down_rounded, size: 24),
                      ],
                    ),
                  ),
                ),

                SliverToBoxAdapter(child: ConstantSizing.columnSpacingExtraLarge),

                SliverToBoxAdapter(child: CustomText("Categories", fontSize: 16, fontWeight: FontWeight.bold)),
                SliverToBoxAdapter(child: ConstantSizing.columnSpacingMedium),
                SliverList.builder(
                  itemCount: categoriesList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: CourseCategoriesCard(
                        isDarkMode: appUiModel.isDarkMode,
                        title: categoriesList[index],
                        onTap: () {
                          if (context.mounted) {
                            Navigator.of(context).push(
                              PageTransition(
                                type: PageTransitionType.rightToLeftWithFade,
                                duration: Durations.extralong3,
                                reverseDuration: Durations.medium1,
                                curve: CustomCurves.snappySpring,
                                child: CourseMaterialsView(appUiStateProvider),
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
      ),
    );
  }
}

class StarWaveFilledWidget extends StatelessWidget {
  final double progress;
  const StarWaveFilledWidget({
    super.key,
    required this.progress
  });

  @override
  Widget build(BuildContext context) {
    final double fill;
    if(progress < 0.0 || progress > 1.0){
      fill = 0.0;
    }else{
      fill = 1.0 - progress;
    }
    return SizedBox(
      width: 100,
      height: 100,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          ClipPath(
            clipper: StarClipper(StarBorder(points: 4, pointRounding: 0.7, valleyRounding: 0.3, innerRadiusRatio: 0.4)),
            child: ClipPath(
              clipBehavior: Clip.hardEdge,
              child: WaveWidget(
                config: CustomConfig(
                  colors: [
                    Colors.deepPurple.withAlpha(50),
                    Colors.deepPurple.withAlpha(80),
                  ],
                  durations: [
                    5000,
                    4000,
                  ],
                  heightPercentages: [
                    fill - 0.01, fill + 0.01
                  ],
                ),
                backgroundColor: Colors.lightBlueAccent.withAlpha(40),
                size: Size(double.infinity, double.infinity),
                waveAmplitude: 10,
              ),
            ),
          ),

          Positioned.fill(
            child: Align(alignment: Alignment.center, child: CustomText("${(progress >= 0.0 && progress <= 1.0) ? (progress * 100.0).truncate() : 0}%", fontWeight: FontWeight.bold, textAlign: TextAlign.center,)),
          )
        ],
      ),
    );
  }
}




