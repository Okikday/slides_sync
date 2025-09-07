import 'dart:developer';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/views/sub/library_floating_action_button.dart';
import 'package:slides_sync/features/main/presentation/providers/main_providers.dart';
import 'package:slides_sync/features/main/presentation/views/main_view/main_view_annotated_region.dart';
import 'package:slides_sync/features/all_tabs/tab_home/presentation/views/home_tab_view/home_drawer.dart';
import 'package:slides_sync/features/all_tabs/tab_library/presentation/views/library_tab_view.dart';
import 'package:slides_sync/features/all_tabs/tab_explore/presentation/views/explore_tab_view.dart';

import '../../../all_tabs/tab_home/presentation/views/home_tab_view.dart';
import 'main_view/bottom_nav_bar.dart';

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
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ref.read(MainProviders.mainTabViewIndexProvider.notifier).update((cb) => widget.tabIndex),
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    log("Main View build...");

    return PopScope(
      canPop: false,
      child: MainViewAnnotatedRegion(
        child: Scaffold(
          extendBody: true,
          extendBodyBehindAppBar: true,
          bottomNavigationBar: BottomNavBar(
            onTap: (index) {
              if (index != ref.read(MainProviders.mainTabViewIndexProvider.notifier).state) {
                ref.read(MainProviders.mainTabViewIndexProvider.notifier).update((cb) => index);
                pageController.animateToPage(index, duration: Duration(milliseconds: 600), curve: CustomCurves.defaultIosSpring);
              }
            },
          ),

          drawer: const HomeDrawer(),
          floatingActionButton: const LibraryFloatingActionButton(),
          
          body: PageView(
            controller: pageController,
            onPageChanged: (index) {
              ref.read(MainProviders.mainTabViewIndexProvider.notifier).update((cb) => index);
            },
            children: const [HomeTabView(), LibraryTabView(), ExploreTabView()],
          ),

        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
