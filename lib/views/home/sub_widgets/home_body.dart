import 'dart:developer';
import 'dart:ui';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/app/models/app_ui_model.dart';
import 'package:slides_sync/app/states/app_ui_state.dart';
import 'package:slides_sync/components/colors.dart';
import 'package:slides_sync/views/home/home.dart';
import 'package:slides_sync/views/home/sub_widgets/home_app_bar.dart';
import 'package:slides_sync/views/home/sub_widgets/recents_section/recents_section.dart';

import 'home_dash_board.dart';

class HomeBody extends ConsumerStatefulWidget {
  final AppUiModel appUiModel;
  final NotifierProvider<IsScrolled, bool> isScrolledProvider;
  final bool isScrolled;
  const HomeBody({super.key, required this.appUiModel, required this.isScrolledProvider, required this.isScrolled});

  @override
  ConsumerState createState() => _HomeBodyState();
}

class _HomeBodyState extends ConsumerState<HomeBody> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final topPadding = MediaQuery.paddingOf(context).top;

    return NestedScrollView(
      physics: NeverScrollableScrollPhysics(),
      headerSliverBuilder: (context, isInnerBoxScrolled) {
        WidgetsBinding.instance.addPostFrameCallback((_){ref.read(widget.isScrolledProvider.notifier).update(isInnerBoxScrolled);});
        return [
        HomeAppBar(appUiModel: widget.appUiModel, isScrolled: widget.isScrolled, topPadding: topPadding),
      ];
      },
      body: CustomScrollView(
        slivers: [

          SliverToBoxAdapter(child: ConstantSizing.columnSpacingMedium),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 200,
              child: NotificationListener(
                onNotification: (notification) => true,
                child: AnimatedSize(
                  duration: Durations.medium4,
                  child: CarouselView(
                      padding: EdgeInsets.zero,
                      backgroundColor: Colors.transparent,
                      enableSplash: false,
                      itemSnapping: true,
                      shrinkExtent: widget.appUiModel.deviceWidth * 0.75,
                      itemExtent: widget.appUiModel.deviceWidth, children: [
                    HomeDashBoard(widget: widget, courseName: 'Foundation of Sequential Programming(CSC 213)', detail: '200-Level First Semester', progressValue: 0.45,),
                    HomeDashBoard(widget: widget, courseName: 'Foundation of Sequential Programming(CSC 213)', detail: '200-Level First Semester', progressValue: 0.45,),
                    HomeDashBoard(widget: widget, courseName: 'Foundation of Sequential Programming(CSC 213)', detail: '200-Level First Semester', progressValue: 0.45,)

                  ]),
                ),
              ),
            ),
          ),

          PinnedHeaderSliver(child: ConstantSizing.columnSpacingLarge),

          ...recentSection(context, widget),

          SliverToBoxAdapter(child: ConstantSizing.columnSpacing(kBottomNavigationBarHeight + 8),)
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}



