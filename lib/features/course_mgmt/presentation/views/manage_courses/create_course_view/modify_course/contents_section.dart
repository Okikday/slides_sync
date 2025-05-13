
import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/app/models/app_ui_model.dart';
import 'package:slides_sync/features/course_mgmt/presentation/viewmodels/notifiers/scroll_offset_notifier.dart';
import 'package:slides_sync/shared/styles/external/ui_styles.dart';
import 'package:stacked_card_carousel/stacked_card_carousel.dart';

import 'contents_section/content_list_tile.dart';



/// COLLECTION SECTION
class ContentsSection extends ConsumerStatefulWidget {
  final AppUiModel appUiModel;
  final List<String> contentIds;
  final PageController pageController;
  const ContentsSection(
      this.appUiModel, {
        super.key,
        required this.contentIds,
        required this.pageController,
      });

  @override
  ConsumerState createState() => _ContentsSectionState();
}

class _ContentsSectionState extends ConsumerState<ContentsSection> {
  late final NotifierProvider<ScrollOffsetNotifier, double> scrollOffsetNotifier;

  @override
  void initState() {
    super.initState();
    scrollOffsetNotifier = NotifierProvider<ScrollOffsetNotifier, double>(ScrollOffsetNotifier.new);
    widget.pageController.addListener(updateScrollOffset);
  }

  void updateScrollOffset() {
    ref.read(scrollOffsetNotifier.notifier).update(widget.pageController.position.maxScrollExtent - widget.pageController.offset);

    // widget.pageController.page!/((widget.collectionIds.length.clamp(0, 3) - 1))
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

    if (widget.contentIds.isEmpty) {
      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        sliver: _buildNewCollectionTile(appUiModel.isDarkMode, onTap: () {}),
      );
    }

    return SliverToBoxAdapter(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedSize(
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
                        88 / (5 - widget.contentIds.length.clamp(0, 3)) +
                        (ref.watch(scrollOffsetNotifier) / 2).clamp(0.0, 88 * (widget.contentIds.length.clamp(0, 3) - 1)),
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
                        items: List.generate(widget.contentIds.length.clamp(0, 3), (index) {
                          return RotatedBox(
                            quarterTurns: 2,
                            child: ContentListTile(title: "Context Free Grammar", subtitle: "4 pages", isDarkMode: appUiModel.isDarkMode)
                          );
                        }),
                      ),
                    ),
                  ),
                ),
              ).animate().fadeIn(),
            ),
          ),

          if (widget.contentIds.length > 3)
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16.0, top: 8),
              child:
              CustomElevatedButton(
                label: "See all Content",
                textColor: Colors.deepPurple,
                textSize: 14,
                backgroundColor: Colors.deepPurple.withAlpha(50),
                pixelHeight: 48,
                borderRadius: 48,
              ).animate().fadeIn().scale(),
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