import 'dart:developer';
import 'dart:ui';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/app.dart';
import 'package:slides_sync/app/models/app_ui_model.dart';
import 'package:slides_sync/use_cases/library/library_ui_funcs.dart';
import 'package:slides_sync/views/library/sub_pages/manage_courses/create_course/modify_course.dart';
import 'package:stacked_card_carousel/stacked_card_carousel.dart';

class PlainCollectionsSection extends ConsumerStatefulWidget {
  final AppUiModel appUiModel;
  const PlainCollectionsSection(this.appUiModel, {super.key});

  @override
  ConsumerState createState() => _PlainCollectionsSectionState();
}

class _PlainCollectionsSectionState extends ConsumerState<PlainCollectionsSection> {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        width: widget.appUiModel.deviceWidth,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 120, minHeight: 80),
          child: ListView.builder(
            itemCount: 4,
            padding: EdgeInsets.only(top: 16, left: 16, right: 16.0),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(left: 4, right: index == 4 ? 16 : 12),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 120),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(child: Icon(Iconsax.book)),
                      ConstantSizing.columnSpacingMedium,
                      CustomText("Today", textAlign: TextAlign.center),
                    ],
                  ),
                ),
              ).animate().moveX(begin: 40.0 * (index + 1), end: 0, curve: CustomCurves.bouncySpring, duration: Durations.extralong4).fadeIn();
            },
          ),
        ),
      ),
    );
  }
}

/// COLLECTION SECTION HEADER
class CollectionsSectionHeader extends ConsumerWidget {
  const CollectionsSectionHeader({
    super.key,
    required this.scaffoldBgColor,
    required this.appUiModel,
    required this.isPlainView,
    required this.onTapGridToggle,
  });

  final Color scaffoldBgColor;
  final AppUiModel appUiModel;

  final void Function() onTapGridToggle;
  final bool isPlainView;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PinnedHeaderSliver(
      child: ColoredBox(
        color: scaffoldBgColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
          child: Row(
            children: [
              Expanded(child: CustomText("Collections", fontSize: 18, fontWeight: FontWeight.bold)),

              CustomElevatedButton(
                contentPadding: EdgeInsets.all(12),
                backgroundColor: Colors.lightBlueAccent.withAlpha(40),
                shape: CircleBorder(),
                child: Icon(Iconsax.add_circle_copy, size: 20, color: appUiModel.isDarkMode ? Colors.white : Colors.black),
              ),
              ConstantSizing.rowSpacingMedium,

              CustomElevatedButton(
                contentPadding: EdgeInsets.all(8),
                backgroundColor: Colors.lightBlueAccent.withAlpha(40),
                shape: CircleBorder(),
                onClick: onTapGridToggle,
                child: Icon(
                  isPlainView ? Iconsax.menu : Icons.list_outlined,
                  size: 20,
                  color: appUiModel.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
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

class CollectionScrollOffsetNotifier extends Notifier<double>{
  @override
  double build() => 0.0;

  update(double value){
    if(state == value) return;
    state = value;
    log("updated scroll offset: $state");
  }
}

/// COLLECTION SECTION
class CollectionsSection extends ConsumerStatefulWidget {
  final AppUiModel appUiModel;
  final List<String> collectionIds;
  final NotifierProvider<IsSectionExpandedNotifier, bool> isCollectionSectionExpandedProvider;
  final ScrollController scrollController;
  final AnimationController animationController;
  final PageController pageController;
  const CollectionsSection(
    this.appUiModel, {
    super.key,
    required this.collectionIds,
    required this.isCollectionSectionExpandedProvider,
    required this.animationController,
    required this.scrollController,
    required this.pageController,
  });

  @override
  ConsumerState createState() => _CollectionsSectionState();
}

class _CollectionsSectionState extends ConsumerState<CollectionsSection> {
  late final Animation<double> anim;
  late final NotifierProvider<CollectionScrollOffsetNotifier, double> scrollOffsetNotifier;


  @override
  void initState() {
    super.initState();
    scrollOffsetNotifier = NotifierProvider<CollectionScrollOffsetNotifier, double>(CollectionScrollOffsetNotifier.new);
    anim = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: widget.animationController, curve: CustomCurves.decelerate, reverseCurve: CustomCurves.decelerate));
    widget.pageController.addListener(updateScrollOffset);
  }

  void updateScrollOffset() {
    log("${widget.pageController.position.pixels}");
    ref.read(scrollOffsetNotifier.notifier).update(widget.pageController.position.maxScrollExtent - widget.pageController.offset);
  }

  @override
  void dispose() {
    widget.pageController.removeListener(updateScrollOffset);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final NotifierProvider<IsSectionExpandedNotifier, bool> isExpandedProvider = widget.isCollectionSectionExpandedProvider;
    final bool isExpanded = ref.watch(isExpandedProvider);
    final AppUiModel appUiModel = widget.appUiModel;
    final PageController pageController = widget.pageController;
    final int count = 10;
    // if(widget.collectionIds.isEmpty){
    //   return _buildNewCollectionTile( appUiModel.isDarkMode, onTap: () {});
    // }

    return SliverToBoxAdapter(
      child: AnimatedSize(
        duration: Durations.extralong4,
        curve: CustomCurves.defaultIosSpring,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ClipRRect(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              child: Column(
                children: [
                  ConstantSizing.columnSpacingSmall,
                  AnimatedSize(
                    duration: Durations.medium1,
                    curve: CustomCurves.decelerate,
                    reverseDuration: Durations.medium1,
                    child: SizedBox(
                      height: 88 + ref.watch(scrollOffsetNotifier) + (88 / 2),
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
          ).animate().fadeIn(),
        ),
      ),
    );
  }
}





// AnimatedBuilder(
// animation: anim,
// builder: (context, child) {
// return Visibility(
// visible: isExpanded ? anim.value > 0.99 : anim.value > 0.01,
// maintainSize: false,
//
// child: ListView.builder(
// itemCount: count,
// shrinkWrap: true,
// controller: widget.scrollController,
// padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
// itemBuilder: (context, index) {
// return AnimatedSlide(
// offset: Offset(0, (-80.0 * index) * (1 - anim.value)),
// duration: Durations.medium1,
// child: Padding(
// padding: const EdgeInsets.symmetric(vertical: 8),
// child: _buildCollectionListTile(
// appUiModel,
// collectionTitle: "Textbooks",
// iconData: Iconsax.book,
// collectionCount: 3,
// contentCount: 10,
// ),
// ),
// );
// },
// ).animate().moveY(begin: -40, end: 0),
// );
// },
// ),