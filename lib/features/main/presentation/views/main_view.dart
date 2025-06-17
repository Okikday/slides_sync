import 'dart:developer';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/features/main/presentation/providers/main_view_providers.dart';
import 'package:slides_sync/features/main/presentation/views/home_tab_view/home_drawer.dart';
import 'package:slides_sync/features/main/presentation/views/library_tab_view.dart';
import 'package:slides_sync/features/main/presentation/views/explore_tab_view.dart';
import 'package:slides_sync/features/main/presentation/views/library_tab_view/library_floating_action_button.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

import 'home_tab_view.dart';
import 'home_tab_view/home_bottom_nav_bar.dart';

class MainView extends ConsumerStatefulWidget {
  final int tabIndex;
  const MainView({super.key, required this.tabIndex});

  @override
  ConsumerState createState() => _MainViewState();
}

class _MainViewState extends ConsumerState<MainView> with AutomaticKeepAliveClientMixin {
  late final PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: widget.tabIndex);
    WidgetsBinding.instance.addPostFrameCallback((_) => ref.read(mainTabViewIndexProvider.notifier).update((cb) => widget.tabIndex));
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final int homeNavBarIndex = ref.watch(mainTabViewIndexProvider);
    final bool isScrolled = ref.watch(isMainScrolledProvider);

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
                ref.read(mainTabViewIndexProvider.notifier).update((cb) => index);
                pageController.animateToPage(index, duration: Duration(milliseconds: 600), curve: CustomCurves.defaultIosSpring);
              }
            },
          ),

          drawer: HomeDrawer(),

          body: PageView(
            controller: pageController,
            onPageChanged: (index) {
              ref.read(mainTabViewIndexProvider.notifier).update((cb) => index);
            },
            children: [HomeTabView(), LibraryTabView(), ExploreTabView()],
          ),

          floatingActionButton: LibraryFloatingActionButton(),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
