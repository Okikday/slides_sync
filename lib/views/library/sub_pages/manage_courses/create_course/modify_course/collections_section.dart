import 'dart:developer';
import 'dart:ui';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/app/models/app_ui_model.dart';
import 'package:slides_sync/use_cases/library/library_ui_funcs.dart';
import 'package:slides_sync/views/library/sub_pages/manage_courses/create_course/modify_course.dart';
import 'package:stacked_card_carousel/stacked_card_carousel.dart';

/// COLLECTION SECTION 1
class CollectionsSection1 extends ConsumerStatefulWidget {
  final AppUiModel appUiModel;
  final List<String> collectionIds;
  final NotifierProvider<IsSectionExpandedNotifier, bool> isCollectionSectionExpandedProvider;
  final ScrollController scrollController;
  final AnimationController animationController;
  final PageController pageController;
  final void Function() onTapCollapsed;
  const CollectionsSection1(
    this.appUiModel, {
    super.key,
    required this.collectionIds,
    required this.isCollectionSectionExpandedProvider,
    required this.animationController,
    required this.scrollController,
    required this.pageController,
    required this.onTapCollapsed,
  });

  @override
  ConsumerState createState() => _CollectionsSection1State();
}

class _CollectionsSection1State extends ConsumerState<CollectionsSection1> {
  late final Animation<double> anim;

