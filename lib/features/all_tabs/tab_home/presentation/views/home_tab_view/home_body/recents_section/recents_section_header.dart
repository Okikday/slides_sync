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
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: ConstantSizing.spaceMedium, vertical: 0),
        child: Row(
          children: [
            Expanded(child: CustomText("Recents", fontSize: 18, fontWeight: FontWeight.bold, color: context.theme.colorScheme.tertiary,)),
      
            CustomTextButton(
              label: "See all",
              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              textColor: context.theme.colorScheme.onTertiary.withValues(alpha: 0.6),
              textSize: 14.5,
              pixelHeight: 32,
              onClick: onClickSeeAll,
            ),
          ],
        ),
      ),
    );
  }
}