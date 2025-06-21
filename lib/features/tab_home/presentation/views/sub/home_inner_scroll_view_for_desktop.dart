import 'dart:developer';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/features/tab_home/presentation/views/home_tab_view/home_body.dart';

class HomeInnerScrollViewForDesktop extends ConsumerStatefulWidget {
  const HomeInnerScrollViewForDesktop({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeInnerScrollViewForDesktopState();
}

class _HomeInnerScrollViewForDesktopState extends ConsumerState<HomeInnerScrollViewForDesktop> {
  late final AutoDisposeStateProvider<double> scrollOffsetNotifier;
  late final CarouselController carouselController;
  late final ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    carouselController = CarouselController();
    scrollController = ScrollController();
    scrollOffsetNotifier = AutoDisposeStateProvider((ref) => 0.0);
    carouselController.addListener(updateScrollOffset);
  }

  void updateScrollOffset() {
    if (scrollController.positions.isEmpty) return;
    final scrollOffsetNotif = ref.read(scrollOffsetNotifier.notifier);
    final newUpdate = scrollController.offset;
    if (newUpdate == scrollOffsetNotif.state) return;
    log("newUpdate: $newUpdate");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollOffsetNotif.update((cb) => newUpdate);
    });
  }

  @override
  void dispose() {
    carouselController.removeListener(updateScrollOffset);
    carouselController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalHeight = 200 + ConstantSizing.spaceMedium + ConstantSizing.spaceExtraLarge;
    return Stack(
      alignment: Alignment.topCenter,
      clipBehavior: Clip.hardEdge,
      children: [
        HomeBody(carouselController: carouselController, scrollController: scrollController),

        Positioned(
          height: (totalHeight - ref.watch(scrollOffsetNotifier)).clamp(0.0, totalHeight),
          left: 0,
          right: 0,
          child: Listener(
            behavior: HitTestBehavior.opaque,
            onPointerSignal: (event) {
              if (event is PointerScrollEvent) {
                carouselController.animateTo(
                  carouselController.offset + (event.scrollDelta.dy / (MediaQuery.devicePixelRatioOf(context))),
                  duration: Durations.short1,
                  curve: CustomCurves.bouncySpring,
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
