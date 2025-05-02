import 'dart:developer';

import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:slides_sync/app/models/app_ui_model.dart';
import 'package:slides_sync/use_cases/library/library_ui_funcs.dart';

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
        decoration: LibraryUiFuncs.getBoxDecorationStyle(appUiModel.isDarkMode),
        child: Row(
          children: [
            Expanded(
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      alignment: Alignment.topCenter,
                      type: PageTransitionType.scale,
                      duration: Durations.extralong3,
                      reverseDuration: Durations.medium1,
                      curve: CustomCurves.snappySpring,
                      child: Scaffold(body: Center(child: CustomText("Add/Customize Course"))),
                    ),
                  );
                },
                style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.lightBlueAccent.withAlpha(20))),
                icon: Icon(Icons.add, size: 28),
              ),
            ),

            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.fade,
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
                    type: PageTransitionType.topToBottom,
                    duration: Durations.extralong3,
                    reverseDuration: Durations.medium1,
                    curve: CustomCurves.snappySpring,
                    child: Scaffold(body: Center(child: CustomText("Course Management"))),
                  ),
                );
              },
              style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.lightBlueAccent.withAlpha(20))),
              icon: Icon(Icons.keyboard_arrow_down, size: 28),
            ),
          ],
        ),
      ),
    );
  }
}
