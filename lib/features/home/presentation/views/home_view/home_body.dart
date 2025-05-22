import 'dart:developer';

import 'package:another_flushbar/flushbar.dart';
import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/core/utils/app_ui_state.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/features/home/presentation/views/home_view/home_app_bar.dart';
import 'package:slides_sync/features/home/presentation/views/home_view/home_body/recents_section_body.dart';
import 'package:slides_sync/shared/styles/app_ui_context.dart';
import 'package:slides_sync/shared/styles/colors.dart';
import 'package:slides_sync/shared/styles/external/ui_styles.dart';

import 'home_body/recents_section_header.dart';
import 'home_dash_board.dart';

class HomeBody extends ConsumerStatefulWidget {
  final AutoDisposeStateProvider<bool> isScrolledProvider;
  const HomeBody({super.key, required this.isScrolledProvider});

  @override
  ConsumerState createState() => _HomeBodyState();
}

class _HomeBodyState extends ConsumerState<HomeBody> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final bool isScrolled = ref.watch(widget.isScrolledProvider);
    final topPadding = context.padding.top;

    return NestedScrollView(
      physics: NeverScrollableScrollPhysics(),
      headerSliverBuilder: (context, isInnerBoxScrolled) {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => ref.read(widget.isScrolledProvider.notifier).update((cb) => isInnerBoxScrolled),
        );
        return [
          HomeAppBar(
            title: 'Happy Reading',
            isScrolled: isScrolled,
            topPadding: topPadding,
            onClickUserIcon: () {
              Scaffold.of(context).openDrawer();
              // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Theme.of(context).scaffoldBackgroundColor));
            },
            onToggleFullScreen: () {
              UiUtils.showFlushBar(context, msg: "Toggles full screen");
            },
            onClickNotification: () {},
          ),
        ];
      },

      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: ConstantSizing.columnSpacingMedium),

          // Dashboard Section
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
                    shrinkExtent: context.deviceWidth * 0.95,
                    itemExtent: context.deviceWidth,
                    children: [
                      HomeDashBoard(courseName: 'Foundation of Sequential Programming', detail: 'CSC 213', progressValue: 0.45, completed: false,),
                      HomeDashBoard(courseName: 'Software Workshop II', detail: 'CSC 211', progressValue: 0.45),
                      HomeDashBoard(courseName: 'Mathematical Methods I', detail: 'MAT 233', progressValue: 0.45),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(child: ConstantSizing.columnSpacingLarge),

          // Recents Section Header
          RecentsSectionHeader(),

          // Recents Section Body
          RecentsSectionBody(),

          SliverToBoxAdapter(child: ConstantSizing.columnSpacing(isScrolled ? kBottomNavigationBarHeight + topPadding : 0)),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
