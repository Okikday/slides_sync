import 'package:custom_widgets_toolkit/custom_widgets_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slides_sync/shared/helpers/extension_helper.dart';

class RecentsSectionHeader extends ConsumerWidget {
  final void Function() onClickSeeAll;
  const RecentsSectionHeader({
    super.key,
    required this.onClickSeeAll
  });

  

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.theme;
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: ConstantSizing.spaceMedium, vertical: 0),
        child: Row(
          children: [
            Expanded(
              child: CustomText(
                "Recents",
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.onBackground,
              ),
            ),
      
            CustomTextButton(
              label: "See all",
              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              textColor: theme.supportingText.withValues(alpha: 0.9),
              textSize: 14,
              pixelHeight: 32,
              onClick: onClickSeeAll,
            ),
          ],
        ),
      ),
    );
  }
}