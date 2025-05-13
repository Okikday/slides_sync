import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_transition/page_transition.dart';
import 'package:slides_sync/app/models/app_ui_model.dart';
import 'package:slides_sync/components/colors.dart';

class RecentsSectionHeader extends ConsumerWidget {
  const RecentsSectionHeader({
    super.key,
    required this.appUiModel,
  });

  final AppUiModel appUiModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: ConstantSizing.spaceMedium),
        child: Row(
          children: [
            Expanded(child: CustomText("Recents", fontSize: 20, fontWeight: FontWeight.bold)),

            CustomTextButton(
              label: "See all",
              textColor: appUiModel.isDarkMode ? SlidesRepoColors.darkTextSecondary : SlidesRepoColors.textSecondary,
              textSize: 16,
              onClick: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.bottomToTop,
                    duration: Durations.extralong3,
                    reverseDuration: Durations.medium1,
                    curve: CustomCurves.snappySpring,
                    child: Scaffold(appBar: AppBar(title: CustomText("Recents"),), body: Center(child: CustomText("Recents"))),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}