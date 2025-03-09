import 'dart:developer';
import 'dart:ui';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/app.dart';
import 'package:slides_sync/app/states/app_ui_state.dart';
import 'package:slides_sync/components/colors.dart';
import 'package:slides_sync/views/home/sub_widgets/home_app_bar.dart';
import 'package:slides_sync/views/home/sub_widgets/home_body.dart';
import 'package:slides_sync/views/home/widgets/app_bar_container.dart';
import 'package:slides_sync/views/library/library.dart';
import 'package:slides_sync/views/profile/profile.dart';

class HomeNavBarIndex extends Notifier<int> {
  @override
  int build() => 0;
  void update(int newIndex) => state = newIndex;
}

class IsScrolled extends Notifier<bool> {
  @override
  bool build() => false;
  void update(bool newValue) {
    if (state == newValue) return;
    state = newValue;
  }
}

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> with AutomaticKeepAliveClientMixin {
  final NotifierProvider<HomeNavBarIndex, int> homeNavBarIndexProvider = NotifierProvider<HomeNavBarIndex, int>(HomeNavBarIndex.new);
  final NotifierProvider<IsScrolled, bool> isScrolledProvider = NotifierProvider<IsScrolled, bool>(IsScrolled.new);
  late final PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
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

    return AnnotatedRegion(
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
              pageController.animateToPage(index, duration: Duration(milliseconds: 800), curve: CustomCurves.defaultIosSpring);
            }
          },
        ),
        body: PageView(
          controller: pageController,
          onPageChanged: (index) {
            ref.read(homeNavBarIndexProvider.notifier).update(index);
          },
          children: [
            HomeBody(appUiModel: appUiModel, isScrolledProvider: isScrolledProvider, isScrolled: isScrolled),
            LibraryView(appUiModel: appUiModel,),
            ProfileView(),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class HomeBottomNavBar extends ConsumerWidget {
  final AppUiModel appUiModel;
  final int currentIndex;
  final bool isScrolled;
  final void Function(int index) onTap;
  const HomeBottomNavBar({super.key, required this.appUiModel, required this.currentIndex, required this.onTap, required this.isScrolled});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: isScrolled ? 8 : 0, sigmaY: isScrolled ? 8 : 0),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          selectedItemColor: Colors.deepPurple,
          onTap: (index) => onTap(index),
          backgroundColor:
              isScrolled ? Colors.lightBlueAccent.withAlpha(20) : (appUiModel.isDarkMode ? Color(0xff0e1d27) : Color(0xffd6ebf9)),
          elevation: 48,
          items: [
            BottomNavigationBarItem(icon: Icon(Iconsax.home), label: "Home", tooltip: "Home"),
            BottomNavigationBarItem(icon: Icon(Iconsax.folder), label: "Library", tooltip: "Library"),
            BottomNavigationBarItem(icon: Icon(Iconsax.profile_2user), label: "Profile", tooltip: "Profile"),
          ],
        ),
      ),
    );
  }
}
