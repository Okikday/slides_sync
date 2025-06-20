import 'dart:developer';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/features/main/presentation/providers/main_view_providers.dart';
import 'package:slides_sync/features/main/presentation/views/main_view/main_view_annotated_region.dart';
import 'package:slides_sync/features/tab_home/presentation/views/home_tab_view/home_drawer.dart';
import 'package:slides_sync/features/tab_library/presentation/views/library_tab_view.dart';
import 'package:slides_sync/features/tab_explore/presentation/views/explore_tab_view.dart';
import 'package:slides_sync/features/tab_library/presentation/views/sub/library_floating_action_button.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

import '../../../tab_home/presentation/views/home_tab_view.dart';
import '../../../tab_home/presentation/views/home_tab_view/home_bottom_nav_bar.dart';

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

    log("Main View build...");

    return PopScope(
      canPop: false,
      child: MainViewAnnotatedRegion(
        child: Scaffold(
          extendBody: true,
          extendBodyBehindAppBar: true,
          bottomNavigationBar: HomeBottomNavBar(
            onTap: (index) {
              if (index != ref.read(mainTabViewIndexProvider.notifier).state) {
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
