import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/features/all_tabs/tab_home/presentation/views/home_tab_view/home_app_bar.dart';
import 'package:slides_sync/features/all_tabs/tab_home/presentation/views/home_tab_view/home_body.dart';
import 'package:slides_sync/features/main/presentation/providers/main_providers.dart';

class HomeTabView extends ConsumerStatefulWidget {
  const HomeTabView({super.key});

  @override
  ConsumerState createState() => _HomeTabViewState();
}

class _HomeTabViewState extends ConsumerState<HomeTabView> with AutomaticKeepAliveClientMixin {
  late final ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    scrollController.addListener(scrollListener);
  }

  void scrollListener() {
    if (scrollController.offset > 40) {
      final isScrolledProvider = ref.read(MainProviders.isMainScrolledProvider.notifier);
      if (!isScrolledProvider.state) {
        isScrolledProvider.update((cb) => true);
      }
    } else {
      final isScrolledProvider = ref.read(MainProviders.isMainScrolledProvider.notifier);
      if (isScrolledProvider.state) {
        isScrolledProvider.update((cb) => false);
      }
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  void focusModeListener(bool? prev, bool next) {
    if (next) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    ref.listen<bool>(MainProviders.isFocusModeProvider, focusModeListener);
    return NestedScrollView(
      controller: scrollController,
      // physics: NeverScrollableScrollPhysics(),
      headerSliverBuilder: (context, isInnerBoxScrolled) {
        return [
          HomeAppBar(
            title: 'Welcome back',
            onClickUserIcon: () {
              Scaffold.of(context).openDrawer();
              // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Theme.of(context).scaffoldBackgroundColor));
            },
            onClickNotification: () {
              final focusModeProvider = ref.read(MainProviders.isFocusModeProvider.notifier);
              focusModeProvider.update((cb) => !cb);

              UiUtils.showFlushBar(context, msg: "Focus mode toggled");
            },
          ),
        ];
      },

      body: HomeBody(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
