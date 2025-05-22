
import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroine/heroine.dart';
import 'package:slides_sync/features/home/presentation/viewmodels/home_vm/models/recent_dialog_model.dart';
import 'package:slides_sync/features/home/presentation/views/home_view/home_body/recent_dialog.dart';
import 'package:slides_sync/shared/styles/app_ui_context.dart';

import '../../../../../../test/dummy_slides.dart';
import '../../../viewmodels/home_vm/models/recent_list_tile_model.dart';
import 'recent_list_tile.dart';

class RecentsSectionBody extends ConsumerWidget {
  const RecentsSectionBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return SliverList.builder(
      itemCount: DummySlides.dummySlides.length,
      itemBuilder: (context, index) {
        return Heroine(
          tag: "recents_list_tile$index",
          spring: Spring.snappy.copyWith(durationSeconds: 0.3),

          child: RecentListTile(
            isDarkMode: context.isDarkMode,
            dataModel: RecentListTileModel(
              title: DummySlides.dummySlides[index]['title'] as String? ?? "No title",
            subtitle: DummySlides.dummySlides[index]['subtitle'] as String? ?? "No subtitle",
            // extraContent: DummySlides.dummySlides[index]['extraContent'] as String? ?? "",
            progressLevel: ProgressLevel.neutral,
            isStarred: false,
            progress: DummySlides.dummySlides[index]['progress'] as double?,
            onLongTapTile: () {
              LoadingDialog.showLoadingDialog(
                context,
                canPop: true,
                blurSigma: 4,
                barrierColor: Colors.black.withValues(alpha: 0.4),
                transitionDuration: Duration(milliseconds: 550),
                loadingInfoWidget: RecentDialog(
                  scaffoldBgColor: context.scaffoldBackgroundColor,
                  heroTag: "recents_list_tile$index",
                  recentDialogModel: RecentDialogModel(
                    isStarred: false,
                    title: DummySlides.dummySlides[index]['title'] as String? ?? "No title",
                    description: DummySlides.dummySlides[index]['extraContent'] as String? ?? "",
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