  @override
  void initState() {
    super.initState();
    anim = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: widget.animationController, curve: CustomCurves.decelerate, reverseCurve: CustomCurves.decelerate));
  }

  @override
  Widget build(BuildContext context) {
    final NotifierProvider<IsSectionExpandedNotifier, bool> isExpandedProvider = widget.isCollectionSectionExpandedProvider;
    final bool isExpanded = ref.watch(isExpandedProvider);
    final AppUiModel appUiModel = widget.appUiModel;
    final PageController pageController = widget.pageController;

    // if(widget.collectionIds.isEmpty){
    //   return _buildNewCollectionTile( appUiModel.isDarkMode, onTap: () {});
    // }

    return AnimatedBuilder(
      animation: anim,
      builder: (context, child) {
        return SliverVisibility(
          visible: anim.value < 0.01,
          maintainSize: false,
          maintainState: true,
          maintainAnimation: true,
          sliver: SliverToBoxAdapter(
            child: AnimatedScale(
              scale: 1 - anim.value,
              duration: Durations.short4,
              child: ClipRRect(
                child: GestureDetector(
                  onTap: widget.onTapCollapsed,
                  behavior: HitTestBehavior.opaque,
                  child: IgnorePointer(
                    ignoring: isExpanded ? false : true,
                    child: Column(
                      children: [
                        ConstantSizing.columnSpacingSmall,
                        AnimatedSize(
                          duration: Durations.medium1,
                          curve: CustomCurves.decelerate,
                          reverseDuration: Durations.medium1,
                          child: SizedBox(
                            height: isExpanded ? 88 * 3 + 24 : 88 + (88 / 2),
                            child: RotatedBox(
                              quarterTurns: 2,
                              child: StackedCardCarousel(
                                initialOffset: 0,
                                spaceBetweenItems: 80,
                                pageController: pageController,
                                // onPageChanged: (int currIndex) {
                                //   pageController.previousPage(duration: Durations.extralong1, curve: CustomCurves.bouncySpring);
                                // },
                                items: List.generate(isExpanded ? 10 : 3, (index) {
                                  return RotatedBox(
                                    quarterTurns: 2,
                                    child: _buildCollectionListTile(
                                      appUiModel,
                                      collectionTitle: "Textbooks",
                                      iconData: Iconsax.book,
                                      collectionCount: 3,
                                      contentCount: 10,
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ),
                        ),
                        // _buildCollectionListTile(appUiModel, collectionTitle: "Textbooks", iconData: Iconsax.book, collectionCount: 3, contentCount: 10),
                        ConstantSizing.columnSpacingExtraLarge,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    ).animate().fadeIn();
  }
}

/// COLLECTION SECTION 2
class CollectionsSection2 extends ConsumerStatefulWidget {
  final AppUiModel appUiModel;
  final List<String> collectionIds;
  final NotifierProvider<IsSectionExpandedNotifier, bool> isCollectionSectionExpandedProvider;
  final ScrollController scrollController;
  final AnimationController animationController;
  final PageController pageController;
  final void Function() onTapCollapsed;
  const CollectionsSection2(
    this.appUiModel, {
    super.key,
    required this.collectionIds,
    required this.isCollectionSectionExpandedProvider,
    required this.animationController,
    required this.scrollController,
    required this.pageController,
    required this.onTapCollapsed,
  });

  @override
  ConsumerState createState() => _CollectionsSection2State();
}

class _CollectionsSection2State extends ConsumerState<CollectionsSection2> {
  late final Animation<double> anim;

  @override
  void initState() {
    super.initState();
    anim = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: widget.animationController, curve: CustomCurves.decelerate, reverseCurve: CustomCurves.decelerate));
  }

  @override
  Widget build(BuildContext context) {
    final NotifierProvider<IsSectionExpandedNotifier, bool> isExpandedProvider = widget.isCollectionSectionExpandedProvider;
    final bool isExpanded = ref.watch(isExpandedProvider);
    final AppUiModel appUiModel = widget.appUiModel;
    final PageController pageController = widget.pageController;

    // if(widget.collectionIds.isEmpty){
    //   return _buildNewCollectionTile( appUiModel.isDarkMode, onTap: () {});
    // }

    return AnimatedBuilder(
      animation: anim,
      builder: (context, child) {
        return SliverVisibility(
          visible: isExpanded,
          maintainSize: false,

          sliver: SliverList.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              return AnimatedSlide(
                offset: Offset(0, (-80.0 * index) * (1 - anim.value)),
                duration: Durations.medium1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: _buildCollectionListTile(
                    appUiModel,
                    collectionTitle: "Textbooks",
                    iconData: Iconsax.book,
                    collectionCount: 3,
                    contentCount: 10,
                  ),
                ),
              ).animate().fadeIn();
            },
          ),
        );
      },
    );
  }
}






/// COLLECTION SECTION HEADER
class CollectionsSectionHeader extends ConsumerWidget {
  const CollectionsSectionHeader({super.key, required this.scaffoldBgColor, required this.appUiModel});

  final Color scaffoldBgColor;
  final AppUiModel appUiModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PinnedHeaderSliver(
      child: ColoredBox(
        color: scaffoldBgColor,
        child: Row(
          children: [
            Expanded(child: CustomText("Collections", fontSize: 18, fontWeight: FontWeight.bold)),

            CustomElevatedButton(
              contentPadding: EdgeInsets.all(12),
              backgroundColor: Colors.lightBlueAccent.withAlpha(40),
              shape: CircleBorder(),
              child: Icon(Iconsax.add_circle_copy, size: 20, color: appUiModel.isDarkMode ? Colors.white : Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildNewCollectionTile(bool isDarkMode, {required void Function() onTap}) {
  return SliverToBoxAdapter(
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        overlayColor: WidgetStatePropertyAll(Colors.deepPurple.withAlpha(40)),
        onTap: onTap,
        child: Container(
          decoration: LibraryUiFuncs.getBoxDecorationStyle(isDarkMode),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),

          child: Row(
            children: [Icon(Iconsax.add_circle, size: 30), ConstantSizing.rowSpacingMedium, Expanded(child: CustomText("New Collection"))],
          ),
        ),
      ),
    ),
  );
}

Widget _buildCollectionListTile(
  AppUiModel appUiModel, {
  required String collectionTitle,
  required IconData iconData,
  int collectionCount = 0,
  int contentCount = 0,
  // void Function()? onTap,
}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(16),
    child: ColoredBox(
      color: Color.fromARGB(255, 38, 50, 73),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          height: 80,
          clipBehavior: Clip.hardEdge,
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          //Color(0xFF485BAD)
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 44, 55, 82),
            borderRadius: BorderRadius.circular(12),
            border: Border.fromBorderSide(BorderSide.none),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: Row(
              children: [
                CircleAvatar(backgroundColor: Colors.lightBlueAccent.withAlpha(25), child: Icon(iconData)),
                ConstantSizing.rowSpacingMedium,
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(collectionTitle, fontWeight: FontWeight.bold),
                      ConstantSizing.columnSpacing(4),
                      if (collectionCount > 0 || contentCount > 0)
                        CustomText(
                          "${collectionCount < 1 ? '' : "$collectionCount collections"}${(contentCount > 0 && collectionCount > 0) ? ", " : ''}${contentCount < 1 ? '' : "$contentCount content"}",
                          fontSize: 10.5,
                          color: Colors.blueGrey,
                        ),
                    ],
                  ),
                ),
                ConstantSizing.rowSpacingMedium,
                Icon(Iconsax.play_circle),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
