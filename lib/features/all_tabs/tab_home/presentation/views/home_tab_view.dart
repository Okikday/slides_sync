import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/features/all_tabs/tab_home/presentation/views/home_tab_view/home_body.dart';
import 'package:slides_sync/features/all_tabs/tab_home/presentation/views/sub/home_inner_scroll_view_for_desktop.dart';
import 'package:slides_sync/features/all_tabs/tab_home/presentation/views/sub/home_outer_scroll_view.dart';
import 'package:slides_sync/shared/helpers/device_helper.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';
import 'package:slides_sync/shared/strings/asset_strings.dart';
import 'package:slides_sync/shared/styles/colors.dart';


class HomeTabView extends ConsumerStatefulWidget {
  const HomeTabView({super.key});

  @override
  ConsumerState createState() => _HomeTabViewState();
}

class _HomeTabViewState extends ConsumerState<HomeTabView> with AutomaticKeepAliveClientMixin {
  

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final bool isDesktop = DeviceHelper.getDeviceType(context) == DeviceType.desktop;

    log("Home Tab View build...");

    return HomeOuterScrollView(body: isDesktop ? HomeInnerScrollViewForDesktop() : HomeBody());
  }

  @override
  bool get wantKeepAlive => true;
}
