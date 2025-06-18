import 'dart:developer';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/core/models/file_location.dart';
import 'package:slides_sync/data/models/course_model/sub/course_content.dart';
import 'package:slides_sync/data/models/course_model/sub/course_content_type.dart';
import 'package:slides_sync/features/main/presentation/providers/main_view_providers.dart';
import 'package:slides_sync/features/tab_home/presentation/views/home_tab_view/home_app_bar.dart';
import 'package:slides_sync/features/tab_home/presentation/views/home_tab_view/home_body.dart';
import 'package:slides_sync/features/tab_home/presentation/views/home_tab_view/home_body/recents_section/recents_section_body.dart';
import 'package:slides_sync/features/tab_home/presentation/views/sub/home_inner_scroll_view_for_desktop.dart';
import 'package:slides_sync/features/tab_home/presentation/views/sub/home_outer_scroll_view.dart';
import 'package:slides_sync/shared/helpers/device_helper.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

import 'home_tab_view/home_body/recents_section/recents_section_header.dart';
import 'home_tab_view/home_body/home_dash_board.dart';

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
