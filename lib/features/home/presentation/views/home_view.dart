import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/app/states/app_ui_state.dart';
import 'package:slides_sync/features/home/presentation/viewmodels/home_vm/notifiers/home_nav_bar_index_notifier.dart';
import 'package:slides_sync/features/home/presentation/viewmodels/home_vm/notifiers/is_home_scrolled_notifer.dart';
import 'package:slides_sync/features/home/presentation/views/home_view/home_drawer.dart';
import 'package:slides_sync/features/home_library/presentation/views/library_tab_view.dart';
import 'package:slides_sync/features/home_explore/presentation/views/explore_tab_view.dart';

import 'home_view/home_body.dart';
import 'home_view/home_bottom_nav_bar.dart';

class HomeView extends ConsumerStatefulWidget {
  final int tabIndex;
  const HomeView({super.key, required this.tabIndex});

  @override
  ConsumerState createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> with AutomaticKeepAliveClientMixin {
  late final NotifierProvider<HomeNavBarIndexNotifier, int> homeNavBarIndexProvider;
  late final NotifierProvider<IsHomeScrolledNotifier, bool> isScrolledProvider;
  late final PageController pageController;

  @override
  void initState() {
    super.initState();
    homeNavBarIndexProvider = NotifierProvider<HomeNavBarIndexNotifier, int>(HomeNavBarIndexNotifier.new);
    isScrolledProvider = NotifierProvider<IsHomeScrolledNotifier, bool>(IsHomeScrolledNotifier.new);
    pageController = PageController(initialPage: widget.tabIndex);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homeNavBarIndexProvider.notifier).update(widget.tabIndex);
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final AppUiModel appUiModel = ref.watch(appUiStateProvider);
    final int homeNavBarIndex = ref.watch(homeNavBarIndexProvider);
    final bool isScrolled = ref.watch(isScrolledProvider);
    final Color scaffoldBgColor = Theme.of(context).scaffoldBackgroundColor;

    return PopScope(
      canPop: false,
      child: AnnotatedRegion(
        value: SystemUiOverlayStyle(
          statusBarColor: isScrolled ? Colors.lightBlueAccent.withAlpha(100) : scaffoldBgColor,
          statusBarBrightness: appUiModel.isDarkMode ? Brightness.light : Brightness.dark,
          statusBarIconBrightness: appUiModel.isDarkMode ? Brightness.light : Brightness.dark,
          systemNavigationBarIconBrightness: appUiModel.isDarkMode ? Brightness.light : Brightness.dark,
          systemNavigationBarColor: (appUiModel.isDarkMode ? Color(0xff0e1d27) : Color(0xffd6ebf9)),
        ),

        child: Scaffold(
          extendBody: true,

          bottomNavigationBar: HomeBottomNavBar(
            appUiModel: appUiModel,
            currentIndex: homeNavBarIndex,
            isScrolled: isScrolled,
            onTap: (index) {
              if (index != homeNavBarIndex) {
                ref.read(homeNavBarIndexProvider.notifier).update(index);
                pageController.animateToPage(index, duration: Duration(milliseconds: 400), curve: CustomCurves.decelerate);
              }
            },
          ),

          drawer: HomeDrawer(appUiModel: appUiModel, scaffoldBgColor: scaffoldBgColor),

          body: PageView(
            controller: pageController,
            onPageChanged: (index) {
              ref.read(homeNavBarIndexProvider.notifier).update(index);
            },
            children: [
              HomeBody(appUiStateProvider, isScrolledProvider: isScrolledProvider),
              LibraryView(appUiStateProvider),
              ExploreTabView(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
