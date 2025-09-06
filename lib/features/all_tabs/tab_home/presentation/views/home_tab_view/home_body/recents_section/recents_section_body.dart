import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:slides_sync/core/utils/ui_utils.dart';
import 'package:slides_sync/domain/models/course_model/course.dart';
import 'package:slides_sync/features/all_tabs/tab_home/presentation/viewmodels/recent_dialog_model.dart';
import 'package:slides_sync/features/all_tabs/tab_home/presentation/views/home_tab_view/home_body/recents_section/recent_dialog.dart';
import 'package:slides_sync/shared/assets/strings/icon_strings.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

import '../../../../../../../../test/dummy_slides.dart';
import '../../../../viewmodels/recent_list_tile_model.dart';
import 'recent_list_tile.dart';

class RecentsSectionBody extends ConsumerWidget {
  final List<CourseContent> recentCourses;
  const RecentsSectionBody({super.key, this.recentCourses = const <CourseContent>[]});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.theme;
    if (recentCourses.isEmpty) {
      return SliverToBoxAdapter(
        child: ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            SizedBox.square(dimension: context.deviceWidth * 0.5, child: LottieBuilder.asset(IconStrings.instance.roundedPlayingFace, reverse: true,)),
        
            ConstantSizing.columnSpacingHuge,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: CustomElevatedButton(
                backgroundColor: theme.primaryColor,
                borderRadius: 12,
                pixelHeight: 44,
                label: "Explore Courses",
                textSize: 15,
                textColor: theme.onPrimaryText,
              ),
            ),
          ],
        ),
      );
    }


    return SliverPadding(
      padding: EdgeInsets.only(
        bottom: kBottomNavigationBarHeight + context.bottomPadding / 2,
      ),
      sliver: SliverList.builder(
        itemCount: DummySlides.dummySlides.length,
        itemBuilder: (context, index) {
          return RecentListTile(
            isDarkMode: context.isDarkMode,
            tilePadding: context.hPadding5,
            dataModel: RecentListTileModel(
              title:
                  DummySlides.dummySlides[index]['title'] as String? ??
                  "No title",
              subtitle:
                  DummySlides.dummySlides[index]['subtitle'] as String? ??
                  "No subtitle",
              // extraContent: DummySlides.dummySlides[index]['extraContent'] as String? ?? "",
              progressLevel: ProgressLevel.neutral,
              isStarred: false,
              progress: DummySlides.dummySlides[index]['progress'] as double?,
              onLongTapTile: () {
                UiUtils.showCustomDialog(
                  context,
                  canPop: true,
                  blurSigma: Offset(2.0, 2.0),
                  transitionType: TransitionType.cupertinoDialog,
                  barrierColor: Colors.black.withValues(alpha: 0.5),
                  transitionDuration: Durations.short4,
                  reverseTransitionDuration: Durations.short4,
                  child: RecentDialog(
                    recentDialogModel: RecentDialogModel(
                      isStarred: false,
                      title:
                          DummySlides.dummySlides[index]['title'] as String? ??
                          "No title",
                      description:
                          DummySlides.dummySlides[index]['extraContent']
                              as String? ??
                          "",
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
