import 'dart:developer';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/app/states/app_ui_state.dart';
import 'package:slides_sync/components/widgets/app_bar_container.dart';
import 'package:slides_sync/components/widgets/component_widgets.dart';
import 'package:slides_sync/use_cases/library/library_ui_funcs.dart';
import 'package:slides_sync/use_cases/library/models/course_model.dart';
import 'package:slides_sync/views/library/sub_pages/manage_courses/create_course/modify_course/modify_course_header.dart';

import 'modify_course/build_add_description_dialog.dart';
import 'modify_course/collections_section.dart';
import 'modify_course/contents_section.dart';

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

class ModifyCourse extends ConsumerStatefulWidget {
  final NotifierProvider<AppUiState, AppUiModel> appUiStateProvider;
  final CourseModel courseModel;
  const ModifyCourse(this.appUiStateProvider, {super.key, required this.courseModel});

  @override
  ConsumerState createState() => _ModifyCourseState();
}

class _ModifyCourseState extends ConsumerState<ModifyCourse> with TickerProviderStateMixin{
  final ScrollController mainPageScrollController = ScrollController();
  late final NotifierProvider<ModifyCourseModelNotifier, CourseModel> modifyCourseProvider;
  late final NotifierProvider<IsSectionExpandedNotifier, bool> isCollectionSectionExpandedProvider;
  late final NotifierProvider<IsSectionExpandedNotifier, bool> isContentSectionExpandedProvider;

  late final AnimationController collectionAnimController;
  late final AnimationController contentAnimController;

  late final PageController collectionPageController;
  late final PageController contentPageController;

  @override
  void initState() {
    super.initState();
    collectionAnimController = AnimationController(vsync: this, duration: Durations.medium1, reverseDuration: Durations.medium1);
    contentAnimController = AnimationController(vsync: this, duration: Durations.extralong4, reverseDuration: Durations.extralong2);
    modifyCourseProvider = NotifierProvider<ModifyCourseModelNotifier, CourseModel>(ModifyCourseModelNotifier.new);
    isCollectionSectionExpandedProvider = NotifierProvider<IsSectionExpandedNotifier, bool>(IsSectionExpandedNotifier.new);
    isContentSectionExpandedProvider = NotifierProvider<IsSectionExpandedNotifier, bool>(IsSectionExpandedNotifier.new);
    WidgetsBinding.instance.addPostFrameCallback((_) => ref.read(modifyCourseProvider.notifier).update(widget.courseModel));
    collectionPageController = PageController(initialPage: 4);
    contentPageController = PageController(initialPage: 4);
  }

  @override
  void dispose() {
    collectionPageController.dispose();
    contentPageController.dispose();
    collectionAnimController.dispose();
    contentAnimController.dispose();
    mainPageScrollController.dispose();
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
                  ComponentWidgets.backButton(context),
                  ConstantSizing.rowSpacingMedium,
                  Expanded(child: CustomText("Modify Course", fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ),

        floatingActionButton:
            ref.watch(isCollectionSectionExpandedProvider)
                ? FloatingActionButton.small(onPressed: () {
              if(ref.watch(isCollectionSectionExpandedProvider)){
                ref.read(isCollectionSectionExpandedProvider.notifier).update(false);
                collectionPageController.animateToPage(2, duration: Duration(seconds: 2), curve: CustomCurves.defaultIosSpring);
                collectionAnimController.reverse();
              }
            }, shape: CircleBorder(), child: Icon(Iconsax.arrow_up_1))
                : null,

        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: CustomScrollView(
            controller: mainPageScrollController,
            slivers: [
              ModifyCourseHeader(
                title: courseModel.courseTitle,
                description: courseModel.description,
                onClickAddDescription: () {
                  LoadingDialog.showLoadingDialog(
                    context,
                    canPop: true,
                    loadingInfoWidget: BuildAddDescriptionDialog(
                      appUiModel: appUiModel,
                      title: courseModel.courseTitle,
                      courseProvider: modifyCourseProvider,
                    ),
                  );
                },
              ),

              SliverToBoxAdapter(child: ConstantSizing.columnSpacingExtraLarge),

              //Collections Section
              CollectionsSectionHeader(scaffoldBgColor: scaffoldBgColor, appUiModel: appUiModel),

              CollectionsSection1(
                appUiModel,
                scrollController: mainPageScrollController,
                isCollectionSectionExpandedProvider: isCollectionSectionExpandedProvider,
                pageController: collectionPageController,
                animationController: collectionAnimController,
                onTapCollapsed: () async {
                  log("Tapped collapsed card");
                  if (!ref.watch(isCollectionSectionExpandedProvider)) {
                    ref.read(isCollectionSectionExpandedProvider.notifier).update(true);
                    collectionPageController.animateToPage(0, duration: Durations.extralong4, curve: CustomCurves.defaultIosSpring);
                    collectionAnimController.forward();
                  }
                },
                collectionIds: [],
              ),
              CollectionsSection2(
                appUiModel,
                scrollController: mainPageScrollController,
                isCollectionSectionExpandedProvider: isCollectionSectionExpandedProvider,
                pageController: collectionPageController,
                animationController: collectionAnimController,
                onTapCollapsed: () async {
                  log("Tapped collapsed card");
                  if (!ref.watch(isCollectionSectionExpandedProvider)) {
                    ref.read(isCollectionSectionExpandedProvider.notifier).update(true);
                    collectionPageController.animateToPage(0, duration: Durations.extralong4, curve: CustomCurves.defaultIosSpring);
                    collectionAnimController.forward();
                  }
                },
                collectionIds: [],
              ),

              SliverToBoxAdapter(child: ConstantSizing.columnSpacingMedium),

              // CustomText("Contents", fontWeight: FontWeight.bold, fontSize: 18,),
              // ConstantSizing.columnSpacingMedium,
              // _buildListButton("New Content", appUiModel.isDarkMode, onTap: (){}),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListButton(String title, bool isDarkMode, {required void Function() onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      overlayColor: WidgetStatePropertyAll(Colors.deepPurple.withAlpha(40)),
      onTap: onTap,
      child: Container(
        decoration: LibraryUiFuncs.getBoxDecorationStyle(isDarkMode),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),

        child: Row(children: [Icon(Iconsax.add_circle, size: 30), ConstantSizing.rowSpacingMedium, Expanded(child: CustomText(title))]),
      ),
    );
  }
}

// CircleAvatar(radius: 40, child: Icon(Iconsax.book),),
// ConstantSizing.columnSpacingMedium,
// CustomText("Introduction to Java Programming", fontSize: 20, fontWeight: FontWeight.bold,),
// ConstantSizing.columnSpacingMedium,
// CustomText("Add description", textAlign: TextAlign.center, color: Colors.deepPurple, ),
