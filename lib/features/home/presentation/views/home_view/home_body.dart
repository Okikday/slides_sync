
import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/core/utils/app_ui_state.dart';
import 'package:slides_sync/features/home/presentation/viewmodels/home_vm/notifiers/is_home_scrolled_notifer.dart';
import 'package:slides_sync/features/home/presentation/views/home_view/home_app_bar.dart';
import 'package:slides_sync/features/home/presentation/views/home_view/home_body/recents_section_body.dart';

import 'home_body/recents_section_header.dart';
import 'home_dash_board.dart';

class HomeBody extends ConsumerStatefulWidget {
  final NotifierProvider<AppUiState, AppUiModel> appUiStateProvider;
  final NotifierProvider<IsHomeScrolledNotifier, bool> isScrolledProvider;
  const HomeBody(this.appUiStateProvider, {super.key, required this.isScrolledProvider});

  @override
  ConsumerState createState() => _HomeBodyState();
}

class _HomeBodyState extends ConsumerState<HomeBody> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final AppUiModel appUiModel = ref.watch(widget.appUiStateProvider);
    final bool isScrolled = ref.watch(widget.isScrolledProvider);
    final topPadding = MediaQuery.paddingOf(context).top;

    return NestedScrollView(
      physics: NeverScrollableScrollPhysics(),
      headerSliverBuilder: (context, isInnerBoxScrolled) {
        WidgetsBinding.instance.addPostFrameCallback((_) => ref.read(widget.isScrolledProvider.notifier).update(isInnerBoxScrolled));
        return [
          HomeAppBar(
            title: 'Happy Reading',
            appUiModel: appUiModel,
            isScrolled: isScrolled,
            topPadding: topPadding,
            onClickUserIcon: () {
              Scaffold.of(context).openDrawer();
              // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Theme.of(context).scaffoldBackgroundColor));
            },
            onToggleFullScreen: () {},
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
                    shrinkExtent: appUiModel.deviceWidth * 0.95,
                    itemExtent: appUiModel.deviceWidth,
                    children: [
                      HomeDashBoard(
                        appUiModel: appUiModel,
                        courseName: 'Foundation of Sequential Programming',
                        detail: 'CSC 213',
                        progressValue: 0.45,
                      ),
                      HomeDashBoard(appUiModel: appUiModel, courseName: 'Software Workshop II', detail: 'CSC 211', progressValue: 0.45),
                      HomeDashBoard(appUiModel: appUiModel, courseName: 'Mathematical Methods I', detail: 'MAT 233', progressValue: 0.45),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(child: ConstantSizing.columnSpacingLarge),

          // Recents Section Header
          RecentsSectionHeader(appUiModel: appUiModel),

          // Recents Section Body
          RecentsSectionBody(appUiModel: appUiModel),

          SliverToBoxAdapter(
            child: ConstantSizing.columnSpacing(isScrolled ? kBottomNavigationBarHeight + topPadding : 0),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
