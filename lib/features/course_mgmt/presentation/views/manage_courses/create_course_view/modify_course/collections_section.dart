
import 'dart:developer';
import 'dart:ui';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/core/models/app_ui_model.dart';
import 'package:slides_sync/features/course_mgmt/presentation/viewmodels/notifiers/modify_course/can_scroll_notifier.dart';
import 'package:slides_sync/features/course_mgmt/presentation/viewmodels/notifiers/scroll_offset_notifier.dart';
import 'package:slides_sync/shared/styles/external/ui_styles.dart';
import 'package:stacked_card_carousel/stacked_card_carousel.dart';



/// COLLECTION SECTION
class CollectionsSection extends ConsumerStatefulWidget {
  final AppUiModel appUiModel;
  final List<String> collectionIds;
  final PageController pageController;
  const CollectionsSection(
    this.appUiModel, {
    super.key,
    required this.collectionIds,
    required this.pageController,
  });

  @override
  ConsumerState createState() => _CollectionsSectionState();
}

class _CollectionsSectionState extends ConsumerState<CollectionsSection> {
  late final NotifierProvider<ScrollOffsetNotifier, double> scrollOffsetNotifier;
  late final NotifierProvider<CanScrollNotifier, bool> canScrollNotifier;


  @override
  void initState() {
    super.initState();
    scrollOffsetNotifier = NotifierProvider<ScrollOffsetNotifier, double>(ScrollOffsetNotifier.new);
    canScrollNotifier = NotifierProvider<CanScrollNotifier, bool>(CanScrollNotifier.new);
    widget.pageController.addListener(updateScrollOffset);
  }

  void updateScrollOffset() {
    ref.read(scrollOffsetNotifier.notifier).update(widget.pageController.position.maxScrollExtent - widget.pageController.offset);
    if(widget.pageController.page == 0) ref.read(canScrollNotifier.notifier).update(true);
  }

  @override
  void dispose() {
    widget.pageController.removeListener(updateScrollOffset);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppUiModel appUiModel = widget.appUiModel;
    final PageController pageController = widget.pageController;
    // final int count = 10;

    if (widget.collectionIds.isEmpty) {
      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        sliver: _buildNewCollectionTile(appUiModel.isDarkMode, onTap: () {}),
      );
    }

    return SliverToBoxAdapter(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NotificationListener(
            onNotification: (notification){
              log("notification");
              if(notification is ScrollStartNotification){
                log("At the start: ${notification.metrics.pixels}");
              }else if(notification is ScrollEndNotification){
                log("At the end: ${notification.metrics.pixels}");
              }else if(notification is ScrollUpdateNotification){
                log("At an update: ${notification.metrics.pixels}");
              }

              return true;
            },
            child: AnimatedSize(
              duration: Durations.short2,
              curve: CustomCurves.decelerate,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child:
                    ClipRRect(
                      child: AnimatedSize(
                        duration: Durations.extralong4,
                        curve: CustomCurves.bouncySpring,
                        reverseDuration: Durations.extralong1,
                        child: SizedBox(
                          height:
                              88 +
                              88 / (5 - widget.collectionIds.length.clamp(0, 3)) +
                              (ref.watch(scrollOffsetNotifier) / 2).clamp(0.0, 88 * (widget.collectionIds.length.clamp(0, 3) - 1)),
                          //
                          child: RotatedBox(
                            quarterTurns: 2,
                            child: StackedCardCarousel(
                              initialOffset: 0,
                              spaceBetweenItems: 80,
                              pageController: pageController,
                              // onPageChanged: (int currIndex) {
                              //   pageController.previousPage(duration: Durations.extralong1, curve: CustomCurves.bouncySpring);
                              // },
                              items: List.generate(widget.collectionIds.length.clamp(0, 3), (index) {
                                return RotatedBox(
                                  quarterTurns: 2,
                                  child: _buildCollectionListTile(
                                    appUiModel,
                                    collectionTitle: "Textbooks",
                                    iconData: Iconsax.book,
                                    subCollectionCount: 3,
                                    contentCount: 10,
                                  ),
                                );
                              }),
                            ),
                          ),
                        ),
                      ),
                    ).animate().fadeIn(),
              ),
            ),
          ),
        ],
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
          decoration:UiStyles.getBlueThemedBoxDecoration(isDarkMode),
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
  int subCollectionCount = 0,
  int contentCount = 0,
  // void Function()? onTap,
}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(16),
    child: ColoredBox(
      color: appUiModel.isDarkMode ? Color(0xFF143850) : Color(0xFFDBF3FF),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          height: 80,
          clipBehavior: Clip.hardEdge,
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          //Color(0xFF485BAD)
          decoration: BoxDecoration(
            color: appUiModel.isDarkMode ? Color(0xFF163343).withValues(alpha: 0.89) : Color(0xFFDBF3FF).withValues(alpha: 0.89),

            borderRadius: BorderRadius.circular(12),
            border: Border.fromBorderSide(BorderSide.none),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: Row(
              children: [
                CircleAvatar(backgroundColor: Colors.lightBlueAccent.withAlpha(25), child: Icon(iconData, color: appUiModel.isDarkMode ? Colors.white : Colors.black,)),
                ConstantSizing.rowSpacingMedium,
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(collectionTitle, fontWeight: FontWeight.bold,),
                      ConstantSizing.columnSpacing(4),
                      if (subCollectionCount > 0 || contentCount > 0)
                        CustomText(
                          "${subCollectionCount < 1 ? '' : "$subCollectionCount collections"}${(contentCount > 0 && subCollectionCount > 0) ? ", " : ''}${contentCount < 1 ? '' : "$contentCount content"}",
                          fontSize: 10.5,
                          color: Colors.grey,
                        ),
                    ],
                  ),
                ),
                ConstantSizing.rowSpacingMedium,
                Icon(Iconsax.arrow_right, color: appUiModel.isDarkMode ? Colors.white : Colors.black,),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}