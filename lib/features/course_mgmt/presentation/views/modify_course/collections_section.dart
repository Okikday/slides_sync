
import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/features/course_navigation/presentation/views/course_navigation/collection_card_tile.dart';
import 'package:slides_sync/shared/styles/app_ui_context.dart';
import 'package:slides_sync/shared/styles/external/ui_styles.dart';
import 'package:stacked_card_carousel/stacked_card_carousel.dart';

/// COLLECTION SECTION
class CollectionsSection extends ConsumerStatefulWidget {
  final List<String> collections;
  final PageController pageController;
  const CollectionsSection({super.key, required this.collections, required this.pageController});

  @override
  ConsumerState createState() => _CollectionsSectionState();
}

class _CollectionsSectionState extends ConsumerState<CollectionsSection> {
  late final AutoDisposeStateProvider<double> scrollOffsetNotifier;
  late final AutoDisposeStateProvider<bool> canScrollNotifier;

  @override
  void initState() {
    super.initState();
    scrollOffsetNotifier = AutoDisposeStateProvider<double>((ref) => 0.0);
    canScrollNotifier = AutoDisposeStateProvider<bool>((ref) => false);
    widget.pageController.addListener(updateScrollOffset);
  }

  void updateScrollOffset() {
    final scrollOffsetNotif = ref.read(scrollOffsetNotifier.notifier);
    final newUpdate = widget.pageController.position.maxScrollExtent - widget.pageController.offset;
    if (newUpdate == scrollOffsetNotif.state) return;
    scrollOffsetNotif.update((cb) => widget.pageController.position.maxScrollExtent - widget.pageController.offset);
    if (widget.pageController.page == 0) ref.read(canScrollNotifier.notifier).update((cb) => true);
  }

  @override
  void dispose() {
    widget.pageController.removeListener(updateScrollOffset);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final PageController pageController = widget.pageController;
    // final int count = 10;

    if (widget.collections.isEmpty) {
      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        sliver: _buildNewCollectionTile(context.isDarkMode, onTap: () {}),
      );
    }

    return SliverToBoxAdapter(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NotificationListener(
            onNotification: (notification) => true,
            child: AnimatedSize(
              duration: Durations.short2,
              curve: CustomCurves.decelerate,
              child:
                  ClipRRect(
                    child: AnimatedSize(
                      duration: Durations.extralong4,
                      curve: CustomCurves.bouncySpring,
                      reverseDuration: Durations.extralong1,
                      child: SizedBox(
                        height:
                            (88 +
                            88 / (5 - widget.collections.length.clamp(0, 3)) +
                            (ref.watch(scrollOffsetNotifier) / 2).clamp(0.0, 88 * (widget.collections.length.clamp(0, 3) - 1))),
                        //
                        child: RotatedBox(
                          quarterTurns: 2,
                          child: StackedCardCarousel(
                            initialOffset: 0,
                            spaceBetweenItems: 80,
                            pageController: pageController,
                            items: List.generate(widget.collections.length.clamp(0, 3), (index) {
                              return RotatedBox(
                                quarterTurns: 2,
                                child: CollectionCardTile(context.isDarkMode, title: widget.collections[index], contentCount: 12),
                              );
                            }),
                          ),
                        ),
                      ),
                    ),
                  ).animate().fadeIn(),
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
          decoration: UiStyles.getBlueThemedBoxDecoration(isDarkMode),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),

          child: Row(
            children: [Icon(Iconsax.add_circle, size: 30), ConstantSizing.rowSpacingMedium, Expanded(child: CustomText("New Collection"))],
          ),
        ),
      ),
    ),
  );
}
