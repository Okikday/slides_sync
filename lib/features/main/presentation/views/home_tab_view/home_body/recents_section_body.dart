import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroine/heroine.dart';
import 'package:lottie/lottie.dart';
import 'package:slides_sync/data/models/course_model/course_model.dart';
import 'package:slides_sync/features/main/presentation/viewmodels/home_vm/models/recent_dialog_model.dart';
import 'package:slides_sync/features/main/presentation/views/home_tab_view/home_body/recent_dialog.dart';
import 'package:slides_sync/shared/strings/icon_strings.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

import '../../../../../../test/dummy_slides.dart';
import '../../../viewmodels/home_vm/models/recent_list_tile_model.dart';
import 'recent_list_tile.dart';

class RecentsSectionBody extends ConsumerWidget {
  final List<CourseContent> recentCourses;
  const RecentsSectionBody({super.key, this.recentCourses = const <CourseContent>[]});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (recentCourses.isEmpty) {
      return SliverToBoxAdapter(
        child: ListView(
          shrinkWrap: true,
          children: [
            SizedBox.square(dimension: context.deviceWidth * 0.5, child: LottieBuilder.asset(IconStrings.instance.roundedPlayingFace, reverse: true,)),
        
            ConstantSizing.columnSpacingHuge,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: CustomElevatedButton(
                backgroundColor: Colors.deepPurple,
                borderRadius: 12,
                pixelHeight: 44,
                label: "Explore Courses",
                textSize: 15,
                textColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    return SliverPadding(
      padding: EdgeInsets.only(bottom: kBottomNavigationBarHeight),
      sliver: SliverList.builder(
        itemCount: DummySlides.dummySlides.length,
      
        itemBuilder: (context, index) {
          return Heroine(
            tag: "recents_list_tile$index",
            spring: Spring.snappy.copyWith(durationSeconds: 0.4),
      
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
                  CustomDialog.show(
                    context,
                    canPop: true,
                    blurSigma: Offset(4.0, 4.0),
                    transitionType: TransitionType.fade,
                    barrierColor: Colors.black.withValues(alpha: 0.4),
                    transitionDuration: Duration(milliseconds: 550),
                    child: RecentDialog(
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
      ),
    );
  }
}
