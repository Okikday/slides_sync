import 'dart:developer';
import 'dart:ui';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroine/heroine.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/app/models/app_ui_model.dart';
import 'package:slides_sync/components/colors.dart';
import 'package:slides_sync/dummy/dummy_slides.dart';
import 'package:slides_sync/views/home/sub_widgets/home_body.dart';
import 'package:slides_sync/views/home/sub_widgets/recents_section/recent_dialog.dart';
import 'package:slides_sync/views/home/sub_widgets/recents_section/recent_list_tile.dart';




class RecentsSectionBody extends ConsumerWidget {
  final AppUiModel appUiModel;
  const RecentsSectionBody({super.key, required this.appUiModel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scaffoldBgColor = Theme.of(context).scaffoldBackgroundColor;
    return SliverList.builder(
      itemCount: DummySlides.dummySlides.length,
      itemBuilder: (context, index) {
        return Heroine(
          tag: "recents_list_tile$index",
          spring: Spring.snappy.copyWith(durationSeconds: 0.3),
          placeholderBuilder: (context, size, child) => child,
          child: RecentListTile(
            isDarkMode: appUiModel.isDarkMode,
            title: DummySlides.dummySlides[index]['title'] ?? "No title",
            subtitle: DummySlides.dummySlides[index]['subtitle'] ?? "No subtitle",
            extraContent: DummySlides.dummySlides[index]['extraContent'] ?? "",
            level: 2,
            onTapTile: () {},
            onLongTapTile: () {
              LoadingDialog.showLoadingDialog(
                context,
                canPop: true,
                blurSigma: 2,
                reverseTransitionDuration: Duration(milliseconds: 550),
                loadingInfoWidget: RecentDialog(
                  scaffoldBgColor: scaffoldBgColor,
                  appUiModel: appUiModel,
                  heroTag: "recents_list_tile$index",
                  recentDialogModel: RecentDialogModel(isStarred: false, hasNote: false, title: "Figure it out", fileType: "pdf", tags: ["none", "lol"], canShare: true, canDelete: false),
                ),
              );
            },
          ),
        );
      },
    );
  }
}


