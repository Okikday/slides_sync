import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/core/utils/app_ui_state.dart';
import 'package:slides_sync/features/home/presentation/viewmodels/home_vm/notifiers/home_nav_bar_index_notifier.dart';
import 'package:slides_sync/features/home/presentation/viewmodels/home_vm/notifiers/is_home_scrolled_notifer.dart';
import 'package:slides_sync/features/home/presentation/views/home_view/home_drawer.dart';
import 'package:slides_sync/features/home_library/presentation/views/library_tab_view.dart';
import 'package:slides_sync/features/home_explore/presentation/views/explore_tab_view.dart';
import 'package:slides_sync/shared/styles/app_ui_context.dart';

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
    final int homeNavBarIndex = ref.watch(homeNavBarIndexProvider);
    final bool isScrolled = ref.watch(isScrolledProvider);
    

    return PopScope(
      canPop: false,
      child: AnnotatedRegion(
        value: SystemUiOverlayStyle(
          statusBarColor: isScrolled ? Colors.lightBlueAccent.withAlpha(100) : context.scaffoldBackgroundColor,
          statusBarBrightness: context.isDarkMode ? Brightness.light : Brightness.dark,
          statusBarIconBrightness: context.isDarkMode ? Brightness.light : Brightness.dark,
          systemNavigationBarIconBrightness: context.isDarkMode ? Brightness.light : Brightness.dark,
          systemNavigationBarColor: (context.isDarkMode ? Color(0xff0e1d27) : Color(0xffd6ebf9)),
        ),

        child: Scaffold(
          extendBody: true,

          bottomNavigationBar: HomeBottomNavBar(
            currentIndex: homeNavBarIndex,
            isScrolled: isScrolled,
            onTap: (index) {
              if (index != homeNavBarIndex) {
                ref.read(homeNavBarIndexProvider.notifier).update(index);
                pageController.animateToPage(index, duration: Duration(milliseconds: 600), curve: CustomCurves.defaultIosSpring);
              }
            },
          ),

          drawer: HomeDrawer(),

          body: PageView(
            controller: pageController,
            onPageChanged: (index) {
              ref.read(homeNavBarIndexProvider.notifier).update(index);
            },
            children: [
              HomeBody(isScrolledProvider: isScrolledProvider),
              LibraryView(),
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
