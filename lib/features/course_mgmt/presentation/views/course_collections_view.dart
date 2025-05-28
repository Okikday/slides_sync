import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:slides_sync/features/course_mgmt/data/models/course_model/course_model.dart';
import 'package:slides_sync/features/course_mgmt/data/repos/course_repo.dart';
import 'package:slides_sync/features/course_navigation/presentation/views/course_navigation/collection_card_tile.dart';
import 'package:slides_sync/shared/strings/icon_strings.dart';
import 'package:slides_sync/shared/styles/app_ui_context.dart';
import 'package:slides_sync/test/dummy_slides.dart';

import '../../../../core/utils/ui_utils.dart';
import '../../../../shared/components/app_bar_container.dart';
import '../../../../shared/components/app_bar_container_child.dart';
import '../../../course_navigation/presentation/views/course_materials_view.dart';

class CourseCollectionsView extends ConsumerStatefulWidget {
  final CourseModel courseModel;

  const CourseCollectionsView({super.key, required this.courseModel});

  @override
  ConsumerState createState() => _CourseCollectionsViewState();
}

class _CourseCollectionsViewState extends ConsumerState<CourseCollectionsView> {
  late final StateProvider<CourseModel> modifyCourseProvider;
  late final StreamProvider<CourseModel?> syncCourseProvider;

  @override
  void initState() {
    super.initState();
    modifyCourseProvider = StateProvider((ref) => widget.courseModel);
    syncCourseProvider = StreamProvider((ref) => CourseRepo.watchCourseById(widget.courseModel.id));
  }

  @override
  Widget build(BuildContext context) {
    final courseModel = widget.courseModel;

    return AnnotatedRegion(
      value: UiUtils.getSystemUiOverlayStyle(context.scaffoldBackgroundColor, context.isDarkMode),
      child: Scaffold(
        appBar: AppBarContainer(
          appBarHeight: kToolbarHeight + 12,
          padding: EdgeInsets.zero,
          child: AppBarContainerChild(context.isDarkMode, title: courseModel.courseName),
        ),

        floatingActionButton:
            courseModel.subCollections.isNotEmpty
                ? FloatingActionButton(onPressed: () {}, shape: CircleBorder(), child: Icon(Icons.add_rounded, size: 32))
                : null,

        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: ConstantSizing.columnSpacingLarge),

            if (courseModel.subCollections.isNotEmpty)
              SliverList.builder(
                itemCount: courseModel.subCollections.length,
                itemBuilder: (context, index) {
                  return CollectionCardTile(
                        context.isDarkMode,
                        title: courseModel.subCollections[index].collectionTitle,
                        contentCount: 12,
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
                      )
                      .animate()
                      .slideY(
                        begin: 0.5 * (index / DummySlides.dummySlides.length + 1),
                        duration: Durations.extralong4,
                        curve: CustomCurves.bouncySpring,
                      )
                      .fadeIn();
                },
              )
            else
              SliverToBoxAdapter(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ConstantSizing.columnSpacing((context.deviceHeight/2) - context.deviceWidth * 0.5 - ConstantSizing.spaceHuge - 48),
                      SizedBox.square(
                        dimension: context.deviceWidth * 0.5,
                        child: LottieBuilder.asset(IconStrings.instance.roundedPlayingFace, reverse: true,),
                      ),

                      CustomText("Oops, can't find any collections", color: Colors.blueGrey,),

                      ConstantSizing.columnSpacingHuge,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: CustomElevatedButton(
                          backgroundColor: Colors.deepPurple,
                          borderRadius: 12,
                          pixelHeight: 44,
                          label: "Add a new collection",
                          textSize: 15,
                          textColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            SliverToBoxAdapter(child: ConstantSizing.columnSpacingMedium),

            // ),
          ],
        ),
      ),
    );
  }
}
