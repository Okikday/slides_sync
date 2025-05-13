
import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:slides_sync/core/utils/app_ui_state.dart';
import 'package:slides_sync/features/course_mgmt/presentation/views/manage_courses_page.dart';
import 'package:slides_sync/shared/styles/external/ui_styles.dart';

class LibraryViewHeader extends ConsumerWidget {
  final AppUiModel appUiModel;
  const LibraryViewHeader({super.key, required this.appUiModel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverToBoxAdapter(
      child: Container(
        height: 100,
        margin: EdgeInsets.symmetric(horizontal: 12),
        padding: EdgeInsets.symmetric(horizontal: 16),
        decoration: UiStyles.getBlueThemedBoxDecoration(appUiModel.isDarkMode),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageTransition(
                    alignment: Alignment.topLeft,
                    type: PageTransitionType.scale,
                    duration: Durations.extralong3,
                    reverseDuration: Durations.medium1,
                    curve: CustomCurves.snappySpring,
                    child: ManageCoursesPage(appUiStateProvider),
                  ),
                );
              },
              style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.lightBlueAccent.withAlpha(20))),
              icon: Icon(Icons.add, size: 28),
            ),

            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageTransition(
                    alignment: Alignment.topCenter,
                    type: PageTransitionType.scale,
                    duration: Durations.extralong3,
                    reverseDuration: Durations.medium1,
                    curve: CustomCurves.snappySpring,
                    child: Scaffold(body: Center(child: CustomText("Filter"))),
                  ),
                );
              },
              padding: EdgeInsets.all(10),
              style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.lightBlueAccent.withAlpha(20))),
              icon: Icon(Iconsax.filter_edit_copy),
            ),

            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageTransition(
                    alignment: Alignment.topRight,
                    type: PageTransitionType.scale,
                    duration: Durations.extralong3,
                    reverseDuration: Durations.medium1,
                    curve: CustomCurves.snappySpring,
                    child: Scaffold(body: Center(child: CustomText("Archive"))),
                  ),
                );
              },
              style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.lightBlueAccent.withAlpha(20))),
              icon: Icon(Iconsax.archive_copy, size: 28),
            ),
          ],
        ),
      ),
    );
  }
}
