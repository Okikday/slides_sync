
import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/core/utils/app_ui_state.dart';
import 'package:slides_sync/shared/components/app_bar_container.dart';
import 'package:slides_sync/shared/components/component_widgets.dart';
import 'package:slides_sync/data/hive_data/app_hive_data.dart';
import 'package:slides_sync/shared/models/course_model/course_model.dart';
import 'package:slides_sync/features/course_mgmt/presentation/views/manage_courses/create_course_view/modify_course/modify_course_header.dart';

import '../../../../../../data/hive_data_paths.dart';
import '../../../viewmodels/notifiers/modify_course/is_plain_view_notifier.dart';
import '../../../viewmodels/notifiers/modify_course/modify_course_model_notifier.dart';
import 'modify_course/build_add_description_dialog.dart';
import 'modify_course/collections_section.dart';
import 'modify_course/course_description_dialog.dart';








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
    final AppUiModel appUiModel = ref.watch(appUiStateProvider);
    final Color scaffoldBgColor = Theme.of(context).scaffoldBackgroundColor;
    final CourseModel courseModel = ref.watch(modifyCourseProvider);

    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: scaffoldBgColor,
        systemNavigationBarIconBrightness: appUiModel.isDarkMode ? Brightness.light : Brightness.dark,
        statusBarColor: scaffoldBgColor,
        statusBarIconBrightness: appUiModel.isDarkMode ? Brightness.light : Brightness.dark,
      ),
      child: Scaffold(
        appBar: AppBarContainer(
          appBarHeight: kToolbarHeight + 12,
          padding: EdgeInsets.zero,
          child: Material(
            type: MaterialType.transparency,
            shape: LinearBorder(
              bottom: LinearBorderEdge(),
              side: BorderSide(color: appUiModel.isDarkMode ? Colors.lightBlueAccent.withAlpha(60) : Colors.grey.withAlpha(40)),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  ComponentWidgets.backButton(context,),
                  ConstantSizing.rowSpacingMedium,
                  Expanded(child: CustomText("Modify Course", fontSize: 18, fontWeight: FontWeight.bold)),
                  CustomElevatedButton(
                    contentPadding: EdgeInsets.all(12),
                    backgroundColor: Colors.lightBlueAccent.withAlpha(40),
                    shape: CircleBorder(),
                    child: Icon(
                      Iconsax.menu,
                      size: 20,
                      color: appUiModel.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: CustomScrollView(
          slivers: [
            ModifyCourseHeader(
              appUiModel,
              title: courseModel.courseTitle,
              description: courseModel.description.trim(),
              onClickEditCourse: () {},
              onClickFilter: () {},
              onClickAddDescription: () {
                if (courseModel.description.isNotEmpty) {
                  LoadingDialog.showLoadingDialog(
                    context,
                    canPop: true,
                    reverseTransitionDuration: Durations.short4,
                    curve: CustomCurves.defaultIosSpring,
                    scaffoldBgColor: Colors.black.withAlpha(100),
                    loadingInfoWidget: CourseDescriptionDialog(
                      scaffoldBgColor: scaffoldBgColor,
                      appUiModel: appUiModel,
                      courseModel: courseModel,
                    ).animate().scale(begin: Offset(0.5, 0.5), duration: Durations.extralong1, curve: CustomCurves.bouncySpring),
                  );
                } else {
                  LoadingDialog.showLoadingDialog(
                    context,
                    canPop: true,
                    loadingInfoWidget: AddCourseDescriptionDialog(
                      appUiModel: appUiModel,
                      title: courseModel.courseTitle,
                      courseProvider: modifyCourseProvider,
                    ),
                  );
                }
              },
            ),



            SliverToBoxAdapter(child: ConstantSizing.columnSpacingExtraLarge),

            CollectionsSection(
              appUiModel,
              collectionIds: courseModel.collectionIds == null ? ["", "", ""] : courseModel.collectionIds!,
              pageController: collectionPageController,
              // onTapCollapsed: () {
              //   if (!ref.watch(isCollectionSectionExpandedProvider)) {
              //     ref.read(isCollectionSectionExpandedProvider.notifier).update(true);
              //     collectionPageController.animateToPage(0, duration: Duration(seconds: 2), curve: CustomCurves.defaultIosSpring);
              //     PrimaryScrollController.of(context).animateTo(120, duration: Durations.extralong4, curve: CustomCurves.decelerate);
              //     collectionAnimController.forward();
              //   }
              // },
            ),

            SliverToBoxAdapter(child: ConstantSizing.columnSpacingLarge),

            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              sliver: SliverToBoxAdapter(
                child: CustomElevatedButton(
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
