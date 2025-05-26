import 'dart:developer';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/features/course_mgmt/data/models/course_model/course_model.dart';
import 'package:slides_sync/features/course_mgmt/presentation/viewmodels/notifiers/modify_course/is_plain_view_notifier.dart';
import 'package:slides_sync/features/course_mgmt/presentation/viewmodels/notifiers/modify_course/modify_course_model_notifier.dart';
import 'package:slides_sync/features/course_mgmt/presentation/views/modify_course/add_course_description_dialog.dart';
import 'package:slides_sync/features/course_mgmt/presentation/views/modify_course/collections_section.dart';
import 'package:slides_sync/features/course_mgmt/presentation/views/modify_course/course_description_dialog.dart';
import 'package:slides_sync/features/course_mgmt/presentation/views/modify_course/edit_course_bottom_sheet.dart';
import 'package:slides_sync/features/course_mgmt/presentation/views/modify_course/modify_course_header.dart';
import 'package:slides_sync/features/course_navigation/presentation/views/course_navigation_view.dart';
import 'package:slides_sync/shared/components/app_bar_container.dart';
import 'package:slides_sync/shared/components/app_bar_container_child.dart';
import 'package:slides_sync/shared/styles/app_ui_context.dart';

/// VIEW
class ModifyCourseView extends ConsumerStatefulWidget {
  final CourseModel courseModel;
  const ModifyCourseView({super.key, required this.courseModel});

  @override
  ConsumerState createState() => _ModifyCourseState();
}

class _ModifyCourseState extends ConsumerState<ModifyCourseView> with TickerProviderStateMixin {
  late final NotifierProvider<ModifyCourseModelNotifier, CourseModel> modifyCourseProvider;

  late final PageController collectionPageController;
  late final PageController contentPageController;

  late final AsyncNotifierProvider<IsPlainViewNotifier, bool> isPlainViewProvider;

  @override
  void initState() {
    super.initState();
    modifyCourseProvider = NotifierProvider<ModifyCourseModelNotifier, CourseModel>(ModifyCourseModelNotifier.new);
    WidgetsBinding.instance.addPostFrameCallback((_) => ref.read(modifyCourseProvider.notifier).update(widget.courseModel));
    collectionPageController = PageController(initialPage: 4);
    contentPageController = PageController(initialPage: 4);
    isPlainViewProvider = AsyncNotifierProvider<IsPlainViewNotifier, bool>(IsPlainViewNotifier.new);
  }

  @override
  void dispose() {
    collectionPageController.dispose();
    contentPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    final CourseModel courseModel = ref.watch(modifyCourseProvider);

    final List<String> categoriesList = ["Slides", "Textbooks", "Questions", "Additional", "Tips"];

    return AnnotatedRegion(
      value: UiUtils.getSystemUiOverlayStyle(context.scaffoldBackgroundColor, context.isDarkMode),
      child: Scaffold(
        appBar: AppBarContainer(
          appBarHeight: kToolbarHeight + 12,
          padding: EdgeInsets.zero,
          child: AppBarContainerChild(context.isDarkMode, title: 'Modify Course'),
        ),
        body: CustomScrollView(
          slivers: [
            ModifyCourseHeader(
              title: courseModel.courseName,
              description: courseModel.description.trim(),
              courseImagePath: courseModel.imagePath,
              onClickEditCourse: () async {
                await showModalBottomSheet(
                  context: context,
                  enableDrag: false,
                  showDragHandle: false,
                  backgroundColor: context.scaffoldBackgroundColor,
                  isScrollControlled: true,
                  builder: (context) => EditCourseBottomSheet(modifyCourseProvider: modifyCourseProvider),
                ).then((_) {
                  log("Closed Bottom sheet");
                });
              },
              onClickFilter: () {},
              onClickAddDescription: () {
                if (courseModel.description.isNotEmpty) {
                  LoadingDialog.showLoadingDialog(
                    context,
                    canPop: true,
                    reverseTransitionDuration: Durations.short4,
                    transitionType: TransitionType.cupertinoDialog,
                    curve: CustomCurves.defaultIosSpring,
                    barrierColor: Colors.black.withAlpha(100),
                    loadingInfoWidget: CourseDescriptionDialog(
                      description: courseModel.description,
                    ).animate().scale(begin: Offset(0.5, 0.5), duration: Durations.extralong1, curve: CustomCurves.bouncySpring),
                  );
                } else {
                  LoadingDialog.showLoadingDialog(
                    context,
                    canPop: true,
                    transitionType: TransitionType.cupertinoDialog,
                    loadingInfoWidget: AddCourseDescriptionDialog(
                      title: courseModel.courseName,
                      courseProvider: modifyCourseProvider,
                    ),
                  );
                }
              },
            ),

            SliverToBoxAdapter(child: ConstantSizing.columnSpacingExtraLarge),

            CollectionsSection(collections: categoriesList, pageController: collectionPageController),

            SliverToBoxAdapter(child: ConstantSizing.columnSpacingLarge),

            // if ((courseModel.collectionIds != null && courseModel.collectionIds!.isNotEmpty) ||
            //     (courseModel.rootContentIds != null && courseModel.rootContentIds!.isNotEmpty))
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              sliver: SliverToBoxAdapter(
                child: CustomElevatedButton(
                  onClick: () {
                    // if (context.mounted) {
                    //   Navigator.of(context).push(
                    //     PageTransition(
                    //       type: PageTransitionType.rightToLeftWithFade,
                    //       duration: Durations.extralong3,
                    //       reverseDuration: Durations.medium1,
                    //       curve: CustomCurves.snappySpring,
                    //       child: CourseMaterialsView(),
                    //     ),
                    //   );
                    // }
                    Navigator.of(context).push(
                      PageAnimation.pageRouteBuilder(
                        CourseNavigationView(courseModel: courseModel),
                        type: TransitionType.uptown,
                        duration: Durations.extralong1,
                        curve: CustomCurves.defaultIosSpring,
                      ),
                    );
                  },
                  borderRadius: 48,
                  pixelHeight: 56,
                  backgroundColor: Colors.deepPurple.withAlpha(80),
                  label: "See all materials",
                  textSize: 15,
                  textColor: Colors.deepPurple,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
