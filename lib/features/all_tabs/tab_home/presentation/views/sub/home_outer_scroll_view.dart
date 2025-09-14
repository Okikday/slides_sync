import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/features/main/presentation/providers/main_providers.dart';
import 'package:slides_sync/features/all_tabs/tab_home/presentation/views/home_tab_view/home_app_bar.dart';

class HomeOuterScrollView extends ConsumerStatefulWidget {
  const HomeOuterScrollView({super.key, required this.body});

  final Widget body;

  @override
  ConsumerState<HomeOuterScrollView> createState() => _HomeOuterScrollViewState();
}

class _HomeOuterScrollViewState extends ConsumerState<HomeOuterScrollView> {

  void focusModeListener(bool? prev, bool next){
    if (next) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
  }
  @override
  Widget build(BuildContext context) {
    ref.listen<bool>(MainProviders.isFocusModeProvider, focusModeListener);
    return NestedScrollView(
      physics: NeverScrollableScrollPhysics(),
      headerSliverBuilder: (context, isInnerBoxScrolled) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (ref.read(MainProviders.mainTabViewIndexProvider.notifier).state == 0) {
            final currValue = ref.read(MainProviders.isMainScrolledProvider.notifier).state;
            if (currValue != isInnerBoxScrolled) {
              ref.read(MainProviders.isMainScrolledProvider.notifier).update((cb) => isInnerBoxScrolled);
            }
          }
        });
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

      body: widget.body,
    );
  }
}
