
import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/app/states/app_ui_state.dart';
import 'package:slides_sync/shared/components/app_bar_container.dart';
import 'package:slides_sync/shared/components/component_widgets.dart';
import 'package:slides_sync/data/hive_data/app_hive_data.dart';
import 'package:slides_sync/shared/models/course_model/course_model.dart';
import 'package:slides_sync/features/course_mgmt/presentation/views/manage_courses/create_course_view/modify_course/modify_course_header.dart';

import '../../../../../../data/hive_data_paths.dart';
import 'modify_course/build_add_description_dialog.dart';
import 'modify_course/collections_section.dart';
import 'modify_course/contents_section.dart';
import 'modify_course/course_description_dialog.dart';

/// NOTIFIERS
class ModifyCourseModelNotifier extends Notifier<CourseModel> {
  @override
  CourseModel build() {
    return CourseModel(courseId: "courseId", courseTitle: "courseTitle");
  }

  void update(CourseModel courseModel) {
    if (state == courseModel) return;
    state = courseModel;
  }
}

class IsSectionExpandedNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void update(bool value) {
    if (state == value) return;
    state = value;
  }
}

class IsPlainViewNotifier extends AsyncNotifier<bool> {
  final String _key = "${HiveDataPaths.views}/library/manage_courses/modify_course/var/isListView";

  @override
  Future<bool> build() async {
    final value = await AppHiveData.instance.getData(key: _key);
    return value is bool ? value : true;
  }

  Future<void> toggle() async {
    final current = state.value ?? true;
    final updated = !current;
    state = AsyncData(updated);
    await AppHiveData.instance.setData(key: _key, value: updated);
  }
}

/// VIEW
class ModifyCourse extends ConsumerStatefulWidget {
  final NotifierProvider<AppUiState, AppUiModel> appUiStateProvider;
  final CourseModel courseModel;
  const ModifyCourse(this.appUiStateProvider, {super.key, required this.courseModel});

  @override
  ConsumerState createState() => _ModifyCourseState();
}

class _ModifyCourseState extends ConsumerState<ModifyCourse> with TickerProviderStateMixin {
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

        // floatingActionButton:
        //     ref.watch(isCollectionSectionExpandedProvider)
        //         ? FloatingActionButton.small(
        //           onPressed: () {
        //             if (ref.watch(isCollectionSectionExpandedProvider)) {
        //               ref.read(isCollectionSectionExpandedProvider.notifier).update(false);
        //               collectionPageController.animateToPage(2, duration: Duration(seconds: 2), curve: CustomCurves.defaultIosSpring);
        //               PrimaryScrollController.of(context).animateTo(0, duration: Durations.extralong4, curve: CustomCurves.defaultIosSpring);
        //               collectionAnimController.reverse();
        //             }
        //           },
        //           shape: CircleBorder(),
        //           child: Icon(Iconsax.arrow_up_1),
        //         )
        //         : null,
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

            //Collections Section
            // CollectionsSectionHeader(
            //   scaffoldBgColor: scaffoldBgColor,
            //   appUiModel: appUiModel,
            //   onClickAddIcon:
            //       (courseModel.collectionIds == null || courseModel.collectionIds!.isEmpty)
            //           ? null
            //           : () {
            //             // Add Collection Function
            //           },
            //
            // ),

            CollectionsSection(
              appUiModel,
              collectionIds: courseModel.collectionIds == null ? ["This", "is", "this", ""] : courseModel.collectionIds!,
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

            SliverToBoxAdapter(child: ConstantSizing.columnSpacingSmall),


            ContentsSection(appUiModel, pageController: contentPageController, contentIds: courseModel.rootContentIds == null ? ["This", "is", "this", ""] : courseModel.rootContentIds!),

            // CustomText("Contents", fontWeight: FontWeight.bold, fontSize: 18,),
            // ConstantSizing.columnSpacingMedium,
            // _buildListButton("New Content", appUiModel.isDarkMode, onTap: (){}),
          ],
        ),
      ),
    );
  }

  // Widget _buildListButton(String title, bool isDarkMode, {required void Function() onTap}) {
  //   return InkWell(
  //     borderRadius: BorderRadius.circular(12),
  //     overlayColor: WidgetStatePropertyAll(Colors.deepPurple.withAlpha(40)),
  //     onTap: onTap,
  //     child: Container(
  //       decoration: UiStyles.getBlueThemedBoxDecoration(isDarkMode),
  //       padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),

  //       child: Row(children: [Icon(Iconsax.add_circle, size: 30), ConstantSizing.rowSpacingMedium, Expanded(child: CustomText(title))]),
  //     ),
  //   );
  // }
}
