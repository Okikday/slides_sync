
import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroine/heroine.dart';
import 'package:slides_sync/core/models/app_ui_model.dart';
import 'package:slides_sync/features/home/presentation/viewmodels/home_vm/models/recent_dialog_model.dart';
import 'package:slides_sync/features/home/presentation/views/home_view/home_body/recent_dialog.dart';

import '../../../../../../test/dummy_slides.dart';
import '../../../viewmodels/home_vm/models/recent_list_tile_model.dart';
import 'recent_list_tile.dart';

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

          child: RecentListTile(
            isDarkMode: appUiModel.isDarkMode,
            dataModel: RecentListTileModel(
              title: DummySlides.dummySlides[index]['title'] as String? ?? "No title",
            subtitle: DummySlides.dummySlides[index]['subtitle'] as String? ?? "No subtitle",
            extraContent: DummySlides.dummySlides[index]['extraContent'] as String? ?? "",
            progressLevel: ProgressLevel.neutral,
            isStarred: false,
            progress: DummySlides.dummySlides[index]['progress'] as double?,
            onLongTapTile: () {
              LoadingDialog.showLoadingDialog(
                context,
                canPop: true,
                blurSigma: 2,
                transitionDuration: Duration(milliseconds: 550),
                loadingInfoWidget: RecentDialog(
                  scaffoldBgColor: scaffoldBgColor,
                  appUiModel: appUiModel,
                  heroTag: "recents_list_tile$index",
                  recentDialogModel: RecentDialogModel(
                    isStarred: false,
                    hasNote: false,
                    title: "Figure it out",
                    fileType: "pdf",
                    tags: ["none", "lol"],
                    canShare: true,
                    canDelete: false,
                  ),
                ),
              );
            },
            ),
          ),
        );
      },
    );
  }
}
