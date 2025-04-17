import 'dart:developer';
import 'dart:ui';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroine/heroine.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:slides_sync/app/models/app_ui_model.dart';
import 'package:slides_sync/components/colors.dart';
import 'package:slides_sync/views/home/sub_widgets/home_body.dart';
import 'package:slides_sync/views/home/sub_widgets/recents_section/recent_dialog.dart';
import 'package:slides_sync/views/home/sub_widgets/recents_section/recent_list_tile.dart';

List<Widget> recentSection(BuildContext context, HomeBody widget) {
  final scaffoldBgColor = Theme.of(context).scaffoldBackgroundColor;
  return [
    SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: ConstantSizing.spaceMedium),
        child: Row(
          children: [
            Expanded(child: CustomText("Recents", fontSize: 20, fontWeight: FontWeight.bold)),

            CustomTextButton(
              label: "See all",
              textColor: widget.appUiModel.isDarkMode ? SlidesRepoColors.darkTextSecondary : SlidesRepoColors.textSecondary,
              textSize: 16,
              onClick: () {},
            ),
          ],
        ),
      ),
    ),

    SliverList.builder(
      itemCount: 20,
      itemBuilder: (context, index) {
        return Heroine(
          tag: "recents_list_tile$index",
          spring: Spring.snappy,
          placeholderBuilder: (context, size, child) => child,
          child: RecentListTile(
            isDarkMode: widget.appUiModel.isDarkMode,
            title: "Context Free Grammar",
            subtitle: "Slide 4(23 pages)",
            extraContent: "This is an additional content",
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
                  appUiModel: widget.appUiModel,
                  heroTag: "recents_list_tile$index",
                  recentDialogModel: RecentDialogModel(isStarred: false, hasNote: false, title: "Figure it out", fileType: "pdf", tags: ["none", "lol"], canShare: true, canDelete: false),
                ),
              );
            },
          ),
        );
      },
    ),
  ];
}


