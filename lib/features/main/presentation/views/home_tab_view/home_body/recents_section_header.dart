import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/shared/styles/app_ui_context.dart';
import 'package:slides_sync/shared/styles/colors.dart';

class RecentsSectionHeader extends ConsumerWidget {
  final void Function() onClickSeeAll;
  const RecentsSectionHeader({
    super.key,
    required this.onClickSeeAll
  });

  

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
              textColor: context.isDarkMode ? SlidesRepoColors.darkTextSecondary : SlidesRepoColors.textSecondary,
              textSize: 16,
              onClick: onClickSeeAll,
            ),
          ],
        ),
      ),
    );
  }
}