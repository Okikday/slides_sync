import 'dart:developer';

import 'package:flutter/material.dart';

class TestAnimatedShrinkAppbar extends StatefulWidget {
  const TestAnimatedShrinkAppbar({super.key});

  @override
  State<TestAnimatedShrinkAppbar> createState() => _TestAnimatedShrinkAppbarState();
}

class _TestAnimatedShrinkAppbarState extends State<TestAnimatedShrinkAppbar> {
  late final ScrollController scrollController;
  late final ValueNotifier<double> scrollPercentNotifier;
  final double maxHeight = 300;
  final double minHeight = 100;
  final double topTitlePadding = 48;
  final Size ballSize = Size(200, 200);

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    scrollPercentNotifier = ValueNotifier(0.0);
    scrollController.addListener(updateOffset);
  }

  void updateOffset() {
    if (scrollPercentNotifier.value != scrollController.offset) {
      final topPadding = MediaQuery.paddingOf(context).top;
      final maxHeightMinusPadding = maxHeight - topPadding - topTitlePadding;
      final limitedScrollOffset = scrollController.offset.clamp(
        0,
        (maxHeightMinusPadding),
      );
      scrollPercentNotifier.value =
          ((limitedScrollOffset) / (maxHeightMinusPadding));
      log("scroll: ${scrollPercentNotifier.value}");
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(updateOffset);
    scrollController.dispose();
    scrollPercentNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    final topPadding = MediaQuery.paddingOf(context).top;
    final maxHeightMinusPadding = maxHeight - topPadding - (ballSize.height);
    final deviceWidth = MediaQuery.sizeOf(context).width;
    const double hPadding = 16;
    final maxWidthMinusPadding = deviceWidth - (hPadding * 2) - (ballSize.width);
    return Scaffold(
      backgroundColor: Colors.black54,
      body: NestedScrollView(
        controller: scrollController,
        headerSliverBuilder:
            (context, isInnerBoxScrolled) => [
              SliverAppBar.large(
                leadingWidth: null,
                leading: null,
                automaticallyImplyLeading: false,
                backgroundColor: Colors.black54,
                expandedHeight: maxHeight,
                collapsedHeight: minHeight,
                flexibleSpace: FlexibleSpaceBar(
                  stretchModes: [],
                  expandedTitleScale: 1.0,
                  titlePadding: EdgeInsets.only(
                    top: topTitlePadding,
                    left: hPadding,
                    right: hPadding,
                  ),
                  title: Stack(
                    alignment: Alignment.center,
                    fit: StackFit.passthrough,
                    children: [
                      ValueListenableBuilder(
                        valueListenable: scrollPercentNotifier,
                        builder: (context, value, child) {
                          return Positioned(
                            top:
                                double.parse(
                                  (1.0 - value).toStringAsFixed(2),
                                ) *
                                ((maxHeightMinusPadding) / 2),
                            right:
                                double.parse(
                                  (1.0 - value).toStringAsFixed(2),
                                ) *
                                ((maxWidthMinusPadding) / 2),
                            // bottom: 0,
                            // left: 0,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ValueListenableBuilder(
                                  valueListenable: scrollPercentNotifier,
                                  builder: (context, value, child) {
                                    return AnimatedContainer(
                                      duration: Durations.short1,
                                      height: ((ballSize.height) * (1- value)).clamp(40, ballSize.height),
                                      width: ((ballSize.width) * (1- value)).clamp(40, ballSize.width),
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        shape: BoxShape.circle,
                                      ),
                                    );
                                  }
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Text(
                          "Tasks",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
        body: Container(
          color: Colors.orange,
          child: CustomScrollView(
            
            slivers: [
              SliverList.builder(itemCount: 20, itemBuilder: (context, index){
                return ListTile(title: Text("data"),);
              }),
              SliverFillRemaining()
            ],
          ),
        ),
      ),
    );
  }
}
