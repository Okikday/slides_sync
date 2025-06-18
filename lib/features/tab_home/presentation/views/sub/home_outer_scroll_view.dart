import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/features/main/presentation/providers/main_view_providers.dart';
import 'package:slides_sync/features/tab_home/presentation/views/home_tab_view/home_app_bar.dart';

class HomeOuterScrollView extends ConsumerWidget {
  const HomeOuterScrollView({super.key, required this.body});

  final Widget body;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return NestedScrollView(
      physics: NeverScrollableScrollPhysics(),
      headerSliverBuilder: (context, isInnerBoxScrolled) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (ref.read(mainTabViewIndexProvider.notifier).state == 0) {
            final currValue = ref.read(isMainScrolledProvider.notifier).state;
            if (currValue != isInnerBoxScrolled) {
              ref.read(isMainScrolledProvider.notifier).update((cb) => isInnerBoxScrolled);
            }
          }
        });
        return [
          HomeAppBar(
            title: 'Happy Reading',
            onClickUserIcon: () {
              Scaffold.of(context).openDrawer();
              // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Theme.of(context).scaffoldBackgroundColor));
            },
            onClickNotification: () {},
          ),
        ];
      },

      body: body,
    );
  }
}

